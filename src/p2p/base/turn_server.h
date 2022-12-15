/*
 *  Copyright 2012 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef P2P_BASE_TURN_SERVER_H_
#define P2P_BASE_TURN_SERVER_H_

#include <list>
#include <map>
#include <memory>
#include <set>
#include <string>
#include <utility>
#include <vector>

#include "absl/strings/string_view.h"
#include "api/sequence_checker.h"
#include "api/task_queue/pending_task_safety_flag.h"
#include "api/task_queue/task_queue_base.h"
#include "api/units/time_delta.h"
#include "p2p/base/port_interface.h"
#include "rtc_base/async_packet_socket.h"
#include "rtc_base/socket_address.h"
#include "rtc_base/ssl_adapter.h"
#include "rtc_base/third_party/sigslot/sigslot.h"

namespace rtc {
class ByteBufferWriter;
class PacketSocketFactory;
}  // namespace rtc

namespace cricket {

class StunMessage;
class TurnMessage;
class TurnServer;

// The default server port for TURN, as specified in RFC5766.
const int TURN_SERVER_PORT = 3478;

// Encapsulates the client's connection to the server.
class TurnServerConnection {
 public:
  TurnServerConnection() : proto_(PROTO_UDP), socket_(NULL) {}
  TurnServerConnection(const rtc::SocketAddress& src,
                       ProtocolType proto,
                       rtc::AsyncPacketSocket* socket);
  const rtc::SocketAddress& src() const { return src_; }
  cricket::ProtocolType protocol() const { return proto_; }
  rtc::AsyncPacketSocket* socket() { return socket_; }
  bool operator==(const TurnServerConnection& t) const;
  bool operator<(const TurnServerConnection& t) const;
  const std::string& ToString() const { return id_; }

  void Send(const rtc::ByteBufferWriter& buf);

 private:
  rtc::SocketAddress src_;
  rtc::SocketAddress dst_;
  cricket::ProtocolType proto_;
  rtc::AsyncPacketSocket* socket_;
  const std::string id_;
};

// Encapsulates a TURN allocation.
// The object is created when an allocation request is received, and then
// handles TURN messages (via HandleTurnMessage) and channel data messages
// (via HandleChannelData) for this allocation when received by the server.
// The object informs the server when its lifetime timer expires.
class TurnServerAllocation : public sigslot::has_slots<> {
 public:
  TurnServerAllocation(TurnServer* server_,
                       webrtc::TaskQueueBase* thread,
                       const TurnServerConnection& conn,
                       rtc::AsyncPacketSocket* external_udp_socket,
                       rtc::AsyncListenSocket* external_listen_socket,
                       absl::string_view key,
                       const rtc::IPAddress& peer_ip);
  ~TurnServerAllocation() override;

  const std::string& id() const { return id_; }
  TurnServerConnection* conn() { return &conn_; }
  const TurnServerConnection* conn() const { return &conn_; }
  const std::string& key() const { return key_; }
  const std::string& transaction_id() const { return transaction_id_; }
  const std::string& username() const { return username_; }
  const std::string& last_nonce() const { return last_nonce_; }
  void set_last_nonce(absl::string_view nonce) {
    last_nonce_ = std::string(nonce);
  }

  int external_proto() const {
      return external_udp_socket_ != nullptr ? PROTO_UDP : PROTO_TCP;
  }
  std::string internal_addr() const;
  std::string external_addr() const;

  std::string ToString() const;

  void HandleTurnMessage(const TurnMessage* msg);
  void HandleChannelData(const char* data, size_t size);

 private:
  void PostDeleteSelf(webrtc::TimeDelta delay);

  void HandleAllocateRequest(const TurnMessage* msg);
  void HandleRefreshRequest(const TurnMessage* msg);
  void HandleSendIndication(const TurnMessage* msg);
  void HandleCreatePermissionRequest(const TurnMessage* msg);
  void HandleChannelBindRequest(const TurnMessage* msg);

  void OnExternalPacket(rtc::AsyncPacketSocket* socket,
                        const char* data,
                        size_t size,
                        const rtc::SocketAddress& addr,
                        const int64_t& packet_time_us);

  void OnNewExternalConnection(rtc::AsyncListenSocket*, rtc::AsyncPacketSocket*);
  void OnExternalSocketClose(rtc::AsyncPacketSocket* socket, int err);

  static webrtc::TimeDelta ComputeLifetime(const TurnMessage& msg);

  void SendResponse(TurnMessage* msg);
  void SendBadRequestResponse(const TurnMessage* req);
  void SendErrorResponse(const TurnMessage* req,
                         int code,
                         absl::string_view reason);
  void SendExternal(const void* data,
                    size_t size,
                    const rtc::SocketAddress& peer);

  std::string ComputeId() const;

  TurnServer* const server_;
  webrtc::TaskQueueBase* const thread_;
  TurnServerConnection conn_;
  std::unique_ptr<rtc::AsyncPacketSocket> external_udp_socket_;
  std::unique_ptr<rtc::AsyncListenSocket> external_listen_socket_;
  std::unique_ptr<rtc::AsyncPacketSocket> external_tcp_socket_;
  const std::string key_;
  const rtc::IPAddress peer_ip_;
  const std::string id_;
  std::string transaction_id_;
  std::string username_;
  std::string last_nonce_;
  // For each allocation, we only allow one channel, one peer. To simplify
  // things, we removed the original Channel and permission structures.
  int channel_id_ = -1;
  rtc::SocketAddress peer_addr_;
  webrtc::ScopedTaskSafety safety_;
};

// An interface through which the MD5 credential hash can be retrieved.
class TurnAuthInterface {
 public:
  // Gets HA1 for the specified user and realm.
  // HA1 = MD5(A1) = MD5(username:realm:password).
  // Return true if the given username and realm are valid, or false if not.
  virtual bool GetKey(const TurnServerConnection* conn,
                      absl::string_view username, absl::string_view realm,
                      std::string* key, rtc::IPAddress* expected_peer_ip) = 0;
  virtual ~TurnAuthInterface() = default;
};

// An interface enables Turn Server to control redirection behavior.
class TurnRedirectInterface {
 public:
  virtual bool ShouldRedirect(const rtc::SocketAddress& address,
                              rtc::SocketAddress* out) = 0;
  virtual ~TurnRedirectInterface() {}
};

class StunMessageObserver {
 public:
  virtual void CreatedAllocation(const TurnServerAllocation* allocation) = 0;
  virtual void DestroyedAllocation(const TurnServerAllocation* allocation) = 0;
  virtual void ReceivedMessage(const TurnServerConnection* conn, const TurnMessage* msg) = 0;
  virtual void ReceivedInternalData(
      const TurnServerAllocation* allocation, const char* data, size_t size) = 0;
  virtual void ReceivedExternalData(
      const TurnServerAllocation* allocation, const char* data, size_t size) = 0;
  virtual ~StunMessageObserver() {}
};

// The core TURN server class. Give it a socket to listen on via
// AddInternalServerSocket, and a factory to create external sockets via
// SetExternalSocketFactory, and it's ready to go.
// Not yet wired up: TCP support.
class TurnServer : public sigslot::has_slots<> {
 public:
  typedef std::map<TurnServerConnection, std::unique_ptr<TurnServerAllocation>>
      AllocationMap;

  explicit TurnServer(webrtc::TaskQueueBase* thread);
  ~TurnServer() override;

  // Gets/sets the realm value to use for the server.
  const std::string& realm() const {
    RTC_DCHECK_RUN_ON(thread_);
    return realm_;
  }
  void set_realm(absl::string_view realm) {
    RTC_DCHECK_RUN_ON(thread_);
    realm_ = std::string(realm);
  }

  // Gets/sets the value for the SOFTWARE attribute for TURN messages.
  const std::string& software() const {
    RTC_DCHECK_RUN_ON(thread_);
    return software_;
  }
  void set_software(absl::string_view software) {
    RTC_DCHECK_RUN_ON(thread_);
    software_ = std::string(software);
  }

  const AllocationMap& allocations() const {
    RTC_DCHECK_RUN_ON(thread_);
    return allocations_;
  }

  // Sets the authentication callback; does not take ownership.
  void set_auth_hook(TurnAuthInterface* auth_hook) {
    RTC_DCHECK_RUN_ON(thread_);
    auth_hook_ = auth_hook;
  }

  void set_redirect_hook(TurnRedirectInterface* redirect_hook) {
    RTC_DCHECK_RUN_ON(thread_);
    redirect_hook_ = redirect_hook;
  }

  void set_enable_otu_nonce(bool enable) {
    RTC_DCHECK_RUN_ON(thread_);
    enable_otu_nonce_ = enable;
  }

  // If set to true, reject CreatePermission requests to RFC1918 addresses.
  void set_reject_private_addresses(bool filter) {
    RTC_DCHECK_RUN_ON(thread_);
    reject_private_addresses_ = filter;
  }

  void set_enable_permission_checks(bool enable) {
    RTC_DCHECK_RUN_ON(thread_);
    enable_permission_checks_ = enable;
  }

  // Starts listening for packets from internal clients.
  void AddInternalSocket(rtc::AsyncPacketSocket* socket, ProtocolType proto);
  // Starts listening for the connections on this socket. When someone tries
  // to connect, the connection will be accepted and a new internal socket
  // will be added.
  void AddInternalServerSocket(
      rtc::Socket* socket,
      ProtocolType proto,
      std::unique_ptr<rtc::SSLAdapterFactory> ssl_adapter_factory = nullptr);
  // Specifies the factory to use for creating external sockets.
  void SetExternalSocketFactory(rtc::PacketSocketFactory* factory,
                                const rtc::SocketAddress& address);
  // For testing only.
  std::string SetTimestampForNextNonce(int64_t timestamp) {
    RTC_DCHECK_RUN_ON(thread_);
    ts_for_next_nonce_ = timestamp;
    return GenerateNonce(timestamp);
  }

  void SetStunMessageObserver(StunMessageObserver* observer) {
    RTC_DCHECK_RUN_ON(thread_);
    stun_message_observer_ = observer;
  }

 private:
  // All private member functions and variables should have access restricted to
  // thread_. But compile-time annotations are missing for members access from
  // TurnServerAllocation (via friend declaration), and the On* methods, which
  // are called via sigslot.
  std::string GenerateNonce(int64_t now) const RTC_RUN_ON(thread_);
  void OnInternalPacket(rtc::AsyncPacketSocket* socket,
                        const char* data,
                        size_t size,
                        const rtc::SocketAddress& address,
                        const int64_t& packet_time_us);

  void OnNewInternalConnection(rtc::Socket* socket);

  // Accept connections on this server socket.
  void AcceptConnection(rtc::Socket* server_socket) RTC_RUN_ON(thread_);
  void OnInternalSocketClose(rtc::AsyncPacketSocket* socket, int err);

  void HandleStunMessage(TurnServerConnection* conn,
                         const char* data,
                         size_t size) RTC_RUN_ON(thread_);
  void HandleBindingRequest(TurnServerConnection* conn, const StunMessage* msg)
      RTC_RUN_ON(thread_);
  void HandleAllocateRequest(TurnServerConnection* conn,
                             const TurnMessage* msg,
                             absl::string_view key,
                             const rtc::IPAddress& expected_peer_ip) RTC_RUN_ON(thread_);

  bool GetKey(const TurnServerConnection* conn, const StunMessage* msg,
              std::string* key, rtc::IPAddress* expected_peer_ip) RTC_RUN_ON(thread_);
  bool CheckAuthorization(TurnServerConnection* conn,
                          StunMessage* msg,
                          const char* data,
                          size_t size,
                          absl::string_view key) RTC_RUN_ON(thread_);
  bool ValidateNonce(absl::string_view nonce) const RTC_RUN_ON(thread_);

  TurnServerAllocation* FindAllocation(TurnServerConnection* conn)
      RTC_RUN_ON(thread_);
  TurnServerAllocation* CreateAllocation(TurnServerConnection* conn,
                                         int proto,
                                         absl::string_view key,
                                         const rtc::IPAddress& expected_peer_ip)
      RTC_RUN_ON(thread_);

  void SendErrorResponse(TurnServerConnection* conn,
                         const StunMessage* req,
                         int code,
                         absl::string_view reason);

  void SendErrorResponseWithRealmAndNonce(TurnServerConnection* conn,
                                          const StunMessage* req,
                                          int code,
                                          absl::string_view reason)
      RTC_RUN_ON(thread_);

  void SendErrorResponseWithAlternateServer(TurnServerConnection* conn,
                                            const StunMessage* req,
                                            const rtc::SocketAddress& addr)
      RTC_RUN_ON(thread_);

  void SendStun(TurnServerConnection* conn, StunMessage* msg);

  void DestroyAllocation(TurnServerAllocation* allocation) RTC_RUN_ON(thread_);
  void DestroyInternalSocket(rtc::AsyncPacketSocket* socket)
      RTC_RUN_ON(thread_);

  typedef std::map<rtc::AsyncPacketSocket*, ProtocolType> InternalSocketMap;
  struct ServerSocketInfo {
    ProtocolType proto;
    // If non-null, used to wrap accepted sockets.
    std::unique_ptr<rtc::SSLAdapterFactory> ssl_adapter_factory;
  };
  typedef std::map<rtc::Socket*, ServerSocketInfo> ServerSocketMap;

  webrtc::TaskQueueBase* const thread_;
  const std::string nonce_key_;
  std::string realm_ RTC_GUARDED_BY(thread_);
  std::string software_ RTC_GUARDED_BY(thread_);
  TurnAuthInterface* auth_hook_ RTC_GUARDED_BY(thread_);
  TurnRedirectInterface* redirect_hook_ RTC_GUARDED_BY(thread_);
  // otu - one-time-use. Server will respond with 438 if it's
  // sees the same nonce in next transaction.
  bool enable_otu_nonce_ RTC_GUARDED_BY(thread_);
  bool reject_private_addresses_ = false;
  // Check for permission when receiving an external packet.
  bool enable_permission_checks_ = true;

  InternalSocketMap server_sockets_ RTC_GUARDED_BY(thread_);
  ServerSocketMap server_listen_sockets_ RTC_GUARDED_BY(thread_);
  std::unique_ptr<rtc::PacketSocketFactory> external_socket_factory_
      RTC_GUARDED_BY(thread_);
  rtc::SocketAddress external_addr_ RTC_GUARDED_BY(thread_);

  AllocationMap allocations_ RTC_GUARDED_BY(thread_);
  std::map<rtc::AsyncPacketSocket*, TurnServerAllocation*> internal_tcp_sock_to_alloc_;

  // For testing only. If this is non-zero, the next NONCE will be generated
  // from this value, and it will be reset to 0 after generating the NONCE.
  int64_t ts_for_next_nonce_ RTC_GUARDED_BY(thread_) = 0;

  // Not owned.
  StunMessageObserver* stun_message_observer_;

  friend class TurnServerAllocation;
};

}  // namespace cricket

#endif  // P2P_BASE_TURN_SERVER_H_
