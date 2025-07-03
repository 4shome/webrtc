/*
 *  Copyright 2025 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "pc/media_options.h"

#include <string>
#include <vector>

#include "absl/algorithm/container.h"
#include "api/media_types.h"
#include "media/base/rid_description.h"
#include "pc/simulcast_description.h"
#include "rtc_base/checks.h"

namespace webrtc {

namespace {
// note: function duplicated in media_session.cc
bool ValidateSimulcastLayers(const std::vector<RidDescription>& rids,
                             const SimulcastLayerList& simulcast_layers) {
  return absl::c_all_of(
      simulcast_layers.GetAllLayers(), [&rids](const SimulcastLayer& layer) {
        return absl::c_any_of(rids, [&layer](const RidDescription& rid) {
          return rid.rid == layer.rid;
        });
      });
}

}  // namespace

void MediaDescriptionOptions::AddAudioSender(
    const std::string& track_id,
    const std::vector<std::string>& stream_ids,
    const Codecs& codecs) {
  RTC_DCHECK(type == MediaType::AUDIO);
  AddSenderInternal(track_id, stream_ids, {}, SimulcastLayerList(), 1, codecs, {});
}

void MediaDescriptionOptions::AddVideoSender(
    const std::string& track_id,
    const std::vector<std::string>& stream_ids,
    const std::vector<RidDescription>& rids,
    const SimulcastLayerList& simulcast_layers,
    int num_sim_layers,
    const Codecs& codecs) {
  RTC_DCHECK(type == MediaType::VIDEO);
  RTC_DCHECK(rids.empty() || num_sim_layers == 0)
      << "RIDs are the compliant way to indicate simulcast.";
  RTC_DCHECK(ValidateSimulcastLayers(rids, simulcast_layers));
  AddSenderInternal(track_id, stream_ids, rids, simulcast_layers,
                    num_sim_layers, {}, codecs);
}

void MediaDescriptionOptions::AddSenderInternal(
    const std::string& track_id,
    const std::vector<std::string>& stream_ids,
    const std::vector<RidDescription>& rids,
    const SimulcastLayerList& simulcast_layers,
    int num_sim_layers,
     const Codecs& audio_codecs, const Codecs& video_codecs) {
  // TODO(steveanton): Support any number of stream ids.
  RTC_CHECK(stream_ids.size() == 1U);
  SenderOptions options;
  options.track_id = track_id;
  options.stream_ids = stream_ids;
  options.simulcast_layers = simulcast_layers;
  options.rids = rids;
  options.num_sim_layers = num_sim_layers;
  options.audio_codecs = audio_codecs;
  options.video_codecs = video_codecs;
  sender_options.push_back(options);
}

bool MediaSessionOptions::HasMediaDescription(MediaType type) const {
  return absl::c_any_of(
      media_description_options,
      [type](const MediaDescriptionOptions& t) { return t.type == type; });
}

}  // namespace webrtc
