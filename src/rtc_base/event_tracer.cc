/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */
#include "rtc_base/event_tracer.h"

#include <inttypes.h>

#include <string>
#include <vector>

#include "rtc_base/checks.h"
#include "rtc_base/criticalsection.h"
#include "rtc_base/event.h"
#include "rtc_base/logging.h"
#include "rtc_base/platform_thread.h"
#include "rtc_base/stringutils.h"
#include "rtc_base/timeutils.h"
#include "rtc_base/trace_event.h"

// This is a guesstimate that should be enough in most cases.
static const size_t kEventLoggerArgsStrBufferInitialSize = 256;
static const size_t kTraceArgBufferLength = 32;

namespace webrtc {

namespace {

GetCategoryEnabledPtr g_get_category_enabled_ptr = nullptr;
AddTraceEventPtr g_add_trace_event_ptr = nullptr;

}  // namespace

void SetupEventTracer(GetCategoryEnabledPtr get_category_enabled_ptr,
                      AddTraceEventPtr add_trace_event_ptr) {
  g_get_category_enabled_ptr = get_category_enabled_ptr;
  g_add_trace_event_ptr = add_trace_event_ptr;
}

const unsigned char* EventTracer::GetCategoryEnabled(const char* name) {
  if (g_get_category_enabled_ptr)
    return g_get_category_enabled_ptr(name);

  // A string with null terminator means category is disabled.
  return reinterpret_cast<const unsigned char*>("\0");
}

// Arguments to this function (phase, etc.) are as defined in
// webrtc/rtc_base/trace_event.h.
void EventTracer::AddTraceEvent(char phase,
                                const unsigned char* category_enabled,
                                const char* name,
                                unsigned long long id,
                                int num_args,
                                const char** arg_names,
                                const unsigned char* arg_types,
                                const unsigned long long* arg_values,
                                unsigned char flags) {
  if (g_add_trace_event_ptr) {
    g_add_trace_event_ptr(phase,
                          category_enabled,
                          name,
                          id,
                          num_args,
                          arg_names,
                          arg_types,
                          arg_values,
                          flags);
  }
}

}  // namespace webrtc

namespace rtc {
namespace tracing {
namespace {

class EventLogger final {
 public:
  EventLogger() {}
  ~EventLogger() {}

  void AddTraceEvent(const char* name,
                     const unsigned char* category_enabled,
                     char phase,
                     int num_args,
                     const char** arg_names,
                     const unsigned char* arg_types,
                     const unsigned long long* arg_values,
                     uint64_t timestamp,
                     int pid,
                     rtc::PlatformThreadId thread_id) {
    LOG(LS_VERBOSE) << name << "(" << phase << ") @" << timestamp;
  }
};

static EventLogger* volatile g_event_logger = nullptr;
static const char* const kDisabledTracePrefix = TRACE_DISABLED_BY_DEFAULT("");
const unsigned char* InternalGetCategoryEnabled(const char* name) {
  const char* prefix_ptr = &kDisabledTracePrefix[0];
  const char* name_ptr = name;
  // Check whether name contains the default-disabled prefix.
  while (*prefix_ptr == *name_ptr && *prefix_ptr != '\0') {
    ++prefix_ptr;
    ++name_ptr;
  }
  return reinterpret_cast<const unsigned char*>(*prefix_ptr == '\0' ? ""
                                                                    : name);
}

void InternalAddTraceEvent(char phase,
                           const unsigned char* category_enabled,
                           const char* name,
                           unsigned long long id,
                           int num_args,
                           const char** arg_names,
                           const unsigned char* arg_types,
                           const unsigned long long* arg_values,
                           unsigned char flags) {
  g_event_logger->AddTraceEvent(name, category_enabled, phase, num_args,
                                arg_names, arg_types, arg_values,
                                rtc::TimeMicros(), 1, rtc::CurrentThreadId());
}

}  // namespace

void SetupInternalTracer() {
  RTC_CHECK(rtc::AtomicOps::CompareAndSwapPtr(
                &g_event_logger, static_cast<EventLogger*>(nullptr),
                new EventLogger()) == nullptr);
  webrtc::SetupEventTracer(InternalGetCategoryEnabled, InternalAddTraceEvent);
}

void ShutdownInternalTracer() {
  EventLogger* old_logger = rtc::AtomicOps::AcquireLoadPtr(&g_event_logger);
  RTC_DCHECK(old_logger);
  RTC_CHECK(rtc::AtomicOps::CompareAndSwapPtr(
                &g_event_logger, old_logger,
                static_cast<EventLogger*>(nullptr)) == old_logger);
  delete old_logger;
  webrtc::SetupEventTracer(nullptr, nullptr);
}

}  // namespace tracing
}  // namespace rtc
