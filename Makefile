default: libwebrtc.a

OS=$(shell uname -s)
ARCH=$(shell arch)

ifeq (MINGW,$(findstring MINGW,$(OS)))
    OS=MinGW
    PREFIX?=/mingw64
else
    PREFIX?=/usr/local
endif

ifeq (Darwin,$(OS))
    ARCH=x86_64
endif

C_SRCS/Linux=

C_SRCS/MinGW=

C_SRCS/Darwin=

C_SRCS/x86_64=

C_SRCS/i686=

C_SRCS/armv7l=src/common_audio/signal_processing/cross_correlation_neon.c \
              src/common_audio/signal_processing/downsample_fast_neon.c \
              src/common_audio/signal_processing/min_max_operations_neon.c \
              src/modules/audio_coding/codecs/isac/fix/source/entropy_coding_neon.c \
              src/modules/audio_coding/codecs/isac/fix/source/filterbanks_neon.c \
              src/modules/audio_coding/codecs/isac/fix/source/filters_neon.c \
              src/modules/audio_coding/codecs/isac/fix/source/lattice_neon.c \
              src/modules/audio_coding/codecs/isac/fix/source/transform_neon.c

C_SRCS/aarch64=src/common_audio/signal_processing/cross_correlation_neon.c \
               src/common_audio/signal_processing/downsample_fast_neon.c \
               src/common_audio/signal_processing/min_max_operations_neon.c \
               src/modules/audio_coding/codecs/isac/fix/source/entropy_coding_neon.c \
               src/modules/audio_coding/codecs/isac/fix/source/filterbanks_neon.c \
               src/modules/audio_coding/codecs/isac/fix/source/filters_neon.c \
               src/modules/audio_coding/codecs/isac/fix/source/lattice_neon.c \
               src/modules/audio_coding/codecs/isac/fix/source/transform_neon.c

C_SRCS=src/common_audio/ring_buffer.c \
       src/common_audio/signal_processing/auto_correlation.c \
       src/common_audio/signal_processing/auto_corr_to_refl_coef.c \
       src/common_audio/signal_processing/complex_bit_reverse.c \
       src/common_audio/signal_processing/complex_fft.c \
       src/common_audio/signal_processing/copy_set_operations.c \
       src/common_audio/signal_processing/cross_correlation.c \
       src/common_audio/signal_processing/division_operations.c \
       src/common_audio/signal_processing/downsample_fast.c \
       src/common_audio/signal_processing/energy.c \
       src/common_audio/signal_processing/filter_ar.c \
       src/common_audio/signal_processing/filter_ar_fast_q12.c \
       src/common_audio/signal_processing/filter_ma_fast_q12.c \
       src/common_audio/signal_processing/get_hanning_window.c \
       src/common_audio/signal_processing/get_scaling_square.c \
       src/common_audio/signal_processing/levinson_durbin.c \
       src/common_audio/signal_processing/lpc_to_refl_coef.c \
       src/common_audio/signal_processing/min_max_operations.c \
       src/common_audio/signal_processing/randomization_functions.c \
       src/common_audio/signal_processing/real_fft.c \
       src/common_audio/signal_processing/refl_coef_to_lpc.c \
       src/common_audio/signal_processing/resample_48khz.c \
       src/common_audio/signal_processing/resample_by_2.c \
       src/common_audio/signal_processing/resample_by_2_internal.c \
       src/common_audio/signal_processing/resample.c \
       src/common_audio/signal_processing/resample_fractional.c \
       src/common_audio/signal_processing/spl_init.c \
       src/common_audio/signal_processing/spl_inl.c \
       src/common_audio/signal_processing/splitting_filter.c \
       src/common_audio/signal_processing/spl_sqrt.c \
       src/common_audio/signal_processing/sqrt_of_one_minus_x_squared.c \
       src/common_audio/signal_processing/vector_operations.c \
       src/common_audio/signal_processing/vector_scaling_operations.c \
       src/common_audio/third_party/spl_sqrt_floor/spl_sqrt_floor.c \
       src/common_audio/vad/webrtc_vad.c \
       src/common_audio/vad/vad_core.c \
       src/common_audio/vad/vad_filterbank.c \
       src/common_audio/vad/vad_gmm.c \
       src/common_audio/vad/vad_sp.c \
       src/modules/audio_coding/codecs/g711/g711_interface.c \
       src/modules/audio_coding/codecs/g722/g722_interface.c \
       src/modules/audio_coding/codecs/pcm16b/pcm16b.c \
       src/modules/audio_coding/codecs/isac/main/source/filter_functions.c \
       src/modules/audio_coding/codecs/isac/main/source/isac_vad.c \
       src/modules/audio_coding/codecs/isac/main/source/pitch_estimator.c \
       src/modules/audio_coding/codecs/isac/main/source/pitch_filter.c \
       src/modules/third_party/fft/fft.c \
       src/modules/third_party/g722/g722_decode.c \
       src/modules/third_party/g722/g722_encode.c \
       src/third_party/pffft/src/pffft.c \
       $(C_SRCS/$(ARCH))

CXX_SRCS/pb=src/logging/rtc_event_log/rtc_event_log.pb.cc \
		    src/logging/rtc_event_log/rtc_event_log2.pb.cc \
            src/modules/audio_coding/audio_network_adaptor/config.pb.cc \
            src/modules/audio_coding/audio_network_adaptor/debug_dump.pb.cc \
            src/modules/audio_processing/debug.pb.cc

CXX_SRCS/Linux=src/modules/audio_device/linux/alsasymboltable_linux.cc \
               src/modules/audio_device/linux/latebindingsymboltable_linux.cc \
               src/modules/video_capture/linux/device_info_linux.cc \
               src/modules/video_capture/linux/video_capture_linux.cc

CXX_SRCS/MinGW=src/api/task_queue/default_task_queue_factory_win.cc \
               src/rtc_base/file_win.cc \
               src/rtc_base/synchronization/rw_lock_win.cc \
               src/rtc_base/task_queue_win.cc \
               src/modules/video_capture/windows/device_info_ds.cc \
               src/modules/video_capture/windows/device_info_mf.cc \
               src/modules/video_capture/windows/help_functions_ds.cc \
               src/modules/video_capture/windows/sink_filter_ds.cc \
               src/modules/video_capture/windows/video_capture_ds.cc \
               src/modules/video_capture/windows/video_capture_factory_windows.cc \
               src/modules/video_capture/windows/video_capture_mf.cc

CXX_SRCS/Darwin=src/api/task_queue/default_task_queue_factory_gcd.cc \
                src/rtc_base/ifaddrs_converter.cc \
                src/rtc_base/macifaddrs_converter.cc \
                src/rtc_base/macutils.cc \
                src/rtc_base/task_queue_gcd.cc

OBJC_SRCS=src/rtc_base/maccocoathreadhelper.mm \
          src/rtc_base/scoped_autorelease_pool.mm \
          src/modules/video_capture/objc/device_info.mm \
          src/modules/video_capture/objc/device_info_objc.mm \
          src/modules/video_capture/objc/rtc_video_capture_objc.mm \
          src/modules/video_capture/objc/video_capture.mm

AVX2_SRCS=src/common_audio/fir_filter_avx2.cc \
          src/common_audio/resampler/sinc_resampler_avx2.cc \
          src/modules/audio_processing/aec3/adaptive_fir_filter_avx2.cc \
          src/modules/audio_processing/aec3/adaptive_fir_filter_erl_avx2.cc \
          src/modules/audio_processing/aec3/fft_data_avx2.cc \
          src/modules/audio_processing/aec3/vector_math_avx2.cc \
          src/modules/audio_processing/agc2/rnn_vad/vector_math_avx2.cc \
          src/modules/audio_processing/aec3/matched_filter_avx2.cc

CXX_SRCS/x86_64=src/common_audio/fir_filter_sse.cc \
                src/common_audio/resampler/sinc_resampler_sse.cc \
                src/common_audio/third_party/ooura/fft_size_128/ooura_fft_sse2.cc \
				$(AVX2_SRCS)

CXX_SRCS/i686=src/common_audio/fir_filter_sse.cc \
              src/common_audio/resampler/sinc_resampler_sse.cc

CXX_SRCS/armv7l=src/common_audio/fir_filter_neon.cc \
                src/common_audio/resampler/sinc_resampler_neon.cc \
                src/common_audio/third_party/ooura/fft_size_128/ooura_fft_neon.cc \
                src/modules/audio_processing/aecm/aecm_core_neon.cc \
                src/modules/video_processing/util/denoiser_filter_neon.cc

CXX_SRCS/aarch64=src/common_audio/fir_filter_neon.cc \
                 src/common_audio/resampler/sinc_resampler_neon.cc \
                 src/common_audio/third_party/ooura/fft_size_128/ooura_fft_neon.cc \
                 src/modules/audio_processing/aecm/aecm_core_neon.cc \
                 src/modules/video_processing/util/denoiser_filter_neon.cc

