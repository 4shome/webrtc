/*
 *  Copyright 2012 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "p2p/test/turn_server.h"

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <memory>
#include <string>
#include <tuple>  // for std::tie
#include <utility>

#include "absl/algorithm/container.h"
#include "absl/memory/memory.h"
#include "absl/strings/string_view.h"
#include "api/array_view.h"
#include "api/packet_socket_factory.h"
#include "api/sequence_checker.h"
#include "api/task_queue/pending_task_safety_flag.h"
#include "api/task_queue/task_queue_base.h"
#include "api/transport/stun.h"
#include "api/units/time_delta.h"
#include "p2p/base/async_stun_tcp_socket.h"
#include "p2p/base/port_interface.h"
#include "rtc_base/async_packet_socket.h"
#include "rtc_base/byte_buffer.h"
#include "rtc_base/byte_order.h"
#include "rtc_base/checks.h"
#include "rtc_base/crypto_random.h"
#include "rtc_base/ip_address.h"
#include "rtc_base/logging.h"
#include "rtc_base/message_digest.h"
#include "rtc_base/network/received_packet.h"
#include "rtc_base/socket.h"
#include "rtc_base/socket_address.h"
#include "rtc_base/ssl_adapter.h"
#include "rtc_base/string_encode.h"
#include "rtc_base/strings/string_builder.h"
#include "rtc_base/time_utils.h"

namespace webrtc {
namespace {
using ::webrtc::TimeDelta;

// TODO(juberti): Move this all to a future turnmessage.h
//  static const int IPPROTO_UDP = 17;
constexpr TimeDelta kNonceTimeout = TimeDelta::Minutes(60);
constexpr TimeDelta kDefaultAllocationTimeout = TimeDelta::Minutes(2);

constexpr size_t kNonceKeySize = 16;
constexpr size_t kNonceSize = 48;

constexpr size_t TURN_CHANNEL_HEADER_SIZE = 4U;

// TODO(mallinath): Move these to a common place.
bool IsTurnChannelData(uint16_t msg_type) {
  // The first two bits of a channel data message are 0b01.
  return ((msg_type & 0xC000) == 0x4000);
}

}  // namespace

int GetStunSuccessResponseTypeOrZero(const StunMessage& req) {
  const int resp_type = GetStunSuccessResponseType(req.type());
  return resp_type == -1 ? 0 : resp_type;
}

int GetStunErrorResponseTypeOrZero(const StunMessage& req) {
  const int resp_type = GetStunErrorResponseType(req.type());
  return resp_type == -1 ? 0 : resp_type;
}

static void InitErrorResponse(int code,
                              absl::string_view reason,
                              StunMessage* resp) {
  resp->AddAttribute(std::make_unique<StunErrorCodeAttribute>(
      STUN_ATTR_ERROR_CODE, code, std::string(reason)));
}

TurnServer::TurnServer(TaskQueueBase* thread)
    : thread_(thread),
      nonce_key_(CreateRandomString(kNonceKeySize)),
      auth_hook_(NULL),
      redirect_hook_(NULL),
      enable_otu_nonce_(false) {}

TurnServer::~TurnServer() {
  RTC_DCHECK_RUN_ON(thread_);
  for (InternalSocketMap::iterator it = server_sockets_.begin();
       it != server_sockets_.end(); ++it) {
    AsyncPacketSocket* socket = it->first;
    delete socket;
  }

  for (ServerSocketMap::iterator it = server_listen_sockets_.begin();
       it != server_listen_sockets_.end(); ++it) {
    Socket* socket = it->first;
    delete socket;
  }
}

void TurnServer::AddInternalSocket(AsyncPacketSocket* socket,
                                   ProtocolType proto) {
  RTC_DCHECK_RUN_ON(thread_);
  RTC_DCHECK(server_sockets_.end() == server_sockets_.find(socket));
  server_sockets_[socket] = proto;
  socket->RegisterReceivedPacketCallback(
      [&](AsyncPacketSocket* socket, const ReceivedIpPacket& packet) {
        RTC_DCHECK_RUN_ON(thread_);
        OnInternalPacket(socket, packet);
      });
}

void TurnServer::AddInternalServerSocket(
    Socket* socket,
    ProtocolType proto,
    std::unique_ptr<SSLAdapterFactory> ssl_adapter_factory) {
  RTC_DCHECK_RUN_ON(thread_);

  RTC_DCHECK(server_listen_sockets_.end() ==
             server_listen_sockets_.find(socket));
  server_listen_sockets_[socket] = {proto, std::move(ssl_adapter_factory)};
  socket->SignalReadEvent.connect(this, &TurnServer::OnNewInternalConnection);
}

void TurnServer::SetExternalSocketFactory(PacketSocketFactory* factory,
                                          const SocketAddress& external_addr) {
  RTC_DCHECK_RUN_ON(thread_);
  external_socket_factory_.reset(factory);
  external_addr_ = external_addr;
}

void TurnServer::OnNewInternalConnection(Socket* socket) {
  RTC_DCHECK_RUN_ON(thread_);
  RTC_DCHECK(server_listen_sockets_.find(socket) !=
             server_listen_sockets_.end());
  AcceptConnection(socket);
}

void TurnServer::AcceptConnection(Socket* server_socket) {
  RTC_DCHECK_RUN_ON(thread_);

  // Check if someone is trying to connect to us.
  SocketAddress accept_addr;
  Socket* accepted_socket = server_socket->Accept(&accept_addr);
  if (accepted_socket != NULL) {
    RTC_LOG(LS_INFO) << "Received internal TCP connection from address '"
        << accepted_socket->GetRemoteAddress().ToString() << "'.";
    const ServerSocketInfo& info = server_listen_sockets_[server_socket];
    if (info.ssl_adapter_factory) {
      SSLAdapter* ssl_adapter =
          info.ssl_adapter_factory->CreateAdapter(accepted_socket);
      ssl_adapter->StartSSL("");
      accepted_socket = ssl_adapter;
    }
    AsyncStunTCPSocket* tcp_socket = new AsyncStunTCPSocket(accepted_socket);

    tcp_socket->SubscribeCloseEvent(this,
                                    [this](AsyncPacketSocket* s, int err) {
                                      OnInternalSocketClose(s, err);
                                    });
    // Finally add the socket so it can start communicating with the client.
    AddInternalSocket(tcp_socket, info.proto);
  }
}

void TurnServer::OnInternalSocketClose(AsyncPacketSocket* socket, int err) {
  RTC_LOG(LS_INFO) << "Internal TCP socket from '" << socket->GetRemoteAddress().ToString()
      << "' closed.";
  auto iter = internal_tcp_sock_to_alloc_.find(socket);
  if (iter != internal_tcp_sock_to_alloc_.end()) {
    DestroyAllocation(iter->second);
  } else {
    RTC_LOG(LS_WARNING) << "Destroying unknown internal socket!";
    DestroyInternalSocket(socket);
  }
}

void TurnServer::OnInternalPacket(AsyncPacketSocket* socket,
                                  const ReceivedIpPacket& packet) {
  RTC_DCHECK_RUN_ON(thread_);
  // Fail if the packet is too small to even contain a channel header.
  if (packet.payload().size() < TURN_CHANNEL_HEADER_SIZE) {
    return;
  }
  InternalSocketMap::iterator iter = server_sockets_.find(socket);
  RTC_DCHECK(iter != server_sockets_.end());
  TurnServerConnection conn(packet.source_address(), iter->second, socket);
  uint16_t msg_type = webrtc::GetBE16(packet.payload().data());
  if (!IsTurnChannelData(msg_type)) {
    // This is a STUN message.
    HandleStunMessage(&conn, packet.payload());
  } else {
    // This is a channel message; let the allocation handle it.
    TurnServerAllocation* allocation = FindAllocation(&conn);
    if (allocation) {
      allocation->HandleChannelData(packet.payload());
    }
    if (stun_message_observer_ != nullptr) {
      stun_message_observer_->ReceivedInternalData(allocation, packet.payload());
    }
  }
}

void TurnServer::HandleStunMessage(TurnServerConnection* conn,
                                   ArrayView<const uint8_t> payload) {
  RTC_DCHECK_RUN_ON(thread_);
  TurnMessage msg;
  ByteBufferReader buf(payload);
  if (!msg.Read(&buf) || (buf.Length() > 0)) {
    RTC_LOG(LS_WARNING) << "Received invalid STUN message";
    return;
  }

  if (stun_message_observer_ != nullptr) {
    stun_message_observer_->ReceivedMessage(conn, &msg);
  }

  // If it's a STUN binding request, handle that specially.
  if (msg.type() == STUN_BINDING_REQUEST) {
    HandleBindingRequest(conn, &msg);
    return;
  }

  if (redirect_hook_ != NULL && msg.type() == STUN_ALLOCATE_REQUEST) {
    SocketAddress address;
    if (redirect_hook_->ShouldRedirect(conn->src(), &address)) {
      SendErrorResponseWithAlternateServer(conn, &msg, address);
      return;
    }
  }

  // Look up the key that we'll use to validate the M-I. If we have an
  // existing allocation, the key will already be cached.
  TurnServerAllocation* allocation = FindAllocation(conn);
  std::string key;
  IPAddress expected_peer_ip;
  if (!allocation) {
    GetKey(conn, &msg, &key, &expected_peer_ip);
  } else {
    key = allocation->key();
  }

  // Ensure the message is authorized; only needed for requests.
  if (IsStunRequestType(msg.type())) {
    if (!CheckAuthorization(conn, &msg, key)) {
      return;
    }
  }

  if (!allocation && msg.type() == STUN_ALLOCATE_REQUEST) {
    HandleAllocateRequest(conn, &msg, key, expected_peer_ip);
  } else if (allocation &&
             (msg.type() != STUN_ALLOCATE_REQUEST ||
              msg.transaction_id() == allocation->transaction_id())) {
    // This is a non-allocate request, or a retransmit of an allocate.
    // Check that the username matches the previous username used.
    if (IsStunRequestType(msg.type()) &&
        msg.GetByteString(STUN_ATTR_USERNAME)->string_view() !=
            allocation->username()) {
      SendErrorResponse(conn, &msg, STUN_ERROR_WRONG_CREDENTIALS,
                        STUN_ERROR_REASON_WRONG_CREDENTIALS);
      return;
    }
    allocation->HandleTurnMessage(&msg);
    if (stun_message_observer_ != nullptr) {
      stun_message_observer_->ReceivedInternalData(allocation, payload);
    }
  } else {
    // Allocation mismatch.
    SendErrorResponse(conn, &msg, STUN_ERROR_ALLOCATION_MISMATCH,
                      STUN_ERROR_REASON_ALLOCATION_MISMATCH);
  }
}

bool TurnServer::GetKey(const TurnServerConnection* conn,
                        const StunMessage* msg, std::string* key,
                        IPAddress* expected_peer_ip) {
  const StunByteStringAttribute* username_attr =
      msg->GetByteString(STUN_ATTR_USERNAME);
  if (!username_attr) {
    return false;
  }

  const std::string username = std::string(username_attr->string_view());
  return (auth_hook_ != NULL && auth_hook_->GetKey(
      conn, username, realm_, key, expected_peer_ip));
}

bool TurnServer::CheckAuthorization(TurnServerConnection* conn,
                                    StunMessage* msg,
                                    absl::string_view key) {
  // RFC 5389, 10.2.2.
  RTC_DCHECK(IsStunRequestType(msg->type()));
  const StunByteStringAttribute* mi_attr =
      msg->GetByteString(STUN_ATTR_MESSAGE_INTEGRITY);
  const StunByteStringAttribute* username_attr =
      msg->GetByteString(STUN_ATTR_USERNAME);
  const StunByteStringAttribute* realm_attr =
      msg->GetByteString(STUN_ATTR_REALM);
  const StunByteStringAttribute* nonce_attr =
      msg->GetByteString(STUN_ATTR_NONCE);

  // Fail if no MESSAGE_INTEGRITY.
  if (!mi_attr) {
    SendErrorResponseWithRealmAndNonce(conn, msg, STUN_ERROR_UNAUTHORIZED,
                                       STUN_ERROR_REASON_UNAUTHORIZED);
    return false;
  }

  // Fail if there is MESSAGE_INTEGRITY but no username, nonce, or realm.
  if (!username_attr || !realm_attr || !nonce_attr) {
    SendErrorResponse(conn, msg, STUN_ERROR_BAD_REQUEST,
                      STUN_ERROR_REASON_BAD_REQUEST);
    return false;
  }

  // Fail if bad nonce.
  if (!ValidateNonce(nonce_attr->string_view())) {
    SendErrorResponseWithRealmAndNonce(conn, msg, STUN_ERROR_STALE_NONCE,
                                       STUN_ERROR_REASON_STALE_NONCE);
    return false;
  }

  // Fail if bad MESSAGE_INTEGRITY.
  if (key.empty() || msg->ValidateMessageIntegrity(std::string(key)) !=
                         StunMessage::IntegrityStatus::kIntegrityOk) {
    RTC_LOG(LS_WARNING) << "No key or invalid MESSAGE_INTEGRITY.";
    SendErrorResponseWithRealmAndNonce(conn, msg, STUN_ERROR_UNAUTHORIZED,
                                       STUN_ERROR_REASON_UNAUTHORIZED);
    return false;
  }

  // Fail if one-time-use nonce feature is enabled.
  TurnServerAllocation* allocation = FindAllocation(conn);
  if (enable_otu_nonce_ && allocation &&
      allocation->last_nonce() == nonce_attr->string_view()) {
    SendErrorResponseWithRealmAndNonce(conn, msg, STUN_ERROR_STALE_NONCE,
                                       STUN_ERROR_REASON_STALE_NONCE);
    return false;
  }

  if (allocation) {
    allocation->set_last_nonce(nonce_attr->string_view());
  }
  // Success.
  return true;
}

void TurnServer::HandleBindingRequest(TurnServerConnection* conn,
                                      const StunMessage* req) {
  StunMessage response(GetStunSuccessResponseTypeOrZero(*req),
                       req->transaction_id());
  // Tell the user the address that we received their request from.
  auto mapped_addr_attr = std::make_unique<StunXorAddressAttribute>(
      STUN_ATTR_XOR_MAPPED_ADDRESS, conn->src());
  response.AddAttribute(std::move(mapped_addr_attr));

  SendStun(conn, &response);
}

void TurnServer::HandleAllocateRequest(TurnServerConnection* conn,
                                       const TurnMessage* msg,
                                       absl::string_view key,
                                       const IPAddress& expected_peer_ip) {
  // Check the parameters in the request.
  const StunUInt32Attribute* transport_attr =
      msg->GetUInt32(STUN_ATTR_REQUESTED_TRANSPORT);
  if (!transport_attr) {
    SendErrorResponse(conn, msg, STUN_ERROR_BAD_REQUEST,
                      STUN_ERROR_REASON_BAD_REQUEST);
    return;
  }

  int proto = transport_attr->value() >> 24;
  if (proto != IPPROTO_UDP && proto != IPPROTO_TCP) {
    SendErrorResponse(conn, msg, STUN_ERROR_UNSUPPORTED_PROTOCOL,
                      STUN_ERROR_REASON_UNSUPPORTED_PROTOCOL);
    return;
  }

  // Create the allocation and let it send the success response.
  // If the actual socket allocation fails, send an internal error.
  TurnServerAllocation* alloc = CreateAllocation(conn, proto, key,
                                                 expected_peer_ip);
  if (alloc) {
    alloc->HandleTurnMessage(msg);
  } else {
    SendErrorResponse(conn, msg, STUN_ERROR_SERVER_ERROR,
                      "Failed to allocate socket");
  }
}

std::string TurnServer::GenerateNonce(int64_t now) const {
  // Generate a nonce of the form hex(now + HMAC-MD5(nonce_key_, now))
  std::string input(reinterpret_cast<const char*>(&now), sizeof(now));
  std::string nonce = hex_encode(input);
  nonce += ComputeHmac(DIGEST_MD5, nonce_key_, input);
  RTC_DCHECK(nonce.size() == kNonceSize);

  return nonce;
}

bool TurnServer::ValidateNonce(absl::string_view nonce) const {
  // Check the size.
  if (nonce.size() != kNonceSize) {
    return false;
  }

  // Decode the timestamp.
  int64_t then;
  char* p = reinterpret_cast<char*>(&then);
  size_t len = hex_decode(ArrayView<char>(p, sizeof(then)),
                          nonce.substr(0, sizeof(then) * 2));
  if (len != sizeof(then)) {
    return false;
  }

  // Verify the HMAC.
  if (nonce.substr(sizeof(then) * 2) !=
      ComputeHmac(DIGEST_MD5, nonce_key_, std::string(p, sizeof(then)))) {
    return false;
  }

  // Validate the timestamp.
  return TimeDelta::Millis(TimeMillis() - then) < kNonceTimeout;
}

TurnServerAllocation* TurnServer::FindAllocation(TurnServerConnection* conn) {
  AllocationMap::const_iterator it = allocations_.find(*conn);
  return (it != allocations_.end()) ? it->second.get() : nullptr;
}

TurnServerAllocation* TurnServer::CreateAllocation(TurnServerConnection* conn,
                                                   int proto,
                                                   absl::string_view key,
                                                   const IPAddress& expected_peer_ip) {
  if (external_socket_factory_ == nullptr) return nullptr;
  AsyncPacketSocket* external_udp_socket = nullptr;
  AsyncListenSocket* external_listen_socket = nullptr;
  if (proto == IPPROTO_UDP) {
    external_udp_socket = external_socket_factory_->CreateUdpSocket(external_addr_, 0, 0);
  } else if (proto == IPPROTO_TCP) {
    external_listen_socket = external_socket_factory_->CreateServerTcpSocket(external_addr_, 0, 0, 0);
  }
  if (external_udp_socket == nullptr && external_listen_socket == nullptr) {
    return nullptr;
  }

  // The Allocation takes ownership of the socket.
  TurnServerAllocation* allocation = new TurnServerAllocation(
      this, thread_, *conn, external_udp_socket, external_listen_socket, key, expected_peer_ip);
  allocations_[*conn].reset(allocation);
  {
    InternalSocketMap::iterator iter = server_sockets_.find(conn->socket());
    if (iter != server_sockets_.end() && iter->second != PROTO_UDP) {
      internal_tcp_sock_to_alloc_[conn->socket()] = allocation;
    }
  }
  if (stun_message_observer_) {
    stun_message_observer_->CreatedAllocation(allocation);
  }
  return allocation;
}

void TurnServer::SendErrorResponse(TurnServerConnection* conn,
                                   const StunMessage* req,
                                   int code,
                                   absl::string_view reason) {
  RTC_DCHECK_RUN_ON(thread_);
  TurnMessage resp(GetStunErrorResponseTypeOrZero(*req), req->transaction_id());
  InitErrorResponse(code, reason, &resp);

  RTC_LOG(LS_INFO) << "Sending error response, type=" << resp.type()
                   << ", code=" << code << ", reason=" << reason;
  SendStun(conn, &resp);
}

void TurnServer::SendErrorResponseWithRealmAndNonce(TurnServerConnection* conn,
                                                    const StunMessage* msg,
                                                    int code,
                                                    absl::string_view reason) {
  TurnMessage resp(GetStunErrorResponseTypeOrZero(*msg), msg->transaction_id());
  InitErrorResponse(code, reason, &resp);

  int64_t timestamp = TimeMillis();
  if (ts_for_next_nonce_) {
    timestamp = ts_for_next_nonce_;
    ts_for_next_nonce_ = 0;
  }
  resp.AddAttribute(std::make_unique<StunByteStringAttribute>(
      STUN_ATTR_NONCE, GenerateNonce(timestamp)));
  resp.AddAttribute(
      std::make_unique<StunByteStringAttribute>(STUN_ATTR_REALM, realm_));
  SendStun(conn, &resp);
}

void TurnServer::SendErrorResponseWithAlternateServer(
    TurnServerConnection* conn,
    const StunMessage* msg,
    const SocketAddress& addr) {
  TurnMessage resp(GetStunErrorResponseTypeOrZero(*msg), msg->transaction_id());
  InitErrorResponse(STUN_ERROR_TRY_ALTERNATE,
                    STUN_ERROR_REASON_TRY_ALTERNATE_SERVER, &resp);
  resp.AddAttribute(
      std::make_unique<StunAddressAttribute>(STUN_ATTR_ALTERNATE_SERVER, addr));
  SendStun(conn, &resp);
}

void TurnServer::SendStun(TurnServerConnection* conn, StunMessage* msg) {
  RTC_DCHECK_RUN_ON(thread_);
  ByteBufferWriter buf;
  // Add a SOFTWARE attribute if one is set.
  if (!software_.empty()) {
    msg->AddAttribute(std::make_unique<StunByteStringAttribute>(
        STUN_ATTR_SOFTWARE, software_));
  }
  msg->Write(&buf);
  conn->Send(buf);
}

void TurnServer::DestroyAllocation(TurnServerAllocation* allocation) {
  // Removing the internal socket if the connection is not udp.
  AsyncPacketSocket* socket = allocation->conn()->socket();
  InternalSocketMap::iterator iter = server_sockets_.find(socket);
  // Skip if the socket serving this allocation is UDP, as this will be shared
  // by all allocations.
  // Note: We may not find a socket if it's a TCP socket that was closed, and
  // the allocation is only now timing out.
  if (iter != server_sockets_.end() && iter->second != webrtc::PROTO_UDP) {
    DestroyInternalSocket(socket);
  }

  internal_tcp_sock_to_alloc_.erase(socket);

  AllocationMap::iterator it = allocations_.find(*(allocation->conn()));
  if (it != allocations_.end()) {
    allocations_.erase(it);
  } else {
    RTC_LOG(LS_WARNING) << "Cannot find " << allocation->ToString();
    delete allocation;
  }
}

void TurnServer::DestroyInternalSocket(AsyncPacketSocket* socket) {
  InternalSocketMap::iterator iter = server_sockets_.find(socket);
  if (iter != server_sockets_.end()) {
    AsyncPacketSocket* server_socket = iter->first;
    server_socket->UnsubscribeCloseEvent(this);
    server_socket->DeregisterReceivedPacketCallback();
    server_sockets_.erase(iter);
    std::unique_ptr<AsyncPacketSocket> socket_to_delete =
        absl::WrapUnique(server_socket);
    // We must destroy the socket async to avoid invalidating the sigslot
    // callback list iterator inside a sigslot callback. (In other words,
    // deleting an object from within a callback from that object).
    thread_->PostTask([socket_to_delete = std::move(socket_to_delete)] {});
  }
}

namespace {
const char* const kProtos[] = {
    "udp:", "tcp:", "ssltcp:", "tls:"
};
}

TurnServerConnection::TurnServerConnection(const SocketAddress& src,
                                           ProtocolType proto,
                                           AsyncPacketSocket* socket)
    : src_(src),
      dst_(socket->GetRemoteAddress()),
      proto_(proto),
      socket_(socket),
      id_(kProtos[proto_] + src_.ToString()) {}

bool TurnServerConnection::operator==(const TurnServerConnection& c) const {
  return src_ == c.src_ && dst_ == c.dst_ && proto_ == c.proto_;
}

bool TurnServerConnection::operator<(const TurnServerConnection& c) const {
  return std::tie(src_, dst_, proto_) < std::tie(c.src_, c.dst_, c.proto_);
}

void TurnServerConnection::Send(const ByteBufferWriter& buf) {
  webrtc::AsyncSocketPacketOptions options;
  socket_->SendTo(buf.Data(), buf.Length(), src_, options);
}

TurnServerAllocation::TurnServerAllocation(TurnServer* server,
                                           webrtc::TaskQueueBase* thread,
                                           const TurnServerConnection& conn,
                                           AsyncPacketSocket* external_udp_socket,
                                           AsyncListenSocket* external_listen_socket,
                                           absl::string_view key,
                                           const IPAddress& peer_ip)
    : server_(server),
      thread_(thread),
      conn_(conn),
      key_(key),
      peer_ip_(peer_ip),
      id_(ComputeId()) {
    if (external_udp_socket != nullptr) {
      external_udp_socket_.reset(external_udp_socket);
      external_udp_socket_->RegisterReceivedPacketCallback(
      [&](AsyncPacketSocket* socket, const ReceivedIpPacket& packet) {
        RTC_DCHECK_RUN_ON(thread_);
        OnExternalPacket(socket, packet);
      });
    } else {
      external_listen_socket_.reset(external_listen_socket);
      external_listen_socket_->SignalNewConnection.connect(
          this, &TurnServerAllocation::OnNewExternalConnection);
    }
}

TurnServerAllocation::~TurnServerAllocation() {
  RTC_LOG(LS_ERROR) << ToString() << ": Allocation destroyed";
  if (server_->stun_message_observer_) {
    server_->stun_message_observer_->DestroyedAllocation(this);
  }
}

std::string TurnServerAllocation::ComputeId() const {
  return conn_.ToString() +
      (external_udp_socket_ == nullptr ? "=>tcp:" : "=>udp:") +
      peer_ip_.ToString();
}

void TurnServerAllocation::OnNewExternalConnection(AsyncListenSocket* l,
                                                   AsyncPacketSocket* c) {
  const auto& remote_addr = c->GetRemoteAddress();
  if (external_tcp_socket_) {
    RTC_LOG(LS_WARNING) << "Received external TCP connection from '"
        << remote_addr.ToString() << "' while we has already accepted a connection. Closing it.";
    delete c;
  } else if (server_->enable_permission_checks_ && remote_addr.ipaddr() != peer_ip_) {
    RTC_LOG(LS_WARNING) << "Received external TCP connection from unexpected address '"
        << remote_addr.ToString() << "'. Closing it...";
    delete c;
  } else {
    RTC_LOG(LS_INFO) << "Received external TCP connection from address '"
        << remote_addr.ToString() << "'.";
    peer_addr_ = remote_addr;
    external_tcp_socket_.reset(c);
    c->RegisterReceivedPacketCallback(
    [&](AsyncPacketSocket* socket, const ReceivedIpPacket& packet) {
      RTC_DCHECK_RUN_ON(thread_);
      OnExternalPacket(socket, packet);
    });
    c->SubscribeCloseEvent(this, [this](AsyncPacketSocket* s, int err) {
        OnExternalSocketClose(s, err);
    });
  }
}

void TurnServerAllocation::OnExternalSocketClose(webrtc::AsyncPacketSocket* socket,
                                                 int err) {
  RTC_LOG(LS_INFO) << "External TCP socket from '" << socket->GetRemoteAddress().ToString()
      << "' closed.";
  auto delete_self = [this] {
    RTC_DCHECK_RUN_ON(server_->thread_);
    server_->DestroyAllocation(this);
  };
  thread_->PostTask(SafeTask(safety_.flag(), std::move(delete_self)));
}

std::string TurnServerAllocation::internal_addr() const {
  return conn_.ToString();
}

std::string TurnServerAllocation::external_addr() const {
  return (external_udp_socket_ == nullptr ? "tcp:" : "udp:") +
      (peer_addr_.ipaddr().IsNil() ? peer_ip_.ToString() : peer_addr_.ToString());
}

std::string TurnServerAllocation::ToString() const {
  StringBuilder ost;
  ost << "Alloc[" << conn_.ToString() << "]";
  return ost.Release();
}

void TurnServerAllocation::HandleTurnMessage(const TurnMessage* msg) {
  RTC_DCHECK_RUN_ON(thread_);
  RTC_DCHECK(msg != NULL);
  switch (msg->type()) {
    case STUN_ALLOCATE_REQUEST:
      HandleAllocateRequest(msg);
      break;
    case TURN_REFRESH_REQUEST:
      HandleRefreshRequest(msg);
      break;
    case TURN_SEND_INDICATION:
      HandleSendIndication(msg);
      break;
    case TURN_CREATE_PERMISSION_REQUEST:
      HandleCreatePermissionRequest(msg);
      break;
    case TURN_CHANNEL_BIND_REQUEST:
      HandleChannelBindRequest(msg);
      break;
    default:
      // Not sure what to do with this, just eat it.
      RTC_LOG(LS_WARNING) << ToString()
                          << ": Invalid TURN message type received: "
                          << msg->type();
  }
}

void TurnServerAllocation::HandleAllocateRequest(const TurnMessage* msg) {
  // Copy the important info from the allocate request.
  transaction_id_ = msg->transaction_id();
  const StunByteStringAttribute* username_attr =
      msg->GetByteString(STUN_ATTR_USERNAME);
  RTC_DCHECK(username_attr != NULL);
  username_ = std::string(username_attr->string_view());

  // Figure out the lifetime and start the allocation timer.
  TimeDelta lifetime = ComputeLifetime(*msg);
  PostDeleteSelf(lifetime);

  RTC_LOG(LS_INFO) << ToString() << ": Created allocation with lifetime="
                   << lifetime.seconds();

  // We've already validated all the important bits; just send a response here.
  TurnMessage response(GetStunSuccessResponseTypeOrZero(*msg),
                       msg->transaction_id());

  auto mapped_addr_attr = std::make_unique<StunXorAddressAttribute>(
      STUN_ATTR_XOR_MAPPED_ADDRESS, conn_.src());
  auto relayed_addr_attr = std::make_unique<StunXorAddressAttribute>(
      STUN_ATTR_XOR_RELAYED_ADDRESS, (external_udp_socket_ != nullptr ?
          external_udp_socket_->GetLocalAddress() :
          external_listen_socket_->GetLocalAddress()));
  auto lifetime_attr = std::make_unique<StunUInt32Attribute>(
      STUN_ATTR_LIFETIME, lifetime.seconds());
  response.AddAttribute(std::move(mapped_addr_attr));
  response.AddAttribute(std::move(relayed_addr_attr));
  response.AddAttribute(std::move(lifetime_attr));

  SendResponse(&response);
}

void TurnServerAllocation::HandleRefreshRequest(const TurnMessage* msg) {
  // Figure out the new lifetime.
  TimeDelta lifetime = ComputeLifetime(*msg);

  // Reset the expiration timer.
  safety_.reset();
  PostDeleteSelf(lifetime);

  RTC_LOG(LS_INFO) << ToString()
                   << ": Refreshed allocation, lifetime=" << lifetime.seconds();

  // Send a success response with a LIFETIME attribute.
  TurnMessage response(GetStunSuccessResponseTypeOrZero(*msg),
                       msg->transaction_id());

  auto lifetime_attr = std::make_unique<StunUInt32Attribute>(
      STUN_ATTR_LIFETIME, lifetime.seconds());
  response.AddAttribute(std::move(lifetime_attr));

  SendResponse(&response);
}

void TurnServerAllocation::HandleSendIndication(const TurnMessage* msg) {
  // Check mandatory attributes.
  const StunByteStringAttribute* data_attr = msg->GetByteString(STUN_ATTR_DATA);
  const StunAddressAttribute* peer_attr =
      msg->GetAddress(STUN_ATTR_XOR_PEER_ADDRESS);
  if (!data_attr || !peer_attr) {
    RTC_LOG(LS_WARNING) << ToString() << ": Received invalid send indication";
    return;
  }

  // If a permission exists, send the data on to the peer.
  const auto peer = peer_attr->GetAddress();
  if (!server_->enable_permission_checks_ || peer.ipaddr() == peer_ip_) {
    SendExternal(data_attr->bytes(), data_attr->length(), peer_addr_);
  } else {
    RTC_LOG(LS_WARNING) << ToString()
                        << ": Received send indication without permission peer="
                        << peer.ToString();
  }
}

void TurnServerAllocation::HandleCreatePermissionRequest(
    const TurnMessage* msg) {
  RTC_DCHECK_RUN_ON(server_->thread_);
  // Check mandatory attributes.
  const StunAddressAttribute* peer_attr =
      msg->GetAddress(STUN_ATTR_XOR_PEER_ADDRESS);
  if (!peer_attr) {
    SendBadRequestResponse(msg);
    return;
  }

  const SocketAddress peer_addr = peer_attr->GetAddress();
  if ((server_->reject_private_addresses_ && IPIsPrivate(peer_addr.ipaddr())) ||
      (server_->enable_permission_checks_ && peer_ip_ != peer_addr.ipaddr())) {
    RTC_LOG(LS_WARNING) << "Rejecting CreatePermissionRequest for "
        << peer_addr.ToString() << ", expecting " << peer_ip_.ToString();
    SendErrorResponse(msg, STUN_ERROR_FORBIDDEN, STUN_ERROR_REASON_FORBIDDEN);
    return;
  }
  peer_addr_ = peer_addr;

  RTC_LOG(LS_INFO) << "Created permission, peer=" << peer_addr.ToString();

  // Send a success response.
  TurnMessage response(GetStunSuccessResponseTypeOrZero(*msg),
                       msg->transaction_id());
  SendResponse(&response);
}

void TurnServerAllocation::HandleChannelBindRequest(const TurnMessage* msg) {
  RTC_DCHECK_RUN_ON(server_->thread_);
  if (server_->reject_bind_requests_) {
    RTC_LOG(LS_ERROR) << "HandleChannelBindRequest: Rejecting bind requests";
    SendBadRequestResponse(msg);
    return;
  }

  // Check mandatory attributes.
  const StunUInt32Attribute* channel_attr =
      msg->GetUInt32(STUN_ATTR_CHANNEL_NUMBER);
  const StunAddressAttribute* peer_attr =
      msg->GetAddress(STUN_ATTR_XOR_PEER_ADDRESS);
  if (!channel_attr || !peer_attr) {
    SendBadRequestResponse(msg);
    return;
  }

  // Check that channel id is valid.
  const int channel_id = channel_attr->value() >> 16;
  const auto peer_addr = peer_attr->GetAddress();
  if (channel_id < kMinTurnChannelNumber || channel_id > kMaxTurnChannelNumber ||
      (server_->enable_permission_checks_ && peer_addr.ipaddr() != peer_ip_)) {
    SendBadRequestResponse(msg);
    return;
  }

  if (channel_id_ == -1) {
    channel_id_ = channel_id;
  } else if (channel_id_ != channel_id) {
    SendBadRequestResponse(msg);
    return;
  }
  peer_addr_ = peer_addr;

  RTC_LOG(LS_INFO) << "Bound channel, id=" << channel_id << ", peer=" << peer_addr.ToString();

  // Send a success response.
  TurnMessage response(GetStunSuccessResponseTypeOrZero(*msg),
                       msg->transaction_id());
  SendResponse(&response);
}

void TurnServerAllocation::HandleChannelData(ArrayView<const uint8_t> payload) {
  // Extract the channel number from the data.
  uint16_t channel_id = webrtc::GetBE16(payload.data());
  if (channel_id_ != -1 && channel_id == channel_id_) {
    // Send the data to the peer address.
    SendExternal(payload.data() + TURN_CHANNEL_HEADER_SIZE,
                 payload.size() - TURN_CHANNEL_HEADER_SIZE, peer_addr_);
  } else {
    RTC_LOG(LS_WARNING) << ToString()
                        << ": Received channel data for invalid channel, id="
                        << channel_id;
  }
}

void TurnServerAllocation::OnExternalPacket(AsyncPacketSocket* socket,
                                            const ReceivedIpPacket& packet) {

  if (channel_id_ != -1 && packet.source_address() == peer_addr_) {
    // There is a channel bound to this address. Send as a channel message.
    ByteBufferWriter buf;
    buf.WriteUInt16(channel_id_);
    buf.WriteUInt16(static_cast<uint16_t>(packet.payload().size()));
    buf.Write(ArrayView<const uint8_t>(packet.payload()));
    conn_.Send(buf);
    if (server_->stun_message_observer_) {
      server_->stun_message_observer_->ReceivedExternalData(
          this, packet.payload());
    }
  } else if (channel_id_ == -1 && (!server_->enable_permission_checks_ ||
                                   // NOTE: We don't check port to make it it
                                   // works with port-dependent NAT.
                                   peer_ip_ == packet.source_address().ipaddr())) {
    if (!peer_addr_.ipaddr().IsNil() && peer_addr_ != packet.source_address()) {
      RTC_LOG(LS_WARNING) << "Received DataIndication from a different address: "
          << peer_addr_.ToString() << " => " << packet.source_address().ToString();
    }
    // No channel, but a permission exists. Send as a data indication.
    TurnMessage msg(TURN_DATA_INDICATION);
    msg.AddAttribute(std::make_unique<StunXorAddressAttribute>(
        STUN_ATTR_XOR_PEER_ADDRESS, packet.source_address()));
    msg.AddAttribute(std::make_unique<StunByteStringAttribute>(
        STUN_ATTR_DATA, packet.payload().data(), packet.payload().size()));
    server_->SendStun(&conn_, &msg);
    if (server_->stun_message_observer_) {
      server_->stun_message_observer_->ReceivedExternalData(
          this, packet.payload());
    }
  } else {
    RTC_LOG(LS_WARNING)
        << ToString() << ": Received external packet without permission, peer="
        << packet.source_address().ToSensitiveString();
  }
}

TimeDelta TurnServerAllocation::ComputeLifetime(const TurnMessage& msg) {
  if (const StunUInt32Attribute* attr = msg.GetUInt32(STUN_ATTR_LIFETIME)) {
    return std::min(TimeDelta::Seconds(static_cast<int>(attr->value())),
                    kDefaultAllocationTimeout);
  }
  return kDefaultAllocationTimeout;
}

void TurnServerAllocation::SendResponse(TurnMessage* msg) {
  // Success responses always have M-I.
  msg->AddMessageIntegrity(key_);
  server_->SendStun(&conn_, msg);
}

void TurnServerAllocation::SendBadRequestResponse(const TurnMessage* req) {
  SendErrorResponse(req, STUN_ERROR_BAD_REQUEST, STUN_ERROR_REASON_BAD_REQUEST);
}

void TurnServerAllocation::SendErrorResponse(const TurnMessage* req,
                                             int code,
                                             absl::string_view reason) {
  server_->SendErrorResponse(&conn_, req, code, reason);
}

void TurnServerAllocation::SendExternal(const void* data,
                                        size_t size,
                                        const SocketAddress& peer) {
  AsyncSocketPacketOptions options;
  if (external_udp_socket_ != nullptr) {
    external_udp_socket_->SendTo(data, size, peer, options);
  } else if (external_tcp_socket_) {
    external_tcp_socket_->Send(data, size, options);
  }
}

void TurnServerAllocation::PostDeleteSelf(TimeDelta delay) {
  auto delete_self = [this] {
    RTC_DCHECK_RUN_ON(server_->thread_);
    server_->DestroyAllocation(this);
  };
  thread_->PostDelayedTask(SafeTask(safety_.flag(), std::move(delete_self)),
                           delay);
}

}  // namespace webrtc