CXX_SRCS=src/api/adaptation/resource.cc \
         src/api/audio/audio_frame.cc \
         src/api/audio/audio_processing.cc \
         src/api/audio/audio_processing_statistics.cc \
         src/api/audio/builtin_audio_processing_builder.cc \
         src/api/audio/channel_layout.cc \
         src/api/audio/echo_canceller3_config.cc \
         src/api/audio/echo_canceller3_factory.cc \
         src/api/audio_codecs/audio_codec_pair_id.cc \
         src/api/audio_codecs/audio_decoder.cc \
         src/api/audio_codecs/audio_encoder.cc \
         src/api/audio_codecs/audio_format.cc \
         src/api/audio_codecs/builtin_audio_decoder_factory.cc \
         src/api/audio_codecs/builtin_audio_encoder_factory.cc \
         src/api/audio_codecs/g711/audio_decoder_g711.cc \
         src/api/audio_codecs/g711/audio_encoder_g711.cc \
         src/api/audio_codecs/g722/audio_decoder_g722.cc \
         src/api/audio_codecs/g722/audio_encoder_g722.cc \
         src/api/audio_codecs/L16/audio_decoder_L16.cc \
         src/api/audio_codecs/L16/audio_encoder_L16.cc \
         src/api/audio_codecs/opus/audio_decoder_opus.cc \
         src/api/audio_codecs/opus/audio_encoder_multi_channel_opus.cc \
         src/api/audio_codecs/opus/audio_encoder_multi_channel_opus_config.cc \
         src/api/audio_codecs/opus/audio_encoder_opus.cc \
         src/api/audio_codecs/opus/audio_encoder_opus_config.cc \
         src/api/audio_options.cc \
         src/api/video_codecs/vp9_profile.cc \
         src/api/call/transport.cc \
         src/api/candidate.cc \
         src/api/create_peerconnection_factory.cc \
         src/api/crypto/crypto_options.cc \
         src/api/data_channel_interface.cc \
         src/api/dtls_transport_interface.cc \
         src/api/enable_media.cc \
         src/api/environment/environment_factory.cc \
         src/api/field_trials_registry.cc \
         src/api/frame_transformer_interface.cc \
         src/api/jsep.cc \
         src/api/jsep_ice_candidate.cc \
         src/api/legacy_stats_types.cc \
         src/api/media_stream_interface.cc \
         src/api/media_types.cc \
         src/api/neteq/custom_neteq_factory.cc \
         src/api/neteq/default_neteq_factory.cc \
         src/api/neteq/default_neteq_controller_factory.cc \
         src/api/neteq/neteq.cc \
         src/api/neteq/tick_timer.cc \
         src/api/peer_connection_interface.cc \
         src/api/rtc_error.cc \
         src/api/rtc_event_log/rtc_event.cc \
         src/api/rtc_event_log/rtc_event_log.cc \
         src/api/rtc_event_log/rtc_event_log_factory.cc \
         src/api/rtp_headers.cc \
         src/api/rtp_sender_interface.cc \
         src/api/rtp_packet_info.cc \
         src/api/rtp_parameters.cc \
         src/api/rtp_receiver_interface.cc \
         src/api/rtp_transceiver_interface.cc \
         src/api/sctp_transport_interface.cc \
         src/api/task_queue/default_task_queue_factory_stdlib.cc \
         src/api/task_queue/pending_task_safety_flag.cc \
         src/api/task_queue/task_queue_base.cc \
         src/api/transport/bitrate_settings.cc \
         src/api/transport/field_trial_based_config.cc \
         src/api/transport/goog_cc_factory.cc \
         src/api/transport/network_types.cc \
         src/api/transport/rtp/dependency_descriptor.cc \
         src/api/transport/stun.cc \
         src/api/units/data_rate.cc \
         src/api/units/data_size.cc \
         src/api/units/time_delta.cc \
         src/api/units/timestamp.cc \
         src/api/video/builtin_video_bitrate_allocator_factory.cc \
         src/api/video/color_space.cc \
         src/api/video/encoded_frame.cc \
         src/api/video/encoded_image.cc \
         src/api/video/frame_buffer.cc \
         src/api/video/hdr_metadata.cc \
         src/api/video/i010_buffer.cc \
         src/api/video/i210_buffer.cc \
         src/api/video/i420_buffer.cc \
         src/api/video/i422_buffer.cc \
         src/api/video/i444_buffer.cc \
         src/api/video/nv12_buffer.cc \
         src/api/video/video_adaptation_counters.cc \
         src/api/video/video_bitrate_allocation.cc \
         src/api/video/video_bitrate_allocator.cc \
         src/api/video/video_content_type.cc \
         src/api/video/video_frame.cc \
         src/api/video/video_frame_buffer.cc \
         src/api/video/video_frame_metadata.cc \
         src/api/video/video_source_interface.cc \
         src/api/video/video_timing.cc \
         src/api/video_codecs/av1_profile.cc \
         src/api/video_codecs/h264_profile_level_id.cc \
         src/api/video_codecs/video_codec.cc \
         src/api/video_codecs/video_decoder.cc \
         src/api/video_codecs/video_encoder.cc \
         src/api/video_codecs/sdp_video_format.cc \
         src/api/video_codecs/scalability_mode.cc \
         src/api/video_codecs/simulcast_stream.cc \
         src/audio/audio_level.cc \
         src/audio/audio_receive_stream.cc \
         src/audio/audio_send_stream.cc \
         src/audio/audio_state.cc \
         src/audio/audio_transport_impl.cc \
         src/audio/channel_receive.cc \
         src/audio/channel_receive_frame_transformer_delegate.cc \
         src/audio/channel_send.cc \
         src/audio/channel_send_frame_transformer_delegate.cc \
         src/audio/remix_resample.cc \
         src/audio/utility/audio_frame_operations.cc \
         src/audio/utility/channel_mixer.cc \
         src/audio/utility/channel_mixing_matrix.cc \
         src/call/adaptation/adaptation_constraint.cc \
         src/call/adaptation/broadcast_resource_listener.cc \
         src/call/adaptation/degradation_preference_provider.cc \
         src/call/adaptation/encoder_settings.cc \
         src/call/adaptation/resource_adaptation_processor.cc \
         src/call/adaptation/resource_adaptation_processor_interface.cc \
         src/call/adaptation/video_source_restrictions.cc \
         src/call/adaptation/video_stream_adapter.cc \
         src/call/adaptation/video_stream_input_state.cc \
         src/call/adaptation/video_stream_input_state_provider.cc \
         src/call/audio_receive_stream.cc \
         src/call/audio_send_stream.cc \
         src/call/audio_state.cc \
         src/call/bitrate_allocator.cc \
         src/call/call.cc \
         src/call/call_config.cc \
         src/call/fake_network_pipe.cc \
         src/call/flexfec_receive_stream.cc \
         src/call/flexfec_receive_stream_impl.cc \
         src/call/payload_type_picker.cc \
         src/call/receive_time_calculator.cc \
         src/call/rtp_bitrate_configurator.cc \
         src/call/rtp_config.cc \
         src/call/rtp_demuxer.cc \
         src/call/rtp_payload_params.cc \
         src/call/rtp_stream_receiver_controller.cc \
         src/call/rtp_transport_controller_send.cc \
         src/call/rtp_video_sender.cc \
         src/call/rtx_receive_stream.cc \
         src/call/syncable.cc \
         src/call/version.cc \
         src/call/video_receive_stream.cc \
         src/call/video_send_stream.cc \
         src/common_audio/audio_converter.cc \
         src/common_audio/audio_util.cc \
         src/common_audio/channel_buffer.cc \
         src/common_audio/fir_filter_c.cc \
         src/common_audio/fir_filter_factory.cc \
         src/common_audio/real_fourier.cc \
         src/common_audio/real_fourier_ooura.cc \
         src/common_audio/resampler/push_resampler.cc \
         src/common_audio/resampler/push_sinc_resampler.cc \
         src/common_audio/resampler/resampler.cc \
         src/common_audio/resampler/sinc_resampler.cc \
         src/common_audio/resampler/sinusoidal_linear_chirp_source.cc \
         src/common_audio/signal_processing/dot_product_with_scale.cc \
         src/common_audio/smoothing_filter.cc \
         src/common_audio/third_party/ooura/fft_size_128/ooura_fft.cc \
         src/common_audio/third_party/ooura/fft_size_256/fft4g.cc \
         src/common_audio/vad/vad.cc \
         src/common_audio/wav_file.cc \
         src/common_audio/wav_header.cc \
         src/common_audio/window_generator.cc \
         src/common_video/corruption_detection_converters.cc \
         src/common_video/bitrate_adjuster.cc \
         src/common_video/framerate_controller.cc \
         src/common_video/generic_frame_descriptor/generic_frame_info.cc \
         src/common_video/h264/h264_bitstream_parser.cc \
         src/common_video/h264/h264_common.cc \
         src/common_video/h264/pps_parser.cc \
         src/common_video/h264/sps_parser.cc \
         src/common_video/h264/sps_vui_rewriter.cc \
         src/common_video/libyuv/webrtc_libyuv.cc \
         src/common_video/video_frame_buffer.cc \
         src/logging/rtc_event_log/encoder/var_int.cc \
         src/logging/rtc_event_log/encoder/bit_writer.cc \
         src/logging/rtc_event_log/encoder/blob_encoding.cc \
         src/logging/rtc_event_log/encoder/delta_encoding.cc \
         src/logging/rtc_event_log/encoder/rtc_event_log_encoder_common.cc \
         src/logging/rtc_event_log/encoder/rtc_event_log_encoder_legacy.cc \
         src/logging/rtc_event_log/encoder/rtc_event_log_encoder_new_format.cc \
         src/logging/rtc_event_log/encoder/rtc_event_log_encoder_v3.cc \
         src/logging/rtc_event_log/events/fixed_length_encoding_parameters_v3.cc \
         src/logging/rtc_event_log/events/rtc_event_alr_state.cc \
         src/logging/rtc_event_log/events/rtc_event_audio_network_adaptation.cc \
         src/logging/rtc_event_log/events/rtc_event_audio_playout.cc \
         src/logging/rtc_event_log/events/rtc_event_audio_receive_stream_config.cc \
         src/logging/rtc_event_log/events/rtc_event_audio_send_stream_config.cc \
         src/logging/rtc_event_log/events/rtc_event_bwe_update_delay_based.cc \
         src/logging/rtc_event_log/events/rtc_event_bwe_update_loss_based.cc \
         src/logging/rtc_event_log/events/rtc_event_dtls_transport_state.cc \
         src/logging/rtc_event_log/events/rtc_event_dtls_writable_state.cc \
         src/logging/rtc_event_log/events/rtc_event_field_encoding_parser.cc \
         src/logging/rtc_event_log/events/rtc_event_field_extraction.cc \
         src/logging/rtc_event_log/events/rtc_event_ice_candidate_pair.cc \
         src/logging/rtc_event_log/events/rtc_event_ice_candidate_pair_config.cc \
         src/logging/rtc_event_log/events/rtc_event_neteq_set_minimum_delay.cc \
         src/logging/rtc_event_log/events/rtc_event_probe_cluster_created.cc \
         src/logging/rtc_event_log/events/rtc_event_probe_result_failure.cc \
         src/logging/rtc_event_log/events/rtc_event_probe_result_success.cc \
         src/logging/rtc_event_log/events/rtc_event_route_change.cc \
         src/logging/rtc_event_log/events/rtc_event_rtcp_packet_incoming.cc \
         src/logging/rtc_event_log/events/rtc_event_rtcp_packet_outgoing.cc \
         src/logging/rtc_event_log/events/rtc_event_rtp_packet_incoming.cc \
         src/logging/rtc_event_log/events/rtc_event_rtp_packet_outgoing.cc \
         src/logging/rtc_event_log/events/rtc_event_video_receive_stream_config.cc \
         src/logging/rtc_event_log/events/rtc_event_video_send_stream_config.cc \
         src/logging/rtc_event_log/ice_logger.cc \
         src/logging/rtc_event_log/rtc_event_log_impl.cc \
         src/logging/rtc_event_log/rtc_stream_config.cc \
         src/media/base/adapted_video_track_source.cc \
         src/media/base/codec.cc \
         src/media/base/codec_comparators.cc \
         src/media/base/codec_list.cc \
         src/media/base/sdp_video_format_utils.cc \
         src/media/base/media_channel_impl.cc \
         src/media/base/media_constants.cc \
         src/media/base/media_engine.cc \
         src/media/base/rid_description.cc \
         src/media/base/rtp_utils.cc \
         src/media/base/stream_params.cc \
         src/media/base/turn_utils.cc \
         src/media/base/video_adapter.cc \
         src/media/base/video_broadcaster.cc \
         src/media/base/video_common.cc \
         src/media/base/video_source_base.cc \
         src/media/engine/adm_helpers.cc \
         src/media/engine/webrtc_media_engine.cc \
         src/media/engine/webrtc_media_engine.cc \
         src/media/engine/webrtc_video_engine.cc \
         src/media/engine/webrtc_voice_engine.cc \
         src/media/sctp/dcsctp_transport.cc \
         src/media/sctp/sctp_transport_factory.cc \
         src/modules/async_audio_processing/async_audio_processing.cc \
         src/modules/audio_coding/acm2/acm_remixing.cc \
         src/modules/audio_coding/acm2/acm_resampler.cc \
         src/modules/audio_coding/acm2/audio_coding_module.cc \
         src/modules/audio_coding/acm2/call_statistics.cc \
         src/modules/audio_coding/audio_network_adaptor/audio_network_adaptor_config.cc \
         src/modules/audio_coding/audio_network_adaptor/audio_network_adaptor_impl.cc \
         src/modules/audio_coding/audio_network_adaptor/bitrate_controller.cc \
         src/modules/audio_coding/audio_network_adaptor/channel_controller.cc \
         src/modules/audio_coding/audio_network_adaptor/controller.cc \
         src/modules/audio_coding/audio_network_adaptor/controller_manager.cc \
         src/modules/audio_coding/audio_network_adaptor/debug_dump_writer.cc \
         src/modules/audio_coding/audio_network_adaptor/dtx_controller.cc \
         src/modules/audio_coding/audio_network_adaptor/event_log_writer.cc \
         src/modules/audio_coding/audio_network_adaptor/fec_controller_plr_based.cc \
         src/modules/audio_coding/audio_network_adaptor/frame_length_controller.cc \
         src/modules/audio_coding/audio_network_adaptor/frame_length_controller_v2.cc \
         src/modules/audio_coding/codecs/cng/audio_encoder_cng.cc \
         src/modules/audio_coding/codecs/cng/webrtc_cng.cc \
         src/modules/audio_coding/codecs/g711/audio_decoder_pcm.cc \
         src/modules/audio_coding/codecs/g711/audio_encoder_pcm.cc \
         src/modules/audio_coding/codecs/g722/audio_encoder_g722.cc \
         src/modules/audio_coding/codecs/legacy_encoded_audio_frame.cc \
         src/modules/audio_coding/codecs/opus/audio_coder_opus_common.cc \
         src/modules/audio_coding/codecs/opus/audio_decoder_multi_channel_opus_impl.cc \
         src/modules/audio_coding/codecs/opus/audio_decoder_opus.cc \
         src/modules/audio_coding/codecs/opus/audio_encoder_multi_channel_opus_impl.cc \
         src/modules/audio_coding/codecs/opus/audio_encoder_opus.cc \
         src/modules/audio_coding/codecs/opus/opus_interface.cc \
         src/modules/audio_coding/codecs/pcm16b/audio_decoder_pcm16b.cc \
         src/modules/audio_coding/codecs/pcm16b/audio_encoder_pcm16b.cc \
         src/modules/audio_coding/codecs/pcm16b/pcm16b_common.cc \
         src/modules/audio_coding/codecs/red/audio_encoder_copy_red.cc \
         src/modules/audio_coding/neteq/accelerate.cc \
         src/modules/audio_coding/neteq/audio_multi_vector.cc \
         src/modules/audio_coding/neteq/audio_vector.cc \
         src/modules/audio_coding/neteq/background_noise.cc \
         src/modules/audio_coding/neteq/buffer_level_filter.cc \
         src/modules/audio_coding/neteq/comfort_noise.cc \
         src/modules/audio_coding/neteq/cross_correlation.cc \
         src/modules/audio_coding/neteq/decision_logic.cc \
         src/modules/audio_coding/neteq/decoder_database.cc \
         src/modules/audio_coding/neteq/delay_constraints.cc \
         src/modules/audio_coding/neteq/delay_manager.cc \
         src/modules/audio_coding/neteq/dsp_helper.cc \
         src/modules/audio_coding/neteq/dtmf_buffer.cc \
         src/modules/audio_coding/neteq/dtmf_tone_generator.cc \
         src/modules/audio_coding/neteq/expand.cc \
         src/modules/audio_coding/neteq/expand_uma_logger.cc \
         src/modules/audio_coding/neteq/histogram.cc \
         src/modules/audio_coding/neteq/merge.cc \
         src/modules/audio_coding/neteq/nack_tracker.cc \
         src/modules/audio_coding/neteq/neteq_impl.cc \
         src/modules/audio_coding/neteq/normal.cc \
         src/modules/audio_coding/neteq/packet.cc \
         src/modules/audio_coding/neteq/packet_arrival_history.cc \
         src/modules/audio_coding/neteq/packet_buffer.cc \
         src/modules/audio_coding/neteq/preemptive_expand.cc \
         src/modules/audio_coding/neteq/random_vector.cc \
         src/modules/audio_coding/neteq/red_payload_splitter.cc \
         src/modules/audio_coding/neteq/reorder_optimizer.cc \
         src/modules/audio_coding/neteq/statistics_calculator.cc \
         src/modules/audio_coding/neteq/sync_buffer.cc \
         src/modules/audio_coding/neteq/timestamp_scaler.cc \
         src/modules/audio_coding/neteq/time_stretch.cc \
         src/modules/audio_coding/neteq/underrun_optimizer.cc \
         src/modules/audio_device/audio_device_buffer.cc \
         src/modules/audio_device/audio_device_generic.cc \
         src/modules/audio_device/audio_device_impl.cc \
         src/modules/audio_device/dummy/audio_device_dummy.cc \
         src/modules/audio_mixer/audio_frame_manipulator.cc \
         src/modules/audio_mixer/audio_mixer_impl.cc \
         src/modules/audio_mixer/default_output_rate_calculator.cc \
         src/modules/audio_mixer/frame_combiner.cc \
         src/modules/audio_processing/aec3/adaptive_fir_filter.cc \
         src/modules/audio_processing/aec3/adaptive_fir_filter_erl.cc \
         src/modules/audio_processing/aec3/aec3_common.cc \
         src/modules/audio_processing/aec3/aec3_fft.cc \
         src/modules/audio_processing/aec3/aec_state.cc \
         src/modules/audio_processing/aec3/alignment_mixer.cc \
         src/modules/audio_processing/aec3/api_call_jitter_metrics.cc \
         src/modules/audio_processing/aec3/block_buffer.cc \
         src/modules/audio_processing/aec3/block_delay_buffer.cc \
         src/modules/audio_processing/aec3/block_framer.cc \
         src/modules/audio_processing/aec3/block_processor.cc \
         src/modules/audio_processing/aec3/block_processor_metrics.cc \
         src/modules/audio_processing/aec3/clockdrift_detector.cc \
         src/modules/audio_processing/aec3/coarse_filter_update_gain.cc \
         src/modules/audio_processing/aec3/comfort_noise_generator.cc \
         src/modules/audio_processing/aec3/config_selector.cc \
         src/modules/audio_processing/aec3/decimator.cc \
         src/modules/audio_processing/aec3/dominant_nearend_detector.cc \
         src/modules/audio_processing/aec3/downsampled_render_buffer.cc \
         src/modules/audio_processing/aec3/echo_audibility.cc \
         src/modules/audio_processing/aec3/echo_canceller3.cc \
         src/modules/audio_processing/aec3/echo_path_delay_estimator.cc \
         src/modules/audio_processing/aec3/echo_path_variability.cc \
         src/modules/audio_processing/aec3/echo_remover.cc \
         src/modules/audio_processing/aec3/echo_remover_metrics.cc \
         src/modules/audio_processing/aec3/erle_estimator.cc \
         src/modules/audio_processing/aec3/erl_estimator.cc \
         src/modules/audio_processing/aec3/fft_buffer.cc \
         src/modules/audio_processing/aec3/filter_analyzer.cc \
         src/modules/audio_processing/aec3/frame_blocker.cc \
         src/modules/audio_processing/aec3/fullband_erle_estimator.cc \
         src/modules/audio_processing/aec3/matched_filter.cc \
         src/modules/audio_processing/aec3/matched_filter_lag_aggregator.cc \
         src/modules/audio_processing/aec3/moving_average.cc \
         src/modules/audio_processing/aec3/multi_channel_content_detector.cc \
         src/modules/audio_processing/aec3/refined_filter_update_gain.cc \
         src/modules/audio_processing/aec3/render_buffer.cc \
         src/modules/audio_processing/aec3/render_delay_buffer.cc \
         src/modules/audio_processing/aec3/render_delay_controller.cc \
         src/modules/audio_processing/aec3/render_delay_controller_metrics.cc \
         src/modules/audio_processing/aec3/render_signal_analyzer.cc \
         src/modules/audio_processing/aec3/residual_echo_estimator.cc \
         src/modules/audio_processing/aec3/reverb_decay_estimator.cc \
         src/modules/audio_processing/aec3/reverb_frequency_response.cc \
         src/modules/audio_processing/aec3/reverb_model.cc \
         src/modules/audio_processing/aec3/reverb_model_estimator.cc \
         src/modules/audio_processing/aec3/signal_dependent_erle_estimator.cc \
         src/modules/audio_processing/aec3/spectrum_buffer.cc \
         src/modules/audio_processing/aec3/stationarity_estimator.cc \
         src/modules/audio_processing/aec3/subband_erle_estimator.cc \
         src/modules/audio_processing/aec3/subband_nearend_detector.cc \
         src/modules/audio_processing/aec3/subtractor.cc \
         src/modules/audio_processing/aec3/subtractor_output_analyzer.cc \
         src/modules/audio_processing/aec3/subtractor_output.cc \
         src/modules/audio_processing/aec3/suppression_filter.cc \
         src/modules/audio_processing/aec3/suppression_gain.cc \
         src/modules/audio_processing/aec3/transparent_mode.cc \
         src/modules/audio_processing/aec_dump/aec_dump_impl.cc \
         src/modules/audio_processing/aec_dump/capture_stream_info.cc \
         src/modules/audio_processing/aecm/aecm_core.cc \
         src/modules/audio_processing/aecm/aecm_core_c.cc \
         src/modules/audio_processing/aecm/echo_control_mobile.cc \
         src/modules/audio_processing/agc/agc.cc \
         src/modules/audio_processing/agc/agc_manager_direct.cc \
         src/modules/audio_processing/agc/legacy/analog_agc.cc \
         src/modules/audio_processing/agc/legacy/digital_agc.cc \
         src/modules/audio_processing/agc/loudness_histogram.cc \
         src/modules/audio_processing/agc/utility.cc \
         src/modules/audio_processing/agc2/adaptive_digital_gain_controller.cc \
         src/modules/audio_processing/agc2/biquad_filter.cc \
         src/modules/audio_processing/agc2/clipping_predictor.cc \
         src/modules/audio_processing/agc2/clipping_predictor_level_buffer.cc \
         src/modules/audio_processing/agc2/compute_interpolated_gain_curve.cc \
         src/modules/audio_processing/agc2/cpu_features.cc \
         src/modules/audio_processing/agc2/fixed_digital_level_estimator.cc \
         src/modules/audio_processing/agc2/gain_applier.cc \
         src/modules/audio_processing/agc2/input_volume_controller.cc \
         src/modules/audio_processing/agc2/input_volume_stats_reporter.cc \
         src/modules/audio_processing/agc2/interpolated_gain_curve.cc \
         src/modules/audio_processing/agc2/limiter.cc \
         src/modules/audio_processing/agc2/noise_level_estimator.cc \
         src/modules/audio_processing/agc2/rnn_vad/auto_correlation.cc \
         src/modules/audio_processing/agc2/rnn_vad/features_extraction.cc \
         src/modules/audio_processing/agc2/rnn_vad/lp_residual.cc \
         src/modules/audio_processing/agc2/rnn_vad/pitch_search.cc \
         src/modules/audio_processing/agc2/rnn_vad/pitch_search_internal.cc \
         src/modules/audio_processing/agc2/rnn_vad/rnn.cc \
         src/modules/audio_processing/agc2/rnn_vad/rnn_fc.cc \
         src/modules/audio_processing/agc2/rnn_vad/rnn_gru.cc \
         src/modules/audio_processing/agc2/rnn_vad/rnn_vad_tool.cc \
         src/modules/audio_processing/agc2/rnn_vad/spectral_features.cc \
         src/modules/audio_processing/agc2/rnn_vad/spectral_features_internal.cc \
         src/modules/audio_processing/agc2/saturation_protector.cc \
         src/modules/audio_processing/agc2/saturation_protector_buffer.cc \
         src/modules/audio_processing/agc2/speech_level_estimator.cc \
         src/modules/audio_processing/agc2/vad_wrapper.cc \
         src/modules/audio_processing/agc2/vector_float_frame.cc \
         src/modules/audio_processing/audio_buffer.cc \
         src/modules/audio_processing/audio_processing_impl.cc \
         src/modules/audio_processing/capture_levels_adjuster/audio_samples_scaler.cc \
         src/modules/audio_processing/capture_levels_adjuster/capture_levels_adjuster.cc \
         src/modules/audio_processing/echo_control_mobile_impl.cc \
         src/modules/audio_processing/echo_detector/circular_buffer.cc \
         src/modules/audio_processing/echo_detector/mean_variance_estimator.cc \
         src/modules/audio_processing/echo_detector/moving_max.cc \
         src/modules/audio_processing/echo_detector/normalized_covariance_estimator.cc \
         src/modules/audio_processing/gain_control_impl.cc \
         src/modules/audio_processing/gain_controller2.cc \
         src/modules/audio_processing/high_pass_filter.cc \
         src/modules/audio_processing/include/aec_dump.cc \
         src/modules/audio_processing/include/audio_frame_proxies.cc \
         src/modules/audio_processing/logging/apm_data_dumper.cc \
         src/modules/audio_processing/ns/fast_math.cc \
         src/modules/audio_processing/ns/histograms.cc \
         src/modules/audio_processing/ns/noise_estimator.cc \
         src/modules/audio_processing/ns/noise_suppressor.cc \
         src/modules/audio_processing/ns/ns_fft.cc \
         src/modules/audio_processing/ns/prior_signal_model.cc \
         src/modules/audio_processing/ns/prior_signal_model_estimator.cc \
         src/modules/audio_processing/ns/quantile_noise_estimator.cc \
         src/modules/audio_processing/ns/signal_model.cc \
         src/modules/audio_processing/ns/signal_model_estimator.cc \
         src/modules/audio_processing/ns/speech_probability_estimator.cc \
         src/modules/audio_processing/ns/suppression_params.cc \
         src/modules/audio_processing/ns/wiener_filter.cc \
         src/modules/audio_processing/residual_echo_detector.cc \
         src/modules/audio_processing/rms_level.cc \
         src/modules/audio_processing/splitting_filter.cc \
         src/modules/audio_processing/three_band_filter_bank.cc \
         src/modules/audio_processing/vad/gmm.cc \
         src/modules/audio_processing/utility/cascaded_biquad_filter.cc \
         src/modules/audio_processing/utility/delay_estimator.cc \
         src/modules/audio_processing/utility/delay_estimator_wrapper.cc \
         src/modules/audio_processing/utility/pffft_wrapper.cc \
         src/modules/audio_processing/vad/pitch_based_vad.cc \
         src/modules/audio_processing/vad/pitch_internal.cc \
         src/modules/audio_processing/vad/pole_zero_filter.cc \
         src/modules/audio_processing/vad/standalone_vad.cc \
         src/modules/audio_processing/vad/vad_audio_proc.cc \
         src/modules/audio_processing/vad/vad_circular_buffer.cc \
         src/modules/audio_processing/vad/voice_activity_detector.cc \
         src/modules/congestion_controller/goog_cc/acknowledged_bitrate_estimator.cc \
         src/modules/congestion_controller/goog_cc/acknowledged_bitrate_estimator_interface.cc \
         src/modules/congestion_controller/goog_cc/alr_detector.cc \
         src/modules/congestion_controller/goog_cc/bitrate_estimator.cc \
         src/modules/congestion_controller/goog_cc/congestion_window_pushback_controller.cc \
         src/modules/congestion_controller/goog_cc/delay_based_bwe.cc \
         src/modules/congestion_controller/goog_cc/goog_cc_network_control.cc \
         src/modules/congestion_controller/goog_cc/inter_arrival_delta.cc \
         src/modules/congestion_controller/goog_cc/link_capacity_estimator.cc \
         src/modules/congestion_controller/goog_cc/loss_based_bandwidth_estimation.cc \
         src/modules/congestion_controller/goog_cc/loss_based_bwe_v2.cc \
         src/modules/congestion_controller/goog_cc/probe_bitrate_estimator.cc \
         src/modules/congestion_controller/goog_cc/probe_controller.cc \
         src/modules/congestion_controller/goog_cc/robust_throughput_estimator.cc \
         src/modules/congestion_controller/goog_cc/send_side_bandwidth_estimation.cc \
         src/modules/congestion_controller/goog_cc/trendline_estimator.cc \
         src/modules/congestion_controller/receive_side_congestion_controller.cc \
         src/modules/congestion_controller/remb_throttler.cc \
         src/modules/congestion_controller/rtp/control_handler.cc \
         src/modules/congestion_controller/rtp/transport_feedback_adapter.cc \
         src/modules/congestion_controller/rtp/transport_feedback_demuxer.cc \
         src/modules/pacing/bitrate_prober.cc \
         src/modules/pacing/interval_budget.cc \
         src/modules/pacing/pacing_controller.cc \
         src/modules/pacing/packet_router.cc \
         src/modules/pacing/prioritized_packet_queue.cc \
         src/modules/pacing/task_queue_paced_sender.cc \
         src/modules/remote_bitrate_estimator/aimd_rate_control.cc \
         src/modules/remote_bitrate_estimator/bwe_defines.cc \
         src/modules/remote_bitrate_estimator/congestion_control_feedback_tracker.cc \
         src/modules/remote_bitrate_estimator/congestion_control_feedback_generator.cc \
         src/modules/remote_bitrate_estimator/inter_arrival.cc \
         src/modules/remote_bitrate_estimator/overuse_detector.cc \
         src/modules/remote_bitrate_estimator/overuse_estimator.cc \
         src/modules/remote_bitrate_estimator/packet_arrival_map.cc \
         src/modules/remote_bitrate_estimator/remote_bitrate_estimator_abs_send_time.cc \
         src/modules/remote_bitrate_estimator/remote_bitrate_estimator_single_stream.cc \
         src/modules/remote_bitrate_estimator/transport_sequence_number_feedback_generator.cc \
         src/modules/rtp_rtcp/include/report_block_data.cc \
         src/modules/rtp_rtcp/include/rtp_rtcp_defines.cc \
         src/modules/rtp_rtcp/source/absolute_capture_time_interpolator.cc \
         src/modules/rtp_rtcp/source/absolute_capture_time_sender.cc \
         src/modules/rtp_rtcp/source/active_decode_targets_helper.cc \
         src/modules/rtp_rtcp/source/capture_clock_offset_updater.cc \
         src/modules/rtp_rtcp/source/create_video_rtp_depacketizer.cc \
         src/modules/rtp_rtcp/source/corruption_detection_extension.cc \
         src/modules/rtp_rtcp/source/dtmf_queue.cc \
         src/modules/rtp_rtcp/source/fec_private_tables_bursty.cc \
         src/modules/rtp_rtcp/source/fec_private_tables_random.cc \
         src/modules/rtp_rtcp/source/flexfec_header_reader_writer.cc \
         src/modules/rtp_rtcp/source/flexfec_receiver.cc \
         src/modules/rtp_rtcp/source/flexfec_sender.cc \
         src/modules/rtp_rtcp/source/flexfec_03_header_reader_writer.cc \
         src/modules/rtp_rtcp/source/frame_object.cc \
         src/modules/rtp_rtcp/source/forward_error_correction.cc \
         src/modules/rtp_rtcp/source/forward_error_correction_internal.cc \
         src/modules/rtp_rtcp/source/leb128.cc \
         src/modules/rtp_rtcp/source/ntp_time_util.cc \
         src/modules/rtp_rtcp/source/packet_loss_stats.cc \
         src/modules/rtp_rtcp/source/packet_sequencer.cc \
         src/modules/rtp_rtcp/source/receive_statistics_impl.cc \
         src/modules/rtp_rtcp/source/remote_ntp_time_estimator.cc \
         src/modules/rtp_rtcp/source/rtcp_nack_stats.cc \
         src/modules/rtp_rtcp/source/rtcp_packet.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/app.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/bye.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/congestion_control_feedback.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/common_header.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/compound_packet.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/dlrr.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/extended_reports.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/fir.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/loss_notification.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/nack.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/pli.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/psfb.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/rapid_resync_request.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/receiver_report.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/remb.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/remote_estimate.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/report_block.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/rrtr.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/rtpfb.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/sdes.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/sender_report.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/target_bitrate.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/tmmb_item.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/tmmbn.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/tmmbr.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/transport_feedback.cc \
         src/modules/rtp_rtcp/source/rtcp_receiver.cc \
         src/modules/rtp_rtcp/source/rtcp_sender.cc \
         src/modules/rtp_rtcp/source/rtcp_transceiver.cc \
         src/modules/rtp_rtcp/source/rtcp_transceiver_config.cc \
         src/modules/rtp_rtcp/source/rtcp_transceiver_impl.cc \
         src/modules/rtp_rtcp/source/rtp_descriptor_authentication.cc \
         src/modules/rtp_rtcp/source/rtp_dependency_descriptor_extension.cc \
         src/modules/rtp_rtcp/source/rtp_dependency_descriptor_reader.cc \
         src/modules/rtp_rtcp/source/rtp_dependency_descriptor_writer.cc \
         src/modules/rtp_rtcp/source/rtp_format.cc \
         src/modules/rtp_rtcp/source/rtp_format_h264.cc \
         src/modules/rtp_rtcp/source/rtp_format_video_generic.cc \
         src/modules/rtp_rtcp/source/rtp_format_vp8.cc \
         src/modules/rtp_rtcp/source/rtp_format_vp9.cc \
         src/modules/rtp_rtcp/source/rtp_generic_frame_descriptor.cc \
         src/modules/rtp_rtcp/source/rtp_generic_frame_descriptor_extension.cc \
         src/modules/rtp_rtcp/source/rtp_header_extension_map.cc \
         src/modules/rtp_rtcp/source/rtp_header_extensions.cc \
         src/modules/rtp_rtcp/source/rtp_header_extension_size.cc \
         src/modules/rtp_rtcp/source/rtp_packet.cc \
         src/modules/rtp_rtcp/source/rtp_packet_history.cc \
         src/modules/rtp_rtcp/source/rtp_packet_received.cc \
         src/modules/rtp_rtcp/source/rtp_packet_to_send.cc \
         src/modules/rtp_rtcp/source/rtp_packetizer_av1.cc \
         src/modules/rtp_rtcp/source/rtp_packet_send_info.cc \
         src/modules/rtp_rtcp/source/rtp_rtcp_impl.cc \
         src/modules/rtp_rtcp/source/rtp_rtcp_impl2.cc \
         src/modules/rtp_rtcp/source/rtp_sender_audio.cc \
         src/modules/rtp_rtcp/source/rtp_sender.cc \
         src/modules/rtp_rtcp/source/rtp_sender_egress.cc \
         src/modules/rtp_rtcp/source/rtp_sender_video.cc \
         src/modules/rtp_rtcp/source/rtp_sender_video_frame_transformer_delegate.cc \
         src/modules/rtp_rtcp/source/rtp_sequence_number_map.cc \
         src/modules/rtp_rtcp/source/rtp_util.cc \
         src/modules/rtp_rtcp/source/rtp_video_header.cc \
         src/modules/rtp_rtcp/source/rtp_video_layers_allocation_extension.cc \
         src/modules/rtp_rtcp/source/rtp_video_stream_receiver_frame_transformer_delegate.cc \
         src/modules/rtp_rtcp/source/source_tracker.cc \
         src/modules/rtp_rtcp/source/tmmbr_help.cc \
         src/modules/rtp_rtcp/source/ulpfec_generator.cc \
         src/modules/rtp_rtcp/source/ulpfec_header_reader_writer.cc \
         src/modules/rtp_rtcp/source/ulpfec_receiver.cc \
         src/modules/rtp_rtcp/source/video_rtp_depacketizer.cc \
         src/modules/rtp_rtcp/source/video_rtp_depacketizer_av1.cc \
         src/modules/rtp_rtcp/source/video_rtp_depacketizer_generic.cc \
         src/modules/rtp_rtcp/source/video_rtp_depacketizer_h264.cc \
         src/modules/rtp_rtcp/source/video_rtp_depacketizer_raw.cc \
         src/modules/rtp_rtcp/source/video_rtp_depacketizer_vp8.cc \
         src/modules/rtp_rtcp/source/video_rtp_depacketizer_vp9.cc \
         src/modules/video_capture/device_info_impl.cc \
         src/modules/video_capture/video_capture_factory.cc \
         src/modules/video_capture/video_capture_impl.cc \
         src/modules/video_coding/chain_diff_calculator.cc \
         src/modules/video_coding/codecs/av1/av1_svc_config.cc \
         src/modules/video_coding/codecs/vp8/vp8_scalability.cc \
         src/modules/video_coding/codecs/vp9/svc_config.cc \
         src/modules/video_coding/decoder_database.cc \
         src/modules/video_coding/encoded_frame.cc \
         src/modules/video_coding/fec_controller_default.cc \
         src/modules/video_coding/frame_dependencies_calculator.cc \
         src/modules/video_coding/frame_helpers.cc \
         src/modules/video_coding/generic_decoder.cc \
         src/modules/video_coding/h264_sprop_parameter_sets.cc \
         src/modules/video_coding/h264_sps_pps_tracker.cc \
         src/modules/video_coding/h26x_packet_buffer.cc \
         src/modules/video_coding/histogram.cc \
         src/modules/video_coding/include/video_codec_interface.cc \
         src/modules/video_coding/loss_notification_controller.cc \
         src/modules/video_coding/media_opt_util.cc \
         src/modules/video_coding/nack_requester.cc \
         src/modules/video_coding/packet_buffer.cc \
         src/modules/video_coding/rtp_frame_id_only_ref_finder.cc \
         src/modules/video_coding/rtp_frame_reference_finder.cc \
         src/modules/video_coding/rtp_generic_ref_finder.cc \
         src/modules/video_coding/rtp_seq_num_only_ref_finder.cc \
         src/modules/video_coding/rtp_vp8_ref_finder.cc \
         src/modules/video_coding/rtp_vp9_ref_finder.cc \
         src/modules/video_coding/svc/create_scalability_structure.cc \
         src/modules/video_coding/svc/scalability_mode_util.cc \
         src/modules/video_coding/svc/scalability_structure_full_svc.cc \
         src/modules/video_coding/svc/scalability_structure_key_svc.cc \
         src/modules/video_coding/svc/scalability_structure_l2t2_key_shift.cc \
         src/modules/video_coding/svc/scalability_structure_simulcast.cc \
         src/modules/video_coding/svc/scalable_video_controller_no_layering.cc \
         src/modules/video_coding/svc/svc_rate_allocator.cc \
         src/modules/video_coding/timing/decode_time_percentile_filter.cc \
         src/modules/video_coding/timing/frame_delay_variation_kalman_filter.cc \
         src/modules/video_coding/timing/inter_frame_delay_variation_calculator.cc \
         src/modules/video_coding/timing/jitter_estimator.cc \
         src/modules/video_coding/timing/rtt_filter.cc \
         src/modules/video_coding/timing/timestamp_extrapolator.cc \
         src/modules/video_coding/timing/timing.cc \
         src/modules/video_coding/utility/bandwidth_quality_scaler.cc \
         src/modules/video_coding/utility/decoded_frames_history.cc \
         src/modules/video_coding/utility/frame_dropper.cc \
         src/modules/video_coding/utility/ivf_file_writer.cc \
         src/modules/video_coding/utility/qp_parser.cc \
         src/modules/video_coding/utility/quality_scaler.cc \
         src/modules/video_coding/utility/simulcast_rate_allocator.cc \
         src/modules/video_coding/utility/simulcast_utility.cc \
         src/modules/video_coding/utility/vp8_header_parser.cc \
         src/modules/video_coding/utility/vp9_uncompressed_header_parser.cc \
         src/modules/video_coding/video_codec_initializer.cc \
         src/modules/video_coding/video_coding_defines.cc \
         src/modules/video_coding/video_coding_impl.cc \
         src/modules/video_coding/video_receiver.cc \
         src/modules/video_coding/video_receiver2.cc \
         src/net/dcsctp/fuzzers/dcsctp_fuzzers.cc \
         src/net/dcsctp/packet/chunk/abort_chunk.cc \
         src/net/dcsctp/packet/chunk/chunk.cc \
         src/net/dcsctp/packet/chunk/cookie_ack_chunk.cc \
         src/net/dcsctp/packet/chunk/cookie_echo_chunk.cc \
         src/net/dcsctp/packet/chunk/data_chunk.cc \
         src/net/dcsctp/packet/chunk/error_chunk.cc \
         src/net/dcsctp/packet/chunk/forward_tsn_chunk.cc \
         src/net/dcsctp/packet/chunk/heartbeat_ack_chunk.cc \
         src/net/dcsctp/packet/chunk/heartbeat_request_chunk.cc \
         src/net/dcsctp/packet/chunk/idata_chunk.cc \
         src/net/dcsctp/packet/chunk/iforward_tsn_chunk.cc \
         src/net/dcsctp/packet/chunk/init_ack_chunk.cc \
         src/net/dcsctp/packet/chunk/init_chunk.cc \
         src/net/dcsctp/packet/chunk/reconfig_chunk.cc \
         src/net/dcsctp/packet/chunk/sack_chunk.cc \
         src/net/dcsctp/packet/chunk/shutdown_ack_chunk.cc \
         src/net/dcsctp/packet/chunk/shutdown_chunk.cc \
         src/net/dcsctp/packet/chunk/shutdown_complete_chunk.cc \
         src/net/dcsctp/packet/chunk_validators.cc \
         src/net/dcsctp/packet/crc32c.cc \
         src/net/dcsctp/packet/error_cause/cookie_received_while_shutting_down_cause.cc \
         src/net/dcsctp/packet/error_cause/error_cause.cc \
         src/net/dcsctp/packet/error_cause/invalid_mandatory_parameter_cause.cc \
         src/net/dcsctp/packet/error_cause/invalid_stream_identifier_cause.cc \
         src/net/dcsctp/packet/error_cause/missing_mandatory_parameter_cause.cc \
         src/net/dcsctp/packet/error_cause/no_user_data_cause.cc \
         src/net/dcsctp/packet/error_cause/out_of_resource_error_cause.cc \
         src/net/dcsctp/packet/error_cause/protocol_violation_cause.cc \
         src/net/dcsctp/packet/error_cause/restart_of_an_association_with_new_address_cause.cc \
         src/net/dcsctp/packet/error_cause/stale_cookie_error_cause.cc \
         src/net/dcsctp/packet/error_cause/unrecognized_chunk_type_cause.cc \
         src/net/dcsctp/packet/error_cause/unrecognized_parameter_cause.cc \
         src/net/dcsctp/packet/error_cause/unresolvable_address_cause.cc \
         src/net/dcsctp/packet/error_cause/user_initiated_abort_cause.cc \
         src/net/dcsctp/packet/parameter/add_incoming_streams_request_parameter.cc \
         src/net/dcsctp/packet/parameter/add_outgoing_streams_request_parameter.cc \
         src/net/dcsctp/packet/parameter/forward_tsn_supported_parameter.cc \
         src/net/dcsctp/packet/parameter/heartbeat_info_parameter.cc \
         src/net/dcsctp/packet/parameter/incoming_ssn_reset_request_parameter.cc \
         src/net/dcsctp/packet/parameter/outgoing_ssn_reset_request_parameter.cc \
         src/net/dcsctp/packet/parameter/parameter.cc \
         src/net/dcsctp/packet/parameter/reconfiguration_response_parameter.cc \
         src/net/dcsctp/packet/parameter/ssn_tsn_reset_request_parameter.cc \
         src/net/dcsctp/packet/parameter/state_cookie_parameter.cc \
         src/net/dcsctp/packet/parameter/supported_extensions_parameter.cc \
         src/net/dcsctp/packet/parameter/zero_checksum_acceptable_chunk_parameter.cc \
         src/net/dcsctp/packet/sctp_packet.cc \
         src/net/dcsctp/packet/tlv_trait.cc \
         src/net/dcsctp/public/dcsctp_handover_state.cc \
         src/net/dcsctp/public/dcsctp_socket_factory.cc \
         src/net/dcsctp/public/text_pcap_packet_observer.cc \
         src/net/dcsctp/rx/data_tracker.cc \
         src/net/dcsctp/rx/interleaved_reassembly_streams.cc \
         src/net/dcsctp/rx/reassembly_queue.cc \
         src/net/dcsctp/rx/traditional_reassembly_streams.cc \
         src/net/dcsctp/socket/callback_deferrer.cc \
         src/net/dcsctp/socket/dcsctp_socket.cc \
         src/net/dcsctp/socket/heartbeat_handler.cc \
         src/net/dcsctp/socket/packet_sender.cc \
         src/net/dcsctp/socket/state_cookie.cc \
         src/net/dcsctp/socket/stream_reset_handler.cc \
         src/net/dcsctp/socket/transmission_control_block.cc \
         src/net/dcsctp/timer/task_queue_timeout.cc \
         src/net/dcsctp/timer/timer.cc \
         src/net/dcsctp/tx/outstanding_data.cc \
         src/net/dcsctp/tx/retransmission_error_counter.cc \
         src/net/dcsctp/tx/retransmission_queue.cc \
         src/net/dcsctp/tx/retransmission_timeout.cc \
         src/net/dcsctp/tx/rr_send_queue.cc \
         src/net/dcsctp/tx/stream_scheduler.cc \
         src/p2p/base/async_stun_tcp_socket.cc \
         src/p2p/base/basic_async_resolver_factory.cc \
         src/p2p/base/basic_ice_controller.cc \
         src/p2p/base/basic_packet_socket_factory.cc \
         src/p2p/base/connection.cc \
         src/p2p/base/connection_info.cc \
         src/p2p/base/default_ice_transport_factory.cc \
         src/p2p/base/ice_credentials_iterator.cc \
         src/p2p/base/ice_switch_reason.cc \
         src/p2p/base/ice_transport_internal.cc \
         src/p2p/base/p2p_constants.cc \
         src/p2p/base/p2p_transport_channel.cc \
         src/p2p/base/packet_transport_internal.cc \
         src/p2p/base/port_allocator.cc \
         src/p2p/base/port.cc \
         src/p2p/base/port_interface.cc \
         src/p2p/base/pseudo_tcp.cc \
         src/p2p/base/regathering_controller.cc \
         src/p2p/base/stun_dictionary.cc \
         src/p2p/base/stun_port.cc \
         src/p2p/base/stun_request.cc \
         src/p2p/base/tcp_port.cc \
         src/p2p/base/transport_description.cc \
         src/p2p/base/transport_description_factory.cc \
         src/p2p/base/turn_port.cc \
         src/p2p/base/wrapping_active_ice_controller.cc \
         src/p2p/client/basic_port_allocator.cc \
         src/p2p/client/turn_port_factory.cc \
         src/p2p/dtls/dtls_transport.cc \
         src/p2p/dtls/dtls_transport_internal.cc \
         src/p2p/dtls/dtls_stun_piggyback_controller.cc \
         src/p2p/dtls/dtls_utils.cc \
         src/p2p/test/stun_server.cc \
         src/p2p/test/turn_server.cc \
         src/pc/audio_rtp_receiver.cc \
         src/pc/audio_track.cc \
         src/pc/channel.cc \
         src/pc/codec_vendor.cc \
         src/pc/connection_context.cc \
         src/pc/data_channel_controller.cc \
         src/pc/data_channel_utils.cc \
         src/pc/dtls_srtp_transport.cc \
         src/pc/dtls_transport.cc \
         src/pc/dtmf_sender.cc \
         src/pc/external_hmac.cc \
         src/pc/ice_transport.cc \
         src/pc/ice_server_parsing.cc \
         src/pc/jitter_buffer_delay.cc \
         src/pc/jsep_ice_candidate.cc \
         src/pc/jsep_session_description.cc \
         src/pc/jsep_transport.cc \
         src/pc/jsep_transport_collection.cc \
         src/pc/jsep_transport_controller.cc \
         src/pc/legacy_stats_collector.cc \
         src/pc/local_audio_source.cc \
         src/pc/media_options.cc \
         src/pc/media_protocol_names.cc \
         src/pc/media_session.cc \
         src/pc/media_stream.cc \
         src/pc/media_stream_observer.cc \
         src/pc/peer_connection.cc \
         src/pc/peer_connection_factory.cc \
         src/pc/peer_connection_message_handler.cc \
         src/pc/remote_audio_source.cc \
         src/pc/rtcp_mux_filter.cc \
         src/pc/rtc_stats_collector.cc \
         src/pc/rtc_stats_traversal.cc \
         src/pc/rtp_media_utils.cc \
         src/pc/rtp_parameters_conversion.cc \
         src/pc/rtp_receiver.cc \
         src/pc/rtp_sender.cc \
         src/pc/rtp_transceiver.cc \
         src/pc/rtp_transmission_manager.cc \
         src/pc/rtp_transport.cc \
         src/pc/sctp_transport.cc \
         src/pc/sctp_utils.cc \
         src/pc/simulcast_description.cc \
         src/pc/simulcast_sdp_serializer.cc \
         src/pc/sdp_munging_detector.cc \
         src/pc/sdp_offer_answer.cc \
         src/pc/sdp_utils.cc \
         src/pc/session_description.cc \
         src/pc/srtp_session.cc \
         src/pc/srtp_transport.cc \
         src/pc/sctp_data_channel.cc \
         src/pc/track_media_info_map.cc \
         src/pc/transceiver_list.cc \
         src/pc/transport_stats.cc \
         src/pc/typed_codec_vendor.cc \
         src/pc/usage_pattern.cc \
         src/pc/video_rtp_receiver.cc \
         src/pc/video_rtp_track_source.cc \
         src/pc/video_track.cc \
         src/pc/video_track_source.cc \
         src/pc/webrtc_sdp.cc \
         src/pc/webrtc_session_description_factory.cc \
         src/rtc_base/async_dns_resolver.cc \
         src/rtc_base/async_packet_socket.cc \
         src/rtc_base/async_socket.cc \
         src/rtc_base/async_tcp_socket.cc \
         src/rtc_base/async_udp_socket.cc \
         src/rtc_base/base64.cc \
         src/rtc_base/bit_buffer.cc \
         src/rtc_base/bitstream_reader.cc \
         src/rtc_base/bitrate_tracker.cc \
         src/rtc_base/buffer_queue.cc \
         src/rtc_base/byte_buffer.cc \
         src/rtc_base/callback_list.cc \
         src/rtc_base/checks.cc \
         src/rtc_base/copy_on_write_buffer.cc \
         src/rtc_base/cpu_time.cc \
         src/rtc_base/crc32.cc \
         src/rtc_base/crypto_random.cc \
         src/rtc_base/data_rate_limiter.cc \
         src/rtc_base/deprecated/recursive_critical_section.cc \
         src/rtc_base/event.cc \
         src/rtc_base/event_tracer.cc \
         src/rtc_base/experiments/alr_experiment.cc \
         src/rtc_base/experiments/balanced_degradation_settings.cc \
         src/rtc_base/experiments/encoder_info_settings.cc \
         src/rtc_base/experiments/field_trial_list.cc \
         src/rtc_base/experiments/field_trial_parser.cc \
         src/rtc_base/experiments/field_trial_units.cc \
         src/rtc_base/experiments/keyframe_interval_settings.cc \
         src/rtc_base/experiments/min_video_bitrate_experiment.cc \
         src/rtc_base/experiments/normalize_simulcast_size_experiment.cc \
         src/rtc_base/experiments/quality_scaler_settings.cc \
         src/rtc_base/experiments/quality_scaling_experiment.cc \
         src/rtc_base/experiments/rate_control_settings.cc \
         src/rtc_base/experiments/stable_target_rate_experiment.cc \
         src/rtc_base/experiments/struct_parameters_parser.cc \
         src/rtc_base/fake_clock.cc \
         src/rtc_base/fake_ssl_identity.cc \
         src/rtc_base/frequency_tracker.cc \
         src/rtc_base/file_rotating_stream.cc \
         src/rtc_base/ifaddrs_converter.cc \
         src/rtc_base/internal/default_socket_server.cc \
         src/rtc_base/ip_address.cc \
         src/rtc_base/logging.cc \
         src/rtc_base/log_sinks.cc \
         src/rtc_base/memory_usage.cc \
         src/rtc_base/memory/aligned_malloc.cc \
         src/rtc_base/message_digest.cc \
         src/rtc_base/net_helper.cc \
         src/rtc_base/net_helpers.cc \
         src/rtc_base/network/sent_packet.cc \
         src/rtc_base/network/received_packet.cc \
         src/rtc_base/network.cc \
         src/rtc_base/network_constants.cc \
         src/rtc_base/network_monitor.cc \
         src/rtc_base/network_route.cc \
         src/rtc_base/null_socket_server.cc \
         src/rtc_base/numerics/event_based_exponential_moving_average.cc \
         src/rtc_base/numerics/exp_filter.cc \
         src/rtc_base/numerics/histogram_percentile_counter.cc \
         src/rtc_base/numerics/moving_average.cc \
         src/rtc_base/numerics/sample_counter.cc \
         src/rtc_base/openssl_adapter.cc \
         src/rtc_base/openssl_certificate.cc \
         src/rtc_base/openssl_digest.cc \
         src/rtc_base/openssl_identity.cc \
         src/rtc_base/openssl_key_pair.cc \
         src/rtc_base/openssl_session_cache.cc \
         src/rtc_base/openssl_stream_adapter.cc \
         src/rtc_base/openssl_utility.cc \
         src/rtc_base/operations_chain.cc \
         src/rtc_base/physical_socket_server.cc \
         src/rtc_base/platform_thread.cc \
         src/rtc_base/platform_thread_types.cc \
         src/rtc_base/proxy_server.cc \
         src/rtc_base/race_checker.cc \
         src/rtc_base/random.cc \
         src/rtc_base/rate_limiter.cc \
         src/rtc_base/rate_statistics.cc \
         src/rtc_base/rate_tracker.cc \
         src/rtc_base/rtc_certificate.cc \
         src/rtc_base/rtc_certificate_generator.cc \
         src/rtc_base/socket_adapters.cc \
         src/rtc_base/socket_address.cc \
         src/rtc_base/socket_address_pair.cc \
         src/rtc_base/socket.cc \
         src/rtc_base/ssl_adapter.cc \
         src/rtc_base/ssl_certificate.cc \
         src/rtc_base/ssl_fingerprint.cc \
         src/rtc_base/ssl_identity.cc \
         src/rtc_base/ssl_stream_adapter.cc \
         src/rtc_base/stream.cc \
         src/rtc_base/string_encode.cc \
         src/rtc_base/string_to_number.cc \
         src/rtc_base/strings/json.cc \
         src/rtc_base/strings/string_builder.cc \
         src/rtc_base/strings/string_format.cc \
         src/rtc_base/string_utils.cc \
         src/rtc_base/synchronization/sequence_checker_internal.cc \
         src/rtc_base/synchronization/yield.cc \
         src/rtc_base/synchronization/yield_policy.cc \
         src/rtc_base/system/file_wrapper.cc \
         src/rtc_base/system_time.cc \
         src/rtc_base/task_queue_stdlib.cc \
         src/rtc_base/task_utils/repeating_task.cc \
         src/rtc_base/third_party/base64/base64.cc \
         src/rtc_base/thread.cc \
         src/rtc_base/timestamp_aligner.cc \
         src/rtc_base/time_utils.cc \
         src/rtc_base/unique_id_generator.cc \
         src/rtc_base/virtual_socket_server.cc \
         src/rtc_base/weak_ptr.cc \
         src/rtc_base/zero_memory.cc \
         src/stats/attribute.cc \
         src/stats/rtc_stats.cc \
         src/stats/rtc_stats_report.cc \
         src/stats/rtcstats_objects.cc \
         src/system_wrappers/source/clock.cc \
         src/system_wrappers/source/cpu_features.cc \
         src/system_wrappers/source/cpu_info.cc \
         src/system_wrappers/source/denormal_disabler.cc \
         src/system_wrappers/source/field_trial.cc \
         src/system_wrappers/source/metrics.cc \
         src/system_wrappers/source/rtp_to_ntp_estimator.cc \
         src/system_wrappers/source/sleep.cc \
         src/video/adaptation/balanced_constraint.cc \
         src/video/adaptation/bandwidth_quality_scaler_resource.cc \
         src/video/adaptation/bitrate_constraint.cc \
         src/video/adaptation/encode_usage_resource.cc \
         src/video/adaptation/overuse_frame_detector.cc \
         src/video/adaptation/pixel_limit_resource.cc \
         src/video/adaptation/quality_scaler_resource.cc \
         src/video/adaptation/video_stream_encoder_resource.cc \
         src/video/adaptation/video_stream_encoder_resource_manager.cc \
         src/video/alignment_adjuster.cc \
         src/video/buffered_frame_decryptor.cc \
         src/video/call_stats2.cc \
         src/video/config/encoder_stream_factory.cc \
         src/video/config/simulcast.cc \
         src/video/config/video_encoder_config.cc \
         src/video/corruption_detection/corruption_classifier.cc \
         src/video/corruption_detection/frame_instrumentation_generator.cc \
         src/video/corruption_detection/frame_instrumentation_evaluation.cc \
         src/video/corruption_detection/generic_mapping_functions.cc \
         src/video/corruption_detection/halton_frame_sampler.cc \
         src/video/corruption_detection/halton_sequence.cc \
         src/video/decode_synchronizer.cc \
         src/video/encoder_bitrate_adjuster.cc \
         src/video/encoder_overshoot_detector.cc \
         src/video/encoder_rtcp_feedback.cc \
         src/video/frame_cadence_adapter.cc \
         src/video/frame_decode_timing.cc \
         src/video/frame_dumping_decoder.cc \
         src/video/frame_dumping_encoder.cc \
         src/video/frame_encode_metadata_writer.cc \
         src/video/quality_convergence_monitor.cc \
         src/video/quality_convergence_controller.cc \
         src/video/quality_limitation_reason_tracker.cc \
         src/video/rate_utilization_tracker.cc \
         src/video/receive_statistics_proxy.cc \
         src/video/report_block_stats.cc \
         src/video/render/incoming_video_stream.cc \
         src/video/render/video_render_frames.cc \
		 src/video/rtp_streams_synchronizer2.cc \
         src/video/rtp_video_stream_receiver2.cc \
         src/video/send_delay_stats.cc \
         src/video/send_statistics_proxy.cc \
         src/video/stats_counter.cc \
         src/video/stream_synchronization.cc \
         src/video/task_queue_frame_decode_scheduler.cc \
         src/video/transport_adapter.cc \
         src/video/unique_timestamp_counter.cc \
         src/video/video_quality_observer2.cc \
         src/video/video_receive_stream_timeout_tracker.cc \
         src/video/video_receive_stream2.cc \
         src/video/video_send_stream_impl.cc \
         src/video/video_source_sink_controller.cc \
         src/video/video_stream_buffer_controller.cc \
         src/video/video_stream_decoder2.cc \
         src/video/video_stream_encoder.cc \
         $(CXX_SRCS/pb) \
         $(CXX_SRCS/$(OS)) \
         $(CXX_SRCS/$(ARCH))

YUV_SRCS/armv7l=src/third_party/libyuv/source/compare_neon.cc \
                src/third_party/libyuv/source/rotate_neon.cc \
                src/third_party/libyuv/source/row_neon.cc \
                src/third_party/libyuv/source/scale_neon.cc

YUV_SRCS/aarch64=src/third_party/libyuv/source/compare_neon64.cc \
                 src/third_party/libyuv/source/rotate_neon64.cc \
                 src/third_party/libyuv/source/row_neon64.cc \
                 src/third_party/libyuv/source/scale_neon64.cc

YUV_SRCS=src/third_party/libyuv/source/compare.cc \
         src/third_party/libyuv/source/compare_common.cc \
         src/third_party/libyuv/source/compare_gcc.cc \
         src/third_party/libyuv/source/convert.cc \
         src/third_party/libyuv/source/convert_argb.cc \
         src/third_party/libyuv/source/convert_from.cc \
         src/third_party/libyuv/source/convert_from_argb.cc \
         src/third_party/libyuv/source/convert_jpeg.cc \
         src/third_party/libyuv/source/convert_to_argb.cc \
         src/third_party/libyuv/source/convert_to_i420.cc \
         src/third_party/libyuv/source/cpu_id.cc \
         src/third_party/libyuv/source/mjpeg_decoder.cc \
         src/third_party/libyuv/source/mjpeg_validate.cc \
         src/third_party/libyuv/source/planar_functions.cc \
         src/third_party/libyuv/source/rotate.cc \
         src/third_party/libyuv/source/rotate_any.cc \
         src/third_party/libyuv/source/rotate_argb.cc \
         src/third_party/libyuv/source/rotate_common.cc \
         src/third_party/libyuv/source/rotate_gcc.cc \
         src/third_party/libyuv/source/row_any.cc \
         src/third_party/libyuv/source/row_common.cc \
         src/third_party/libyuv/source/row_gcc.cc \
         src/third_party/libyuv/source/scale.cc \
         src/third_party/libyuv/source/scale_argb.cc \
         src/third_party/libyuv/source/scale_any.cc \
         src/third_party/libyuv/source/scale_common.cc \
         src/third_party/libyuv/source/scale_gcc.cc \
         src/third_party/libyuv/source/scale_uv.cc \
         src/third_party/libyuv/source/video_common.cc \
         $(YUV_SRCS/$(ARCH))

LIBSRTP_SRCS=src/third_party/libsrtp/crypto/cipher/aes_gcm_ossl.c \
             src/third_party/libsrtp/crypto/cipher/aes_icm_ossl.c \
             src/third_party/libsrtp/crypto/cipher/cipher.c \
             src/third_party/libsrtp/crypto/cipher/cipher_test_cases.c \
             src/third_party/libsrtp/crypto/cipher/null_cipher.c \
             src/third_party/libsrtp/crypto/hash/auth.c \
             src/third_party/libsrtp/crypto/hash/auth_test_cases.c \
             src/third_party/libsrtp/crypto/hash/hmac_ossl.c \
             src/third_party/libsrtp/crypto/hash/null_auth.c \
             src/third_party/libsrtp/crypto/kernel/alloc.c \
             src/third_party/libsrtp/crypto/kernel/crypto_kernel.c \
             src/third_party/libsrtp/crypto/kernel/err.c \
             src/third_party/libsrtp/crypto/kernel/key.c \
             src/third_party/libsrtp/crypto/math/datatypes.c \
             src/third_party/libsrtp/crypto/replay/rdb.c \
             src/third_party/libsrtp/crypto/replay/rdbx.c \
             src/third_party/libsrtp/srtp/srtp.c

CRC32C_SRCS/aarch64=src/third_party/crc32c/src/src/crc32c_arm64.cc
CRC32C_SRCS/x86_64=src/third_party/crc32c/src/src/crc32c_sse42.cc
CRC32C_SRCS/i686=src/third_party/crc32c/src/src/crc32c_sse42.cc

CRC32C_SRCS=src/third_party/crc32c/src/src/crc32c.cc \
            src/third_party/crc32c/src/src/crc32c_portable.cc \
            $(CRC32C_SRCS/$(ARCH))

RNNOISE_SRCS=src/third_party/rnnoise/src/rnn_vad_weights.cc

YUV_OBJS=$(YUV_SRCS:.cc=.o)
LIBSRTP_OBJS=$(LIBSRTP_SRCS:.c=.o)
CRC32C_OBJS=$(CRC32C_SRCS:.cc=.o)
RNNOISE_OBJS=$(RNNOISE_SRCS:.cc=.o)
OBJS=$(C_SRCS:.c=.o) \
     $(CXX_SRCS:.cc=.o) \
     $(YUV_OBJS) \
     $(LIBSRTP_OBJS) \
     $(CRC32C_OBJS) \
     $(RNNOISE_OBJS)

CC=gcc
CXX=g++

ifeq ($(OS),Darwin)
  OBJS+=$(OBJC_SRCS:.mm=.o)
  CC=clang
  CXX=clang++
endif

COMMON_DEFS=-D_FILE_OFFSET_BITS=64 -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS \
            -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_GNU_SOURCE -DGCM -D_FORTIFY_SOURCE=2 \
            -DHAVE_STDLIB_H -DHAVE_STRING_H -DHAVE_STDINT_H -DHAVE_INTTYPES_H -DHAVE_INT16_T \
            -DHAVE_INT32_T -DHAVE_INT8_T -DHAVE_UINT16_T -DHAVE_UINT32_T -DHAVE_UINT64_T \
            -DHAVE_UINT8_T -DHAVE_CONFIG_H \
            -D_LIBCPP_DISABLE_VISIBILITY_ANNOTATIONS -D_LIBCXXABI_DISABLE_VISIBILITY_ANNOTATIONS \
            -D_LIBCPP_ENABLE_ASSERTIONS_DEFAULT=1 \
            -D_LIBCPP_AVAILABILITY_CUSTOM_VERBOSE_ABORT_PROVIDED=1 \
            -DDYNAMIC_ANNOTATIONS_ENABLED=0 -DHAVE_NETINET_IN_H \
            -DNDEBUG -DNVALGRIND -DABSL_ALLOCATOR_NOTHROW=1 -DOPENSSL -DGOOGLE_PROTOBUF_NO_RTTI \
            -DGOOGLE_PROTOBUF_NO_STATIC_INITIALIZER \
            -DGOOGLE_PROTOBUF_INTERNAL_DONATE_STEAL_INLINE=0 -DHAVE_PTHREAD \
            -DUSE_AURA=1 -DUSE_OZONE=1

# TODO: Support QUIC.
WEBRTC_DEFS=-DWEBRTC_ENABLE_PROTOBUF=1 -DWEBRTC_STRICT_FIELD_TRIALS=0 -DRTC_ENABLE_VP9 \
            -DRTC_DAV1D_IN_INTERNAL_DECODER_FACTORY -DWEBRTC_LIBRARY_IMPL \
            -DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=1 -DHAVE_WEBRTC_VIDEO -DHAVE_WEBRTC_VOICE \
            -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE -DWEBRTC_CODEC_ILBC -DWEBRTC_CODEC_OPUS \
            -DWEBRTC_OPUS_SUPPORT_120MS_PTIME=1 -DWEBRTC_USE_BUILTIN_OPUS=1 \
            -DWEBRTC_OPUS_VARIABLE_COMPLEXITY=0 -DWEBRTC_USE_BUILTIN_ILBC \
            -DWEBRTC_CODEC_ISAC -DWEBRTC_USE_BUILTIN_ISAC_FIX -DWEBRTC_HAVE_SCTP \
            -DWEBRTC_APM_DEBUG_DUMP=0 -DWEBRTC_HAVE_DCSCTP

DEFS/Linux=-DWEBRTC_POSIX -DWEBRTC_LINUX -DLINUX -DUSE_UDEV -DWEBRTC_DUMMY_AUDIO_BUILD \
           -DHAVE_ARPA_INET_H -DHAVE_NETINET_IN_H -DHAVE_SYS_TYPES_H -DHAVE_UNISTD_H
DEFS/Darwin=-DWEBRTC_POSIX -DWEBRTC_MAC
DEFS/MinGW=-DWEBRTC_WIN -D_Check_return_= -DUNICODE -D_UNICODE -D_WIN32_WINNT=0x0601
DEFS/armv7l=-DWEBRTC_HAS_NEON -DWEBRTC_NS_FIXED -DWEBRTC_AUDIOPROC_FIXED_PROFILE
DEFS/aarch64=-DWEBRTC_HAS_NEON -DWEBRTC_NS_FIXED -DWEBRTC_AUDIOPROC_FIXED_PROFILE

DEFS=$(COMMON_DEFS) $(WEBRTC_DEFS) $(DEFS/$(OS)) $(DEFS/$(ARCH))

THIRD_PARTY_INCS=-Isrc/third_party/gflags/build/include \
                 -Isrc/third_party/libyuv/include \
                 -Isrc/third_party/libsrtp/include \
                 -Isrc/third_party/libsrtp/config \
                 -Isrc/third_party/libsrtp/crypto/include \
                 -Isrc/third_party/opus/src/celt \
                 -Isrc/third_party/opus/src/include

OWN_INCS=-Isrc \
         -Isrc/testing/gtest/include \
         -Isrc/webrtc \
         -Isrc/common_audio/signal_processing/include \
         -Isrc/modules/audio_coding/codecs/cng/include \
         -Isrc/modules/audio_coding/codecs/isac/main/include \
         -Isrc/modules/audio_coding/codecs/g711/include \
         -Isrc/modules/audio_coding/codecs/g722/include \
         -Isrc/modules/audio_coding/codecs/pcm16b/include \
         -Isrc/modules/audio_coding/codecs/ilbc/interface

INCS/Linux=-Isrc/modules/audio_device/linux \
           -I/usr/include/jsoncpp

INCS/Darwin=-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk \
            -Isrc/modules/audio_device/mac \
            -I/usr/local/opt/openssl/include \
            -I/usr/local/opt/jsoncpp/include/jsoncpp \
            -I/usr/local/include

INCS/MinGW=-Isrc/modules/audio_device/win

INCS=$(THIRD_PARTY_INCS) $(OWN_INCS) $(INCS/$(OS))

COMMON_CFLAGS=-g -O3 --param=ssp-buffer-size=4 -fdata-sections -ffunction-sections -pipe \
              -fdata-sections -ffunction-sections -fno-ident -fno-strict-aliasing -fno-builtin-abs \
              -fno-omit-frame-pointer
CFLAGS/Linux=-pthread -fstack-protector
CFLAGS/Darwin=-mmacosx-version-min=10.7 -pthread -fstack-protector -Wno-c++11-narrowing
CFLAGS/MINGW=
CFLAGS/x86_64=-m64 -msse4.2
CFLAGS/i686=-msse4.2
CFLAGS/armv7l=-mfpu=neon -fPIC
CFLAGS/aarch64=-march=armv8.2-a+crc+crypto -fPIC
CFLAGS=$(COMMON_CFLAGS) $(CFLAGS/$(OS)) $(CFLAGS/$(ARCH))

CXXFLAGS=-std=gnu++17 $(CFLAGS) -fvisibility=hidden -funwind-tables \
         -fvisibility=hidden -fno-exceptions -fno-rtti
ifeq (clang++,$(CXX))
    CXXFLAGS+=-stdlib=libc++
endif

depend: .cdepend .cxxdepend

.cdepend: $(C_SRCS)
	rm -f $@
	for x in $^ ; do \
	    $(CC) $(CFLAGS) $(DEFS) $(INCS) -MM -MT $${x%.c}.o $$x >> $@ ; \
	done

.cxxdepend: $(CXX_SRCS)
	rm -f $@
	for x in $^ ; do \
	    $(CXX) $(CXXFLAGS) $(DEFS) $(INCS) -MM -MT $${x%.cc}.o $$x >> $@ ; \
	done

include .cdepend
include .cxxdepend

%.pb.cc: %.proto
	protoc -I=$(dir $<) --cpp_out=$(dir $<) $<

$(YUV_OBJS): %.o: %.cc
	$(CXX) -c $(COMMON_DEFS) -Isrc/third_party/libyuv/include $(CXXFLAGS) $< -o $@

LIBSRTP_DEFS=-DPACKAGE_STRING='"libsrtp2 2.1.0-pre"' -DPACKAGE_VERSION='"2.1.0-pre"'

$(LIBSRTP_OBJS): %.o: %.c
	$(CC) -c $(CFLAGS) $(COMMON_DEFS) $(LIBSRTP_DEFS) $< -o $@ \
	      -Isrc/third_party/libsrtp -Isrc/third_party/libsrtp/config \
	      -Isrc/third_party/libsrtp/include -Isrc/third_party/libsrtp/crypto/include

CRC32C_DEFS/Linux=-DHAVE_STRONG_GETAUXVAL=1 -DHAVE_WEAK_GETAUXVAL=1
CRC32C_DEFS/x86_64=-DHAVE_MM_PREFETCH=1 -DHAVE_SSE42=1
CRC32C_DEFS/i686=-DHAVE_MM_PREFETCH=1 -DHAVE_SSE42=1
CRC32C_DEFS/aarch64=-DHAVE_ARM64_CRC32C=1
CRC32C_DEFS=$(CRC32C_DEFS/$(OS)) $(CRC32C_DEFS/$(ARCH))

$(CRC32C_OBJS): %.o: %.cc
	$(CC) -c $(CFLAGS) $(COMMON_DEFS) $(CRC32C_DEFS) $< -o $@ \
	      -Isrc/third_party/crc32c/src/include

$(RNNOISE_OBJS): %.o: %.cc
	$(CC) -c $(COMMON_DEFS) -Isrc $(CXXFLAGS) $< -o $@

.c.o:
	$(CC) $(CFLAGS) $(DEFS) $(INCS) -c -o $@ $<

AVX2_OBJS=$(AVX2_SRCS:.cc=.o)
$(AVX2_OBJS): %.o: %.cc
	$(CXX) $(CXXFLAGS) -mavx2 -mfma $(DEFS) $(INCS) -c -o $@ $<

.cc.o:
	$(CXX) $(CXXFLAGS) $(DEFS) $(INCS) -c -o $@ $<

ifeq ($(OS),Darwin)
%.o : %.mm
	$(CXX) $(CXXFLAGS) $(DEFS) $(INCS) -c -o $@ $<
endif

libwebrtc.a: $(OBJS)
ifeq ($(OS),MinGW)
	find src -name "*.o" > objs.txt
	ar rcs $@ @objs.txt
else
	ar rcs $@ $^
endif

define TEST_WEBRTC_CC_SRC
#include <iostream>
#include <api/audio_codecs/builtin_audio_encoder_factory.h>
#include <api/media_stream_interface.h>
#include <api/create_peerconnection_factory.h>
#include <api/video_codecs/video_decoder_factory.h>
#include <api/video_codecs/video_encoder_factory.h>
#include <rtc_base/ssl_adapter.h>
int main(int argc, char** argv) {
    if (!webrtc::InitializeSSL()) {
        std::cerr << "Failed to init SSL." << std::endl;
        return 1;
    }
    auto factory = webrtc::CreatePeerConnectionFactory(
        nullptr, nullptr, nullptr, nullptr,
        webrtc::CreateBuiltinAudioEncoderFactory(),
        nullptr, nullptr, nullptr, nullptr, nullptr);
    webrtc::PeerConnectionInterface::RTCConfiguration config;
    auto result = factory->CreatePeerConnectionOrError(config,
                                                       webrtc::PeerConnectionDependencies(nullptr));
    if (!result.ok()) {
        std::cerr << "Failed to create peer connections" << std::endl;
        return 1;
    }
    auto video_track = factory->CreateVideoTrack("test", nullptr);
    auto stream = factory->CreateLocalMediaStream("test");
    stream->AddTrack(video_track);
    result.MoveValue()->AddStream(stream.get());
    if (!webrtc::CleanupSSL()) {
        std::cerr << "Failed to clean SSL." << std::endl;
        return 1;
    }
    return 0;
}

endef
export TEST_WEBRTC_CC_SRC

test_webrtc.cc:
	echo "$$TEST_WEBRTC_CC_SRC" > $@

test_webrtc: test_webrtc.cc libwebrtc.a
	$(CXX) $(DEFS) $(INCS) $(CXXFLAGS) -Isrc test_webrtc.cc -o $@ \
	   ./libwebrtc.a -Wl,-Bstatic -lprotobuf -lopus -labsl -lssl -lcrypto -Wl,-Bdynamic -ldl

clean:
	rm -f $(OBJS) $(CXX_SRCS/pb) objs.txt libwebrtc.a

install_webrtc_hdrs:
	mkdir -p $(PREFIX)/include/webrtc/api
	install -C src/api/*.h $(PREFIX)/include/webrtc/api

	mkdir -p $(PREFIX)/include/webrtc/api/adaptation
	install -C src/api/adaptation/*.h $(PREFIX)/include/webrtc/api/adaptation

	mkdir -p $(PREFIX)/include/webrtc/api/audio
	install -C src/api/audio/*.h $(PREFIX)/include/webrtc/api/audio

	mkdir -p $(PREFIX)/include/webrtc/api/audio_codecs
	install -C src/api/audio_codecs/*.h $(PREFIX)/include/webrtc/api/audio_codecs

	mkdir -p $(PREFIX)/include/webrtc/api/call
	install -C src/api/call/*.h $(PREFIX)/include/webrtc/api/call

	mkdir -p $(PREFIX)/include/webrtc/api/environment
	install -C src/api/environment/*.h $(PREFIX)/include/webrtc/api/environment

	mkdir -p $(PREFIX)/include/webrtc/api/crypto
	install -C src/api/crypto/*.h $(PREFIX)/include/webrtc/api/crypto

	mkdir -p $(PREFIX)/include/webrtc/api/metronome
	install -C src/api/metronome/*.h $(PREFIX)/include/webrtc/api/metronome

	mkdir -p $(PREFIX)/include/webrtc/api/neteq
	install -C src/api/neteq/*.h $(PREFIX)/include/webrtc/api/neteq

	mkdir -p $(PREFIX)/include/webrtc/api/rtc_event_log
	install -C src/api/rtc_event_log/*.h $(PREFIX)/include/webrtc/api/rtc_event_log

	mkdir -p $(PREFIX)/include/webrtc/api/stats
	install -C src/api/stats/*.h $(PREFIX)/include/webrtc/api/stats

	mkdir -p $(PREFIX)/include/webrtc/api/task_queue
	install -C src/api/task_queue/*.h $(PREFIX)/include/webrtc/api/task_queue

	mkdir -p $(PREFIX)/include/webrtc/api/transport
	install -C src/api/transport/*.h $(PREFIX)/include/webrtc/api/transport

	mkdir -p $(PREFIX)/include/webrtc/api/transport/rtp
	install -C src/api/transport/rtp/*.h $(PREFIX)/include/webrtc/api/transport/rtp

	mkdir -p $(PREFIX)/include/webrtc/api/units
	install -C src/api/units/*.h $(PREFIX)/include/webrtc/api/units

	mkdir -p $(PREFIX)/include/webrtc/api/video
	install -C src/api/video/*.h $(PREFIX)/include/webrtc/api/video

	mkdir -p $(PREFIX)/include/webrtc/api/video_codecs
	install -C src/api/video_codecs/*.h $(PREFIX)/include/webrtc/api/video_codecs

	mkdir -p $(PREFIX)/include/webrtc/call
	install -C src/call/*.h $(PREFIX)/include/webrtc/call

	mkdir -p $(PREFIX)/include/webrtc/common_video
	install -C src/common_video/*.h $(PREFIX)/include/webrtc/common_video

	mkdir -p $(PREFIX)/include/webrtc/common_video/generic_frame_descriptor
	install -C src/common_video/generic_frame_descriptor/*.h \
	           $(PREFIX)/include/webrtc/common_video/generic_frame_descriptor

	mkdir -p $(PREFIX)/include/webrtc/common_video/include
	install -C src/common_video/include/*.h $(PREFIX)/include/webrtc/common_video/include

	mkdir -p $(PREFIX)/include/webrtc/logging/rtc_event_log
	install -C src/logging/rtc_event_log/*.h $(PREFIX)/include/webrtc/logging/rtc_event_log

	mkdir -p $(PREFIX)/include/webrtc/logging/rtc_event_log/encoder
	install -C src/logging/rtc_event_log/encoder/*.h \
	           $(PREFIX)/include/webrtc/logging/rtc_event_log/encoder

	mkdir -p $(PREFIX)/include/webrtc/logging/rtc_event_log/events
	install -C src/logging/rtc_event_log/events/*.h \
	           $(PREFIX)/include/webrtc/logging/rtc_event_log/events

	mkdir -p $(PREFIX)/include/webrtc/media/base
	install -C src/media/base/*.h $(PREFIX)/include/webrtc/media/base

	mkdir -p $(PREFIX)/include/webrtc/media/engine
	install -C src/media/engine/*.h $(PREFIX)/include/webrtc/media/engine

	mkdir -p $(PREFIX)/include/webrtc/modules/async_audio_processing
	install -C src/modules/async_audio_processing/*.h \
	           $(PREFIX)/include/webrtc/modules/async_audio_processing

	mkdir -p $(PREFIX)/include/webrtc/modules/include
	install -C src/modules/include/*.h $(PREFIX)/include/webrtc/modules/include

	mkdir -p $(PREFIX)/include/webrtc/modules/audio_coding/codecs
	install -C src/modules/audio_coding/codecs/*.h \
	           $(PREFIX)/include/webrtc/modules/audio_coding/codecs

	mkdir -p $(PREFIX)/include/webrtc/modules/audio_device/include
	install -C src/modules/audio_device/include/*.h \
	           $(PREFIX)/include/webrtc/modules/audio_device/include

	mkdir -p $(PREFIX)/include/webrtc/modules/audio_processing/include
	install -C src/modules/audio_processing/include/*.h \
	           $(PREFIX)/include/webrtc/modules/audio_processing/include

	mkdir -p $(PREFIX)/include/webrtc/modules/rtp_rtcp/include
	install -C src/modules/rtp_rtcp/include/*.h \
	           $(PREFIX)/include/webrtc/modules/rtp_rtcp/include

	mkdir -p $(PREFIX)/include/webrtc/modules/rtp_rtcp/source
	install -C src/modules/rtp_rtcp/source/*.h \
	           $(PREFIX)/include/webrtc/modules/rtp_rtcp/source

	mkdir -p $(PREFIX)/include/webrtc/modules/rtp_rtcp/source/rtcp_packet
	install -C src/modules/rtp_rtcp/source/rtcp_packet/*.h \
	           $(PREFIX)/include/webrtc/modules/rtp_rtcp/source/rtcp_packet

	mkdir -p $(PREFIX)/include/webrtc/modules/video_coding
	install -C src/modules/video_coding/*.h \
	           $(PREFIX)/include/webrtc/modules/video_coding

	mkdir -p $(PREFIX)/include/webrtc/modules/video_coding/codecs/interface
	install -C src/modules/video_coding/codecs/interface/*.h \
	           $(PREFIX)/include/webrtc/modules/video_coding/codecs/interface

	mkdir -p $(PREFIX)/include/webrtc/modules/video_coding/codecs/h264/include
	install -C src/modules/video_coding/codecs/h264/include/*.h \
	           $(PREFIX)/include/webrtc/modules/video_coding/codecs/h264/include

	mkdir -p $(PREFIX)/include/webrtc/modules/video_coding/codecs/vp8/include
	install -C src/modules/video_coding/codecs/vp8/include/*.h \
	           $(PREFIX)/include/webrtc/modules/video_coding/codecs/vp8/include

	mkdir -p $(PREFIX)/include/webrtc/modules/video_coding/codecs/vp9/include
	install -C src/modules/video_coding/codecs/vp9/include/*.h \
	           $(PREFIX)/include/webrtc/modules/video_coding/codecs/vp9/include

	mkdir -p $(PREFIX)/include/webrtc/modules/video_coding/include
	install -C src/modules/video_coding/include/*.h \
	           $(PREFIX)/include/webrtc/modules/video_coding/include

	mkdir -p $(PREFIX)/include/webrtc/p2p/base
	install -C src/p2p/base/*.h src/p2p/test/turn_server.h src/p2p/test/stun_server.h \
               $(PREFIX)/include/webrtc/p2p/base

	mkdir -p $(PREFIX)/include/webrtc/p2p/client
	install -C src/p2p/client/*.h $(PREFIX)/include/webrtc/p2p/client

	mkdir -p $(PREFIX)/include/webrtc/p2p/dtls
	install -C src/p2p/dtls/*.h $(PREFIX)/include/webrtc/p2p/dtls

	mkdir -p $(PREFIX)/include/webrtc/pc
	install -C src/pc/*.h $(PREFIX)/include/webrtc/pc

	mkdir -p $(PREFIX)/include/webrtc/rtc_base
	install -C src/rtc_base/*.h $(PREFIX)/include/webrtc/rtc_base

	mkdir -p $(PREFIX)/include/webrtc/rtc_base/deprecated
	install -C src/rtc_base/deprecated/*.h $(PREFIX)/include/webrtc/rtc_base/deprecated

	mkdir -p $(PREFIX)/include/webrtc/rtc_base/experiments
	install -C src/rtc_base/experiments/*.h $(PREFIX)/include/webrtc/rtc_base/experiments

	mkdir -p $(PREFIX)/include/webrtc/rtc_base/memory
	install -C src/rtc_base/memory/*.h $(PREFIX)/include/webrtc/rtc_base/memory

	mkdir -p $(PREFIX)/include/webrtc/rtc_base/network
	install -C src/rtc_base/network/*.h $(PREFIX)/include/webrtc/rtc_base/network

	mkdir -p $(PREFIX)/include/webrtc/rtc_base/numerics
	install -C src/rtc_base/numerics/*.h $(PREFIX)/include/webrtc/rtc_base/numerics

	mkdir -p $(PREFIX)/include/webrtc/rtc_base/strings
	install -C src/rtc_base/strings/*.h $(PREFIX)/include/webrtc/rtc_base/strings

	mkdir -p $(PREFIX)/include/webrtc/rtc_base/synchronization
	install -C src/rtc_base/synchronization/*.h $(PREFIX)/include/webrtc/rtc_base/synchronization

	mkdir -p $(PREFIX)/include/webrtc/rtc_base/third_party/sigslot
	install -C src/rtc_base/third_party/sigslot/*.h \
	           $(PREFIX)/include/webrtc/rtc_base/third_party/sigslot

	mkdir -p $(PREFIX)/include/webrtc/rtc_base/system
	install -C src/rtc_base/system/*.h $(PREFIX)/include/webrtc/rtc_base/system

	mkdir -p $(PREFIX)/include/webrtc/rtc_base/units
	install -C src/rtc_base/units/*.h $(PREFIX)/include/webrtc/rtc_base/units

	mkdir -p $(PREFIX)/include/webrtc/system_wrappers/include
	install -C src/system_wrappers/include/*.h \
	           $(PREFIX)/include/webrtc/system_wrappers/include

install: libwebrtc.a install_webrtc_hdrs
	install -C libwebrtc.a $(PREFIX)/lib
