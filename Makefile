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

C_SRCS/x86_64=

C_SRCS/i686=

C_SRCS/armv7l=src/common_audio/signal_processing/cross_correlation_neon.c \
              src/common_audio/signal_processing/downsample_fast_neon.c \
              src/common_audio/signal_processing/min_max_operations_neon.c

C_SRCS=src/common_audio/fft4g.c \
       src/common_audio/ring_buffer.c \
       src/modules/audio_coding/codecs/ilbc/abs_quant.c \
       src/modules/audio_coding/codecs/ilbc/abs_quant_loop.c \
       src/modules/audio_coding/codecs/ilbc/augmented_cb_corr.c \
       src/modules/audio_coding/codecs/ilbc/bw_expand.c \
       src/modules/audio_coding/codecs/ilbc/cb_construct.c \
       src/modules/audio_coding/codecs/ilbc/cb_mem_energy.c \
       src/modules/audio_coding/codecs/ilbc/cb_mem_energy_augmentation.c \
       src/modules/audio_coding/codecs/ilbc/cb_mem_energy_calc.c \
       src/modules/audio_coding/codecs/ilbc/cb_search.c \
       src/modules/audio_coding/codecs/ilbc/cb_search_core.c \
       src/modules/audio_coding/codecs/ilbc/cb_update_best_index.c \
       src/modules/audio_coding/codecs/ilbc/chebyshev.c \
       src/modules/audio_coding/codecs/ilbc/comp_corr.c \
       src/modules/audio_coding/codecs/ilbc/constants.c \
       src/modules/audio_coding/codecs/ilbc/create_augmented_vec.c \
       src/modules/audio_coding/codecs/ilbc/decode.c \
       src/modules/audio_coding/codecs/ilbc/decode_residual.c \
       src/modules/audio_coding/codecs/ilbc/decoder_interpolate_lsf.c \
       src/modules/audio_coding/codecs/ilbc/do_plc.c \
       src/modules/audio_coding/codecs/ilbc/encode.c \
       src/modules/audio_coding/codecs/ilbc/energy_inverse.c \
       src/modules/audio_coding/codecs/ilbc/enh_upsample.c \
       src/modules/audio_coding/codecs/ilbc/enhancer.c \
       src/modules/audio_coding/codecs/ilbc/enhancer_interface.c \
       src/modules/audio_coding/codecs/ilbc/filtered_cb_vecs.c \
       src/modules/audio_coding/codecs/ilbc/frame_classify.c \
       src/modules/audio_coding/codecs/ilbc/gain_dequant.c \
       src/modules/audio_coding/codecs/ilbc/gain_quant.c \
       src/modules/audio_coding/codecs/ilbc/get_cd_vec.c \
       src/modules/audio_coding/codecs/ilbc/get_lsp_poly.c \
       src/modules/audio_coding/codecs/ilbc/get_sync_seq.c \
       src/modules/audio_coding/codecs/ilbc/hp_input.c \
       src/modules/audio_coding/codecs/ilbc/hp_output.c \
       src/modules/audio_coding/codecs/ilbc/ilbc.c \
       src/modules/audio_coding/codecs/ilbc/index_conv_dec.c \
       src/modules/audio_coding/codecs/ilbc/index_conv_enc.c \
       src/modules/audio_coding/codecs/ilbc/init_decode.c \
       src/modules/audio_coding/codecs/ilbc/init_encode.c \
       src/modules/audio_coding/codecs/ilbc/interpolate.c \
       src/modules/audio_coding/codecs/ilbc/interpolate_samples.c \
       src/modules/audio_coding/codecs/ilbc/lpc_encode.c \
       src/modules/audio_coding/codecs/ilbc/lsf_check.c \
       src/modules/audio_coding/codecs/ilbc/lsf_interpolate_to_poly_dec.c \
       src/modules/audio_coding/codecs/ilbc/lsf_interpolate_to_poly_enc.c \
       src/modules/audio_coding/codecs/ilbc/lsf_to_lsp.c \
       src/modules/audio_coding/codecs/ilbc/lsf_to_poly.c \
       src/modules/audio_coding/codecs/ilbc/lsp_to_lsf.c \
       src/modules/audio_coding/codecs/ilbc/my_corr.c \
       src/modules/audio_coding/codecs/ilbc/nearest_neighbor.c \
       src/modules/audio_coding/codecs/ilbc/pack_bits.c \
       src/modules/audio_coding/codecs/ilbc/poly_to_lsf.c \
       src/modules/audio_coding/codecs/ilbc/poly_to_lsp.c \
       src/modules/audio_coding/codecs/ilbc/refiner.c \
       src/modules/audio_coding/codecs/ilbc/simple_interpolate_lsf.c \
       src/modules/audio_coding/codecs/ilbc/simple_lpc_analysis.c \
       src/modules/audio_coding/codecs/ilbc/simple_lsf_dequant.c \
       src/modules/audio_coding/codecs/ilbc/simple_lsf_quant.c \
       src/modules/audio_coding/codecs/ilbc/smooth.c \
       src/modules/audio_coding/codecs/ilbc/smooth_out_data.c \
       src/modules/audio_coding/codecs/ilbc/sort_sq.c \
       src/modules/audio_coding/codecs/ilbc/split_vq.c \
       src/modules/audio_coding/codecs/ilbc/state_construct.c \
       src/modules/audio_coding/codecs/ilbc/state_search.c \
       src/modules/audio_coding/codecs/ilbc/swap_bytes.c \
       src/modules/audio_coding/codecs/ilbc/unpack_bits.c \
       src/modules/audio_coding/codecs/ilbc/vq3.c \
       src/modules/audio_coding/codecs/ilbc/vq4.c \
       src/modules/audio_coding/codecs/ilbc/window32_w32.c \
       src/modules/audio_coding/codecs/ilbc/xcorr_coef.c \
       src/modules/audio_coding/codecs/isac/main/source/arith_routines.c \
       src/modules/audio_coding/codecs/isac/main/source/arith_routines_hist.c \
       src/modules/audio_coding/codecs/isac/main/source/arith_routines_logist.c \
       src/modules/audio_coding/codecs/isac/main/source/bandwidth_estimator.c \
       src/modules/audio_coding/codecs/isac/main/source/crc.c \
       src/modules/audio_coding/codecs/isac/main/source/decode.c \
       src/modules/audio_coding/codecs/isac/main/source/decode_bwe.c \
       src/modules/audio_coding/codecs/isac/main/source/encode.c \
       src/modules/audio_coding/codecs/isac/main/source/encode_lpc_swb.c \
       src/modules/audio_coding/codecs/isac/main/source/entropy_coding.c \
       src/modules/audio_coding/codecs/isac/main/source/fft.c \
       src/modules/audio_coding/codecs/isac/main/source/filter_functions.c \
       src/modules/audio_coding/codecs/isac/main/source/filterbank_tables.c \
       src/modules/audio_coding/codecs/isac/main/source/intialize.c \
       src/modules/audio_coding/codecs/isac/main/source/isac.c \
       src/modules/audio_coding/codecs/isac/main/source/filterbanks.c \
       src/modules/audio_coding/codecs/isac/main/source/pitch_lag_tables.c \
       src/modules/audio_coding/codecs/isac/main/source/lattice.c \
       src/modules/audio_coding/codecs/isac/main/source/lpc_gain_swb_tables.c \
       src/modules/audio_coding/codecs/isac/main/source/lpc_analysis.c \
       src/modules/audio_coding/codecs/isac/main/source/lpc_shape_swb12_tables.c \
       src/modules/audio_coding/codecs/isac/main/source/lpc_shape_swb16_tables.c \
       src/modules/audio_coding/codecs/isac/main/source/lpc_tables.c \
       src/modules/audio_coding/codecs/isac/main/source/pitch_estimator.c \
       src/modules/audio_coding/codecs/isac/main/source/pitch_filter.c \
       src/modules/audio_coding/codecs/isac/main/source/pitch_gain_tables.c \
       src/modules/audio_coding/codecs/isac/main/source/spectrum_ar_model_tables.c \
       src/modules/audio_coding/codecs/isac/main/source/transform.c \
       src/modules/audio_coding/codecs/g711/g711.c \
       src/modules/audio_coding/codecs/g711/g711_interface.c \
       src/modules/audio_coding/codecs/g722/g722_decode.c \
       src/modules/audio_coding/codecs/g722/g722_encode.c \
       src/modules/audio_coding/codecs/g722/g722_interface.c \
       src/modules/audio_coding/codecs/opus/opus_interface.c \
       src/modules/audio_coding/codecs/pcm16b/pcm16b.c \
       src/modules/audio_processing/agc/legacy/analog_agc.c \
       src/modules/audio_processing/agc/legacy/digital_agc.c \
       src/modules/audio_processing/ns/noise_suppression.c \
       src/modules/audio_processing/ns/ns_core.c \
       src/common_audio/signal_processing/auto_corr_to_refl_coef.c \
       src/common_audio/signal_processing/auto_correlation.c \
       src/common_audio/signal_processing/complex_fft.c \
       src/common_audio/signal_processing/complex_bit_reverse.c \
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
       src/common_audio/signal_processing/ilbc_specific_functions.c \
       src/common_audio/signal_processing/levinson_durbin.c \
       src/common_audio/signal_processing/lpc_to_refl_coef.c \
       src/common_audio/signal_processing/min_max_operations.c \
       src/common_audio/signal_processing/randomization_functions.c \
       src/common_audio/signal_processing/refl_coef_to_lpc.c \
       src/common_audio/signal_processing/real_fft.c \
       src/common_audio/signal_processing/resample.c \
       src/common_audio/signal_processing/resample_48khz.c \
       src/common_audio/signal_processing/resample_by_2.c \
       src/common_audio/signal_processing/resample_by_2_internal.c \
       src/common_audio/signal_processing/resample_fractional.c \
       src/common_audio/signal_processing/spl_init.c \
       src/common_audio/signal_processing/spl_sqrt.c \
       src/common_audio/signal_processing/spl_sqrt_floor.c \
       src/common_audio/signal_processing/splitting_filter.c \
       src/common_audio/signal_processing/sqrt_of_one_minus_x_squared.c \
       src/common_audio/signal_processing/vector_scaling_operations.c \
       src/common_audio/vad/webrtc_vad.c \
       src/common_audio/vad/vad_core.c \
       src/common_audio/vad/vad_filterbank.c \
       src/common_audio/vad/vad_gmm.c \
       src/common_audio/vad/vad_sp.c \
       $(C_SRCS/$(ARCH))


CXX_SRCS/Linux=src/rtc_base/file_posix.cc \
               src/rtc_base/ifaddrs_converter.cc \
               src/rtc_base/task_queue_posix.cc \
               src/rtc_base/unixfilesystem.cc \
               src/modules/video_capture/linux/device_info_linux.cc \
               src/modules/video_capture/linux/video_capture_linux.cc \
               src/system_wrappers/source/atomic32_non_darwin_unix.cc \
               src/system_wrappers/source/event_timer_posix.cc \
               src/system_wrappers/source/rw_lock_posix.cc \

CXX_SRCS/MinGW=src/rtc_base/file_win.cc \
               src/rtc_base/task_queue_win.cc \
               src/rtc_base/win32.cc \
               src/rtc_base/win32securityerrors.cc \
               src/rtc_base/win32filesystem.cc \
               src/rtc_base/win32socketinit.cc \
               src/rtc_base/win32window.cc \
               src/rtc_base/win32windowpicker.cc \
               src/rtc_base/winping.cc \
               src/modules/video_capture/windows/device_info_mf.cc \
               src/modules/video_capture/windows/video_capture_mf.cc \
               src/modules/video_capture/windows/video_capture_factory_windows.cc \
               src/system_wrappers/source/atomic32_win.cc \
               src/system_wrappers/source/condition_variable_event_win.cc \
               src/system_wrappers/source/event_timer_win.cc \
               src/system_wrappers/source/rw_lock_win.cc \
               src/system_wrappers/source/trace_win.cc

CXX_SRCS/Darwin=src/rtc_base/ifaddrs_converter.cc \
                src/rtc_base/macutils.cc \
                src/rtc_base/macwindowpicker.cc \
                src/rtc_base/posix.cc \
                src/rtc_base/task_queue_gcd.cc \
                src/rtc_base/unixfilesystem.cc \
                src/system_wrappers/source/atomic32_mac.cc \
                src/system_wrappers/source/critical_section_posix.cc \
                src/system_wrappers/source/condition_variable_posix.cc \
                src/system_wrappers/source/event_timer_posix.cc \
                src/system_wrappers/source/rw_lock_posix.cc \
                src/system_wrappers/source/thread_posix.cc \
                src/system_wrappers/source/trace_posix.cc

OBJC_SRCS=src/rtc_base/maccocoathreadhelper.mm \
          src/rtc_base/scoped_autorelease_pool.mm \
          src/modules/video_capture/mac/video_capture_mac.mm \
          src/modules/video_capture/mac/qtkit/video_capture_qtkit.mm \
          src/modules/video_capture/mac/qtkit/video_capture_qtkit_info.mm \
          src/modules/video_capture/mac/qtkit/video_capture_qtkit_info_objc.mm \
          src/modules/video_capture/mac/qtkit/video_capture_qtkit_objc.mm

CXX_SRCS/x86_64=src/common_audio/fir_filter_sse.cc \
                src/common_audio/resampler/sinc_resampler_sse.cc \
                src/modules/audio_processing/aec/aec_core_sse2.cc \
                src/modules/video_processing/util/denoiser_filter_sse2.cc \
                src/modules/audio_processing/utility/ooura_fft_sse2.cc

CXX_SRCS/i686=src/common_audio/fir_filter_sse.cc \
              src/common_audio/resampler/sinc_resampler_sse.cc \
              src/modules/audio_processing/aec/aec_core_sse2.cc \
              src/modules/audio_processing/aec/aec_rdft_sse2.cc \
              src/modules/video_processing/util/denoiser_filter_sse2.cc \
              src/modules/audio_processing/utility/ooura_fft_sse2.cc

CXX_SRCS/armv7l=src/common_audio/fir_filter_neon.cc \
                src/common_audio/resampler/sinc_resampler_neon.cc \
                src/modules/audio_processing/aec/aec_core_neon.cc \
                src/modules/audio_processing/aec/aec_rdft_neon.cc \
                src/modules/audio_processing/aecm/aecm_core_neon.cc \
                src/modules/video_processing/util/denoiser_filter_neon.cc \
                src/modules/audio_processing/utility/ooura_fft_neon.cc

CXX_SRCS=src/api/audio_codecs/audio_decoder.cc \
         src/api/audio_codecs/audio_encoder.cc \
         src/api/audio_codecs/audio_format.cc \
         src/api/audio_codecs/builtin_audio_decoder_factory.cc \
         src/api/audio_codecs/builtin_audio_encoder_factory.cc \
         src/api/audio_codecs/g711/audio_decoder_g711.cc \
         src/api/audio_codecs/g711/audio_encoder_g711.cc \
         src/api/audio_codecs/L16/audio_decoder_L16.cc \
         src/api/audio_codecs/L16/audio_encoder_L16.cc \
         src/api/audio_codecs/opus/audio_encoder_opus_config.cc \
         src/api/mediaconstraintsinterface.cc \
         src/api/mediastreaminterface.cc \
         src/api/mediatypes.cc \
         src/api/rtcerror.cc \
         src/api/rtpparameters.cc \
         src/api/statstypes.cc \
         src/api/video/i420_buffer.cc \
         src/api/video/video_content_type.cc \
         src/api/video/video_frame.cc \
         src/api/video/video_frame_buffer.cc \
         src/api/video/video_timing.cc \
         src/api/video_codecs/video_encoder.cc \
         src/audio/audio_receive_stream.cc \
         src/audio/audio_send_stream.cc \
         src/audio/audio_state.cc \
         src/audio/audio_transport_proxy.cc \
         src/audio/time_interval.cc \
         src/audio/utility/audio_frame_operations.cc \
         src/call/audio_send_stream.cc \
         src/call/bitrate_allocator.cc \
         src/call/call.cc \
         src/call/callfactory.cc \
         src/call/flexfec_receive_stream_impl.cc \
         src/call/rtp_config.cc \
         src/call/rtp_demuxer.cc \
         src/call/rtp_stream_receiver_controller.cc \
         src/call/rtx_receive_stream.cc \
         src/call/rtp_transport_controller_send.cc \
         src/call/syncable.cc \
         src/call/video_config.cc \
         src/call/video_receive_stream.cc \
         src/call/video_send_stream.cc \
         src/common_audio/audio_converter.cc \
         src/common_audio/audio_ring_buffer.cc \
         src/common_audio/audio_util.cc \
         src/common_audio/blocker.cc \
         src/common_audio/channel_buffer.cc \
         src/common_audio/fir_filter.cc \
         src/common_audio/lapped_transform.cc \
         src/common_audio/real_fourier.cc \
         src/common_audio/real_fourier_ooura.cc \
         src/common_audio/resampler/push_resampler.cc \
         src/common_audio/resampler/push_sinc_resampler.cc \
         src/common_audio/resampler/resampler.cc \
         src/common_audio/resampler/sinc_resampler.cc \
         src/common_audio/signal_processing/dot_product_with_scale.cc \
         src/common_audio/smoothing_filter.cc \
         src/common_audio/sparse_fir_filter.cc \
         src/common_audio/vad/vad.cc \
         src/common_audio/wav_header.cc \
         src/common_audio/wav_file.cc \
         src/common_audio/window_generator.cc \
         src/common_types.cc \
         src/common_video/h264/h264_common.cc \
         src/common_video/h264/pps_parser.cc \
         src/common_video/h264/sps_parser.cc \
         src/common_video/h264/sps_vui_rewriter.cc \
         src/common_video/i420_buffer_pool.cc \
         src/common_video/incoming_video_stream.cc \
         src/common_video/libyuv/webrtc_libyuv.cc \
         src/common_video/video_frame.cc \
         src/common_video/video_frame_buffer.cc \
         src/common_video/video_render_frames.cc \
         src/media/base/codec.cc \
         src/media/base/h264_profile_level_id.cc \
         src/media/base/mediaconstants.cc \
         src/media/base/mediaengine.cc \
         src/media/base/rtpdataengine.cc \
         src/media/base/rtputils.cc \
         src/media/base/streamparams.cc \
         src/media/base/turnutils.cc \
         src/media/base/videoadapter.cc \
         src/media/base/videobroadcaster.cc \
         src/media/base/videocapturer.cc \
         src/media/base/videocommon.cc \
         src/media/base/videosourcebase.cc \
         src/media/base/videosourceinterface.cc \
         src/media/engine/adm_helpers.cc \
         src/media/engine/apm_helpers.cc \
         src/media/engine/payload_type_mapper.cc \
         src/media/engine/scopedvideodecoder.cc \
         src/media/engine/scopedvideoencoder.cc \
         src/media/engine/simulcast.cc \
         src/media/engine/webrtcmediaengine.cc \
         src/media/engine/webrtcmediaengine.cc \
         src/media/engine/webrtcvideocapturer.cc \
         src/media/engine/webrtcvideocapturerfactory.cc \
         src/media/engine/webrtcvideoencoderfactory.cc \
         src/media/engine/webrtcvideoengine.cc \
         src/media/engine/webrtcvoiceengine.cc \
         src/media/sctp/sctptransport.cc \
         src/modules/audio_coding/acm2/acm_codec_database.cc \
         src/modules/audio_coding/acm2/acm_receiver.cc \
         src/modules/audio_coding/acm2/acm_resampler.cc \
         src/modules/audio_coding/acm2/audio_coding_module.cc \
         src/modules/audio_coding/acm2/call_statistics.cc \
         src/modules/audio_coding/acm2/codec_manager.cc \
         src/modules/audio_coding/acm2/rent_a_codec.cc \
         src/modules/audio_coding/audio_network_adaptor/audio_network_adaptor_config.cc \
         src/modules/audio_coding/audio_network_adaptor/audio_network_adaptor_impl.cc \
         src/modules/audio_coding/audio_network_adaptor/bitrate_controller.cc \
         src/modules/audio_coding/audio_network_adaptor/channel_controller.cc \
         src/modules/audio_coding/audio_network_adaptor/controller.cc \
         src/modules/audio_coding/audio_network_adaptor/controller_manager.cc \
         src/modules/audio_coding/audio_network_adaptor/debug_dump_writer.cc \
         src/modules/audio_coding/audio_network_adaptor/dtx_controller.cc \
         src/modules/audio_coding/audio_network_adaptor/event_log_writer.cc \
         src/modules/audio_coding/audio_network_adaptor/frame_length_controller.cc \
         src/modules/audio_coding/codecs/audio_format_conversion.cc \
         src/modules/audio_coding/codecs/cng/audio_encoder_cng.cc \
         src/modules/audio_coding/codecs/cng/webrtc_cng.cc \
         src/modules/audio_coding/codecs/g711/audio_decoder_pcm.cc \
         src/modules/audio_coding/codecs/g711/audio_encoder_pcm.cc \
         src/modules/audio_coding/codecs/g722/audio_encoder_g722.cc \
         src/modules/audio_coding/codecs/ilbc/audio_encoder_ilbc.cc \
         src/modules/audio_coding/codecs/isac/locked_bandwidth_info.cc \
         src/modules/audio_coding/codecs/isac/main/source/audio_decoder_isac.cc \
         src/modules/audio_coding/codecs/isac/main/source/audio_encoder_isac.cc \
         src/modules/audio_coding/codecs/legacy_encoded_audio_frame.cc \
         src/modules/audio_coding/codecs/opus/audio_decoder_opus.cc \
         src/modules/audio_coding/codecs/opus/audio_encoder_opus.cc \
         src/modules/audio_coding/codecs/pcm16b/audio_decoder_pcm16b.cc \
         src/modules/audio_coding/codecs/pcm16b/audio_encoder_pcm16b.cc \
         src/modules/audio_coding/codecs/pcm16b/pcm16b_common.cc \
         src/modules/audio_coding/codecs/red/audio_encoder_copy_red.cc \
         src/modules/audio_coding/neteq/accelerate.cc \
         src/modules/audio_coding/neteq/audio_decoder_impl.cc \
         src/modules/audio_coding/neteq/audio_multi_vector.cc \
         src/modules/audio_coding/neteq/audio_vector.cc \
         src/modules/audio_coding/neteq/background_noise.cc \
         src/modules/audio_coding/neteq/buffer_level_filter.cc \
         src/modules/audio_coding/neteq/comfort_noise.cc \
         src/modules/audio_coding/neteq/cross_correlation.cc \
         src/modules/audio_coding/neteq/decision_logic.cc \
         src/modules/audio_coding/neteq/decision_logic_fax.cc \
         src/modules/audio_coding/neteq/decision_logic_normal.cc \
         src/modules/audio_coding/neteq/decoder_database.cc \
         src/modules/audio_coding/neteq/delay_manager.cc \
         src/modules/audio_coding/neteq/delay_peak_detector.cc \
         src/modules/audio_coding/neteq/dsp_helper.cc \
         src/modules/audio_coding/neteq/dtmf_buffer.cc \
         src/modules/audio_coding/neteq/dtmf_tone_generator.cc \
         src/modules/audio_coding/neteq/expand.cc \
         src/modules/audio_coding/neteq/merge.cc \
         src/modules/audio_coding/neteq/nack_tracker.cc \
         src/modules/audio_coding/neteq/neteq_decoder_enum.cc \
         src/modules/audio_coding/neteq/neteq_impl.cc \
         src/modules/audio_coding/neteq/neteq.cc \
         src/modules/audio_coding/neteq/normal.cc \
         src/modules/audio_coding/neteq/packet.cc \
         src/modules/audio_coding/neteq/packet_buffer.cc \
         src/modules/audio_coding/neteq/post_decode_vad.cc \
         src/modules/audio_coding/neteq/preemptive_expand.cc \
         src/modules/audio_coding/neteq/random_vector.cc \
         src/modules/audio_coding/neteq/red_payload_splitter.cc \
         src/modules/audio_coding/neteq/rtcp.cc \
         src/modules/audio_coding/neteq/statistics_calculator.cc \
         src/modules/audio_coding/neteq/sync_buffer.cc \
         src/modules/audio_coding/neteq/tick_timer.cc \
         src/modules/audio_coding/neteq/timestamp_scaler.cc \
         src/modules/audio_coding/neteq/time_stretch.cc \
         src/modules/audio_device/audio_device_buffer.cc \
         src/modules/audio_device/audio_device_generic.cc \
         src/modules/audio_device/audio_device_impl.cc \
         src/modules/audio_device/dummy/audio_device_dummy.cc \
         src/modules/audio_mixer/audio_frame_manipulator.cc \
         src/modules/audio_mixer/audio_mixer_impl.cc \
         src/modules/audio_mixer/default_output_rate_calculator.cc \
         src/modules/audio_mixer/frame_combiner.cc \
         src/modules/audio_processing/aec/aec_core.cc \
         src/modules/audio_processing/aec/aec_resampler.cc \
         src/modules/audio_processing/aec/echo_cancellation.cc \
         src/modules/audio_processing/aec3/adaptive_fir_filter.cc \
         src/modules/audio_processing/aec3/aec3_common.cc \
         src/modules/audio_processing/aec3/aec3_fft.cc \
         src/modules/audio_processing/aec3/aec_state.cc \
         src/modules/audio_processing/aec3/block_framer.cc \
         src/modules/audio_processing/aec3/block_processor.cc \
         src/modules/audio_processing/aec3/block_processor_metrics.cc \
         src/modules/audio_processing/aec3/cascaded_biquad_filter.cc \
         src/modules/audio_processing/aec3/comfort_noise_generator.cc \
         src/modules/audio_processing/aec3/decimator_by_4.cc \
         src/modules/audio_processing/aec3/downsampled_render_buffer.cc \
         src/modules/audio_processing/aec3/echo_canceller3.cc \
         src/modules/audio_processing/aec3/echo_path_delay_estimator.cc \
         src/modules/audio_processing/aec3/echo_path_variability.cc \
         src/modules/audio_processing/aec3/echo_remover.cc \
         src/modules/audio_processing/aec3/echo_remover_metrics.cc \
         src/modules/audio_processing/aec3/erle_estimator.cc \
         src/modules/audio_processing/aec3/erl_estimator.cc \
         src/modules/audio_processing/aec3/frame_blocker.cc \
         src/modules/audio_processing/aec3/main_filter_update_gain.cc \
         src/modules/audio_processing/aec3/matched_filter.cc \
         src/modules/audio_processing/aec3/matched_filter_lag_aggregator.cc \
         src/modules/audio_processing/aec3/output_selector.cc \
         src/modules/audio_processing/aec3/render_buffer.cc \
         src/modules/audio_processing/aec3/render_delay_buffer.cc \
         src/modules/audio_processing/aec3/render_delay_controller.cc \
         src/modules/audio_processing/aec3/render_delay_controller_metrics.cc \
         src/modules/audio_processing/aec3/render_signal_analyzer.cc \
         src/modules/audio_processing/aec3/residual_echo_estimator.cc \
         src/modules/audio_processing/aec3/shadow_filter_update_gain.cc \
         src/modules/audio_processing/aec3/subtractor.cc \
         src/modules/audio_processing/aec3/suppression_filter.cc \
         src/modules/audio_processing/aec3/suppression_gain.cc \
         src/modules/audio_processing/aecm/aecm_core.cc \
         src/modules/audio_processing/aecm/aecm_core_c.cc \
         src/modules/audio_processing/aecm/echo_control_mobile.cc \
         src/modules/audio_processing/agc/agc.cc \
         src/modules/audio_processing/agc/agc_manager_direct.cc \
         src/modules/audio_processing/agc/loudness_histogram.cc \
         src/modules/audio_processing/agc/utility.cc \
         src/modules/audio_processing/agc2/digital_gain_applier.cc \
         src/modules/audio_processing/agc2/gain_controller2.cc \
         src/modules/audio_processing/audio_buffer.cc \
         src/modules/audio_processing/audio_processing_impl.cc \
         src/modules/audio_processing/beamformer/array_util.cc \
         src/modules/audio_processing/beamformer/covariance_matrix_generator.cc \
         src/modules/audio_processing/beamformer/nonlinear_beamformer.cc \
         src/modules/audio_processing/echo_cancellation_impl.cc \
         src/modules/audio_processing/echo_control_mobile_impl.cc \
         src/modules/audio_processing/echo_detector/circular_buffer.cc \
         src/modules/audio_processing/echo_detector/mean_variance_estimator.cc \
         src/modules/audio_processing/echo_detector/moving_max.cc \
         src/modules/audio_processing/echo_detector/normalized_covariance_estimator.cc \
         src/modules/audio_processing/gain_control_for_experimental_agc.cc \
         src/modules/audio_processing/gain_control_impl.cc \
         src/modules/audio_processing/include/aec_dump.cc \
         src/modules/audio_processing/include/audio_processing.cc \
         src/modules/audio_processing/include/config.cc \
         src/modules/audio_processing/intelligibility/intelligibility_enhancer.cc \
         src/modules/audio_processing/intelligibility/intelligibility_utils.cc \
         src/modules/audio_processing/level_controller/biquad_filter.cc \
         src/modules/audio_processing/level_controller/down_sampler.cc \
         src/modules/audio_processing/level_controller/gain_applier.cc \
         src/modules/audio_processing/level_controller/gain_selector.cc \
         src/modules/audio_processing/level_controller/level_controller.cc \
         src/modules/audio_processing/level_controller/noise_level_estimator.cc \
         src/modules/audio_processing/level_controller/noise_spectrum_estimator.cc \
         src/modules/audio_processing/level_controller/peak_level_estimator.cc \
         src/modules/audio_processing/level_controller/saturating_gain_estimator.cc \
         src/modules/audio_processing/level_controller/signal_classifier.cc \
         src/modules/audio_processing/level_estimator_impl.cc \
         src/modules/audio_processing/logging/apm_data_dumper.cc \
         src/modules/audio_processing/low_cut_filter.cc \
         src/modules/audio_processing/noise_suppression_impl.cc \
         src/modules/audio_processing/residual_echo_detector.cc \
         src/modules/audio_processing/rms_level.cc \
         src/modules/audio_processing/splitting_filter.cc \
         src/modules/audio_processing/three_band_filter_bank.cc \
         src/modules/audio_processing/transient/moving_moments.cc \
         src/modules/audio_processing/transient/transient_detector.cc \
         src/modules/audio_processing/transient/transient_suppressor.cc \
         src/modules/audio_processing/transient/wpd_node.cc \
         src/modules/audio_processing/transient/wpd_tree.cc \
         src/modules/audio_processing/typing_detection.cc \
         src/modules/audio_processing/vad/gmm.cc \
         src/modules/audio_processing/utility/block_mean_calculator.cc \
         src/modules/audio_processing/utility/delay_estimator.cc \
         src/modules/audio_processing/utility/delay_estimator_wrapper.cc \
         src/modules/audio_processing/utility/ooura_fft.cc \
         src/modules/audio_processing/vad/pitch_based_vad.cc \
         src/modules/audio_processing/vad/pitch_internal.cc \
         src/modules/audio_processing/vad/pole_zero_filter.cc \
         src/modules/audio_processing/vad/standalone_vad.cc \
         src/modules/audio_processing/vad/vad_audio_proc.cc \
         src/modules/audio_processing/vad/vad_circular_buffer.cc \
         src/modules/audio_processing/vad/voice_activity_detector.cc \
         src/modules/audio_processing/voice_detection_impl.cc \
         src/modules/bitrate_controller/bitrate_controller_impl.cc \
         src/modules/bitrate_controller/send_side_bandwidth_estimation.cc \
         src/modules/congestion_controller/acknowledged_bitrate_estimator.cc \
         src/modules/congestion_controller/bitrate_estimator.cc \
         src/modules/congestion_controller/delay_based_bwe.cc \
         src/modules/congestion_controller/median_slope_estimator.cc \
         src/modules/congestion_controller/probe_bitrate_estimator.cc \
         src/modules/congestion_controller/probe_controller.cc \
         src/modules/congestion_controller/receive_side_congestion_controller.cc \
         src/modules/congestion_controller/send_side_congestion_controller.cc \
         src/modules/congestion_controller/transport_feedback_adapter.cc \
         src/modules/congestion_controller/trendline_estimator.cc \
         src/modules/media_file/media_file_impl.cc \
         src/modules/media_file/media_file_utility.cc \
         src/modules/pacing/alr_detector.cc \
         src/modules/pacing/bitrate_prober.cc \
         src/modules/pacing/interval_budget.cc \
         src/modules/pacing/paced_sender.cc \
         src/modules/pacing/packet_queue.cc \
         src/modules/pacing/packet_queue2.cc \
         src/modules/pacing/packet_router.cc \
         src/modules/remote_bitrate_estimator/aimd_rate_control.cc \
         src/modules/remote_bitrate_estimator/bwe_defines.cc \
         src/modules/remote_bitrate_estimator/bwe_simulations.cc \
         src/modules/remote_bitrate_estimator/inter_arrival.cc \
         src/modules/remote_bitrate_estimator/overuse_detector.cc \
         src/modules/remote_bitrate_estimator/overuse_estimator.cc \
         src/modules/remote_bitrate_estimator/remote_bitrate_estimator_abs_send_time.cc \
         src/modules/remote_bitrate_estimator/remote_bitrate_estimator_single_stream.cc \
         src/modules/remote_bitrate_estimator/remote_estimator_proxy.cc \
         src/modules/remote_bitrate_estimator/send_time_history.cc \
         src/modules/rtp_rtcp/include/rtp_rtcp_defines.cc \
         src/modules/rtp_rtcp/source/dtmf_queue.cc \
         src/modules/rtp_rtcp/source/flexfec_header_reader_writer.cc \
         src/modules/rtp_rtcp/source/flexfec_receiver.cc \
         src/modules/rtp_rtcp/source/flexfec_sender.cc \
         src/modules/rtp_rtcp/source/forward_error_correction.cc \
         src/modules/rtp_rtcp/source/forward_error_correction_internal.cc \
         src/modules/rtp_rtcp/source/packet_loss_stats.cc \
         src/modules/rtp_rtcp/source/playout_delay_oracle.cc \
         src/modules/rtp_rtcp/source/receive_statistics_impl.cc \
         src/modules/rtp_rtcp/source/remote_ntp_time_estimator.cc \
         src/modules/rtp_rtcp/source/rtcp_nack_stats.cc \
         src/modules/rtp_rtcp/source/rtcp_packet.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/app.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/bye.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/common_header.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/compound_packet.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/dlrr.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/extended_jitter_report.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/extended_reports.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/fir.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/nack.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/pli.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/psfb.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/rapid_resync_request.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/receiver_report.cc \
         src/modules/rtp_rtcp/source/rtcp_packet/remb.cc \
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
         src/modules/rtp_rtcp/source/rtcp_packet/voip_metric.cc \
         src/modules/rtp_rtcp/source/rtcp_receiver.cc \
         src/modules/rtp_rtcp/source/rtcp_sender.cc \
         src/modules/rtp_rtcp/source/rtp_format.cc \
         src/modules/rtp_rtcp/source/rtp_format_h264.cc \
         src/modules/rtp_rtcp/source/rtp_format_vp8.cc \
         src/modules/rtp_rtcp/source/rtp_format_vp9.cc \
         src/modules/rtp_rtcp/source/rtp_format_video_generic.cc \
         src/modules/rtp_rtcp/source/rtp_header_extensions.cc \
         src/modules/rtp_rtcp/source/rtp_header_extension_map.cc \
         src/modules/rtp_rtcp/source/rtp_header_parser.cc \
         src/modules/rtp_rtcp/source/rtp_packet.cc \
         src/modules/rtp_rtcp/source/rtp_packet_history.cc \
         src/modules/rtp_rtcp/source/rtp_packet_received.cc \
         src/modules/rtp_rtcp/source/rtp_payload_registry.cc \
         src/modules/rtp_rtcp/source/rtp_receiver_audio.cc \
         src/modules/rtp_rtcp/source/rtp_receiver_impl.cc \
         src/modules/rtp_rtcp/source/rtp_receiver_strategy.cc \
         src/modules/rtp_rtcp/source/rtp_receiver_video.cc \
         src/modules/rtp_rtcp/source/rtp_rtcp_impl.cc \
         src/modules/rtp_rtcp/source/rtp_sender.cc \
         src/modules/rtp_rtcp/source/rtp_sender_audio.cc \
         src/modules/rtp_rtcp/source/rtp_sender_video.cc \
         src/modules/rtp_rtcp/source/rtp_utility.cc \
         src/modules/rtp_rtcp/source/time_util.cc \
         src/modules/rtp_rtcp/source/tmmbr_help.cc \
         src/modules/rtp_rtcp/source/ulpfec_generator.cc \
         src/modules/rtp_rtcp/source/ulpfec_header_reader_writer.cc \
         src/modules/rtp_rtcp/source/ulpfec_receiver_impl.cc \
         src/modules/video_capture/device_info_impl.cc \
         src/modules/video_capture/video_capture_factory.cc \
         src/modules/video_capture/video_capture_impl.cc \
         src/modules/video_coding/codec_database.cc \
         src/modules/video_coding/codec_timer.cc \
         src/modules/video_coding/decoding_state.cc \
         src/modules/video_coding/encoded_frame.cc \
         src/modules/video_coding/frame_buffer.cc \
         src/modules/video_coding/frame_buffer2.cc \
         src/modules/video_coding/frame_object.cc \
         src/modules/video_coding/generic_decoder.cc \
         src/modules/video_coding/generic_encoder.cc \
         src/modules/video_coding/h264_sprop_parameter_sets.cc \
         src/modules/video_coding/h264_sps_pps_tracker.cc \
         src/modules/video_coding/histogram.cc \
         src/modules/video_coding/inter_frame_delay.cc \
         src/modules/video_coding/jitter_buffer.cc \
         src/modules/video_coding/jitter_estimator.cc \
         src/modules/video_coding/media_opt_util.cc \
         src/modules/video_coding/media_optimization.cc \
         src/modules/video_coding/nack_module.cc \
         src/modules/video_coding/packet.cc \
         src/modules/video_coding/packet_buffer.cc \
         src/modules/video_coding/protection_bitrate_calculator.cc \
         src/modules/video_coding/qp_parser.cc \
         src/modules/video_coding/receiver.cc \
         src/modules/video_coding/rtp_frame_reference_finder.cc \
         src/modules/video_coding/rtt_filter.cc \
         src/modules/video_coding/session_info.cc \
         src/modules/video_coding/timestamp_map.cc \
         src/modules/video_coding/timing.cc \
         src/modules/video_coding/utility/default_video_bitrate_allocator.cc \
         src/modules/video_coding/utility/frame_dropper.cc \
         src/modules/video_coding/utility/ivf_file_writer.cc \
         src/modules/video_coding/utility/moving_average.cc \
         src/modules/video_coding/utility/quality_scaler.cc \
         src/modules/video_coding/utility/vp8_header_parser.cc \
         src/modules/video_coding/utility/vp9_uncompressed_header_parser.cc \
         src/modules/video_coding/video_codec_initializer.cc \
         src/modules/video_coding/video_coding_impl.cc \
         src/modules/video_coding/video_sender.cc \
         src/modules/video_coding/video_receiver.cc \
         src/modules/video_coding/codecs/vp8/default_temporal_layers.cc \
         src/modules/video_coding/codecs/vp8/screenshare_layers.cc \
         src/modules/video_coding/codecs/vp8/simulcast_rate_allocator.cc \
         src/modules/video_coding/codecs/vp8/temporal_layers.cc \
         src/modules/video_processing/util/denoiser_filter.cc \
         src/modules/video_processing/util/denoiser_filter_c.cc \
         src/modules/video_processing/util/noise_estimation.cc \
         src/modules/video_processing/util/skin_detection.cc \
         src/modules/video_processing/video_denoiser.cc \
         src/modules/utility/source/process_thread_impl.cc \
         src/p2p/base/asyncstuntcpsocket.cc \
         src/p2p/base/basicpacketsocketfactory.cc \
         src/p2p/base/dtlstransport.cc \
         src/p2p/base/jseptransport.cc \
         src/p2p/base/p2pconstants.cc \
         src/p2p/base/p2ptransportchannel.cc \
         src/p2p/base/packetlossestimator.cc \
         src/p2p/base/port.cc \
         src/p2p/base/portallocator.cc \
         src/p2p/base/pseudotcp.cc \
         src/p2p/base/relayport.cc \
         src/p2p/base/relayserver.cc \
         src/p2p/base/session.cc \
         src/p2p/base/sessiondescription.cc \
         src/p2p/base/stun.cc \
         src/p2p/base/stunport.cc \
         src/p2p/base/stunrequest.cc \
         src/p2p/base/stunserver.cc \
         src/p2p/base/tcpport.cc \
         src/p2p/base/transportdescription.cc \
         src/p2p/base/transportdescriptionfactory.cc \
         src/p2p/base/turnport.cc \
         src/p2p/base/turnserver.cc \
         src/p2p/client/basicportallocator.cc \
         src/p2p/client/socketmonitor.cc \
         src/pc/audiomonitor.cc \
         src/pc/audiotrack.cc \
         src/pc/bundlefilter.cc \
         src/pc/channel.cc \
         src/pc/channelmanager.cc \
         src/pc/createpeerconnectionfactory.cc \
         src/pc/currentspeakermonitor.cc \
         src/pc/datachannel.cc \
         src/pc/dtmfsender.cc \
         src/pc/externalhmac.cc \
         src/pc/iceserverparsing.cc \
         src/pc/jsepicecandidate.cc \
         src/pc/jsepsessiondescription.cc \
         src/pc/localaudiosource.cc \
         src/pc/mediamonitor.cc \
         src/pc/mediasession.cc \
         src/pc/mediastream.cc \
         src/pc/mediastreamobserver.cc \
         src/pc/peerconnection.cc \
         src/pc/peerconnectionfactory.cc \
         src/pc/remoteaudiosource.cc \
         src/pc/rtcpmuxfilter.cc \
         src/pc/rtcstatscollector.cc \
         src/pc/rtpreceiver.cc \
         src/pc/rtpsender.cc \
         src/pc/rtptransport.cc \
         src/pc/sctputils.cc \
         src/pc/srtpfilter.cc \
         src/pc/srtpsession.cc \
         src/pc/srtptransport.cc \
         src/pc/statscollector.cc \
         src/pc/trackmediainfomap.cc \
         src/pc/transportcontroller.cc \
         src/pc/videocapturertracksource.cc \
         src/pc/videotrack.cc \
         src/pc/videotracksource.cc \
         src/pc/webrtcsdp.cc \
         src/pc/webrtcsession.cc \
         src/pc/webrtcsessiondescriptionfactory.cc \
         src/rtc_base/asyncinvoker.cc \
         src/rtc_base/asyncpacketsocket.cc \
         src/rtc_base/asyncresolverinterface.cc \
         src/rtc_base/asyncsocket.cc \
         src/rtc_base/asynctcpsocket.cc \
         src/rtc_base/asyncudpsocket.cc \
         src/rtc_base/base64.cc \
         src/rtc_base/bitbuffer.cc \
         src/rtc_base/bufferqueue.cc \
         src/rtc_base/bytebuffer.cc \
         src/rtc_base/checks.cc \
         src/rtc_base/copyonwritebuffer.cc \
         src/rtc_base/crc32.cc \
         src/rtc_base/criticalsection.cc \
         src/rtc_base/cryptstring.cc \
         src/rtc_base/event.cc \
         src/rtc_base/event_tracer.cc \
         src/rtc_base/file.cc \
         src/rtc_base/fileutils.cc \
         src/rtc_base/firewallsocketserver.cc \
         src/rtc_base/flags.cc \
         src/rtc_base/helpers.cc \
         src/rtc_base/httpbase.cc \
         src/rtc_base/httpcommon.cc \
         src/rtc_base/httpserver.cc \
         src/rtc_base/ipaddress.cc \
         src/rtc_base/json.cc \
         src/rtc_base/location.cc \
         src/rtc_base/logging.cc \
         src/rtc_base/md5.cc \
         src/rtc_base/md5digest.cc \
         src/rtc_base/messagedigest.cc \
         src/rtc_base/messagehandler.cc \
         src/rtc_base/messagequeue.cc \
         src/rtc_base/natserver.cc \
         src/rtc_base/natsocketfactory.cc \
         src/rtc_base/nattypes.cc \
         src/rtc_base/nethelpers.cc \
         src/rtc_base/network.cc \
         src/rtc_base/networkmonitor.cc \
         src/rtc_base/nullsocketserver.cc \
         src/rtc_base/numerics/exp_filter.cc \
         src/rtc_base/openssladapter.cc \
         src/rtc_base/openssldigest.cc \
         src/rtc_base/opensslidentity.cc \
         src/rtc_base/opensslstreamadapter.cc \
         src/rtc_base/optionsfile.cc \
         src/rtc_base/pathutils.cc \
         src/rtc_base/physicalsocketserver.cc \
         src/rtc_base/platform_file.cc \
         src/rtc_base/platform_thread.cc \
         src/rtc_base/proxyinfo.cc \
         src/rtc_base/proxyserver.cc \
         src/rtc_base/race_checker.cc \
         src/rtc_base/random.cc \
         src/rtc_base/rate_limiter.cc \
         src/rtc_base/ratelimiter.cc \
         src/rtc_base/ratetracker.cc \
         src/rtc_base/rate_statistics.cc \
         src/rtc_base/rtccertificate.cc \
         src/rtc_base/rtccertificategenerator.cc \
         src/rtc_base/sequenced_task_checker_impl.cc \
         src/rtc_base/sha1.cc \
         src/rtc_base/sha1digest.cc \
         src/rtc_base/signalthread.cc \
         src/rtc_base/sigslot.cc \
         src/rtc_base/socketadapters.cc \
         src/rtc_base/socketaddress.cc \
         src/rtc_base/socketaddresspair.cc \
         src/rtc_base/socketstream.cc \
         src/rtc_base/ssladapter.cc \
         src/rtc_base/sslfingerprint.cc \
         src/rtc_base/sslidentity.cc \
         src/rtc_base/sslstreamadapter.cc \
         src/rtc_base/stream.cc \
         src/rtc_base/string_to_number.cc \
         src/rtc_base/stringencode.cc \
         src/rtc_base/stringutils.cc \
         src/rtc_base/task_queue_libevent.cc \
         src/rtc_base/testclient.cc \
         src/rtc_base/thread.cc \
         src/rtc_base/thread_checker_impl.cc \
         src/rtc_base/timestampaligner.cc \
         src/rtc_base/timeutils.cc \
         src/rtc_base/transformadapter.cc \
         src/rtc_base/virtualsocketserver.cc \
         src/rtc_base/weak_ptr.cc \
         src/stats/rtcstats.cc \
         src/stats/rtcstats_objects.cc \
         src/stats/rtcstatsreport.cc \
         src/system_wrappers/source/aligned_malloc.cc \
         src/system_wrappers/source/clock.cc \
         src/system_wrappers/source/cpu_info.cc \
         src/system_wrappers/source/cpu_features.cc \
         src/system_wrappers/source/event.cc \
         src/system_wrappers/source/field_trial_default.cc \
         src/system_wrappers/source/file_impl.cc \
         src/system_wrappers/source/metrics_default.cc \
         src/system_wrappers/source/rtp_to_ntp_estimator.cc \
         src/system_wrappers/source/rw_lock.cc \
         src/system_wrappers/source/sleep.cc \
         src/system_wrappers/source/timestamp_extrapolator.cc \
         src/video/call_stats.cc \
         src/video/encoder_rtcp_feedback.cc \
         src/video/overuse_frame_detector.cc \
         src/video/payload_router.cc \
         src/video/quality_threshold.cc \
         src/video/receive_statistics_proxy.cc \
         src/video/replay.cc \
         src/video/report_block_stats.cc \
         src/video/rtp_streams_synchronizer.cc \
         src/video/rtp_video_stream_receiver.cc \
         src/video/screenshare_loopback.cc \
         src/video/send_delay_stats.cc \
         src/video/send_statistics_proxy.cc \
         src/video/stats_counter.cc \
         src/video/stream_synchronization.cc \
         src/video/transport_adapter.cc \
         src/video/video_receive_stream.cc \
         src/video/video_send_stream.cc \
         src/video/video_stream_decoder.cc \
         src/video/video_stream_encoder.cc \
         src/voice_engine/audio_level.cc \
         src/voice_engine/channel.cc \
         src/voice_engine/channel_manager.cc \
         src/voice_engine/channel_proxy.cc \
         src/voice_engine/shared_data.cc \
         src/voice_engine/transmit_mixer.cc \
         src/voice_engine/transport_feedback_packet_loss_tracker.cc \
         src/voice_engine/utility.cc \
         src/voice_engine/voe_base_impl.cc \
         src/voice_engine/voice_engine_impl.cc \
         $(CXX_SRCS/$(OS)) \
         $(CXX_SRCS/$(ARCH))

YUV_SRCS/armv7l=src/third_party/libyuv/source/compare_neon.cc \
                src/third_party/libyuv/source/rotate_neon.cc \
                src/third_party/libyuv/source/row_neon.cc \
                src/third_party/libyuv/source/scale_neon.cc

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
         src/third_party/libyuv/source/video_common.cc \
         $(YUV_SRCS/$(ARCH))

LIBSRTP_SRCS=src/third_party/libsrtp/crypto/cipher/aes_gcm_ossl.c \
             src/third_party/libsrtp/crypto/cipher/aes_icm_ossl.c \
             src/third_party/libsrtp/crypto/cipher/cipher.c \
             src/third_party/libsrtp/crypto/cipher/null_cipher.c \
             src/third_party/libsrtp/crypto/hash/auth.c \
             src/third_party/libsrtp/crypto/hash/hmac_ossl.c \
             src/third_party/libsrtp/crypto/hash/null_auth.c \
             src/third_party/libsrtp/crypto/kernel/alloc.c \
             src/third_party/libsrtp/crypto/kernel/crypto_kernel.c \
             src/third_party/libsrtp/crypto/kernel/err.c \
             src/third_party/libsrtp/crypto/kernel/key.c \
             src/third_party/libsrtp/crypto/math/datatypes.c \
             src/third_party/libsrtp/crypto/math/stat.c \
             src/third_party/libsrtp/crypto/replay/rdb.c \
             src/third_party/libsrtp/crypto/replay/rdbx.c \
             src/third_party/libsrtp/crypto/replay/ut_sim.c \
             src/third_party/libsrtp/srtp/ekt.c \
             src/third_party/libsrtp/srtp/srtp.c

USRSCTP_SRCS=src/third_party/usrsctp/usrsctplib/user_environment.c \
             src/third_party/usrsctp/usrsctplib/user_recv_thread.c \
             src/third_party/usrsctp/usrsctplib/user_mbuf.c \
             src/third_party/usrsctp/usrsctplib/user_socket.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_asconf.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_indata.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_ss_functions.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_auth.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_input.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_sysctl.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_bsd_addr.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_output.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_timer.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_callout.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_pcb.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_userspace.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_cc_functions.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_peeloff.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_usrreq.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_crc32.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctp_sha1.c \
             src/third_party/usrsctp/usrsctplib/netinet/sctputil.c \
             src/third_party/usrsctp/usrsctplib/netinet6/sctp6_usrreq.c

YUV_OBJS=$(YUV_SRCS:.cc=.o)
LIBSRTP_OBJS=$(LIBSRTP_SRCS:.c=.o)
USRSCTP_OBJS=$(USRSCTP_SRCS:.c=.o)
OBJS=$(C_SRCS:.c=.o) \
     $(CXX_SRCS:.cc=.o) \
     $(YUV_OBJS) \
     $(LIBSRTP_OBJS) \
     $(USRSCTP_OBJS)

CC=gcc
CXX=g++

ifeq ($(OS),Darwin)
  OBJS+=$(OBJC_SRCS:.mm=.o)
  CC=clang
  CXX=clang++
endif

COMMON_DEFS=-DHAVE_INT16_T -DHAVE_INT32_T -DHAVE_INT8_T -DHAVE_UINT16_T -DHAVE_UINT32_T \
            -DHAVE_UINT64_T -DHAVE_UINT8_T -D_FILE_OFFSET_BITS=64 -D__STDC_CONSTANT_MACROS \
            -D__STDC_FORMAT_MACROS -DLOGGING=1 -DNDEBUG -DWEBRTC_AEC_DEBUG_DUMP=0 \
            -DGTEST_RELATIVE_PATH

# TODO: Support QUIC.
WEBRTC_DEFS=-DHAVE_WEBRTC_VIDEO -DHAVE_WEBRTC_VOICE -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE \
            -DWEBRTC_DUMMY_AUDIO_BUILD -DWEBRTC_THREAD_RR -DWEBRTC_CLOCK_TYPE_REALTIME \
            -DWEBRTC_NS_FLOAT -DWEBRTC_CODEC_OPUS -DWEBRTC_CODEC_ISAC -DWEBRTC_USE_H264 \
            -DWEBRTC_BUILD_LIBEVENT -DWEBRTC_INTELLIGIBILITY_ENHANCER=0 -DWEBRTC_APM_DEBUG_DUMP=0 \
            -DGOOGLE_PROTOBUF_NO_RTTI -DWEBRTC_USE_EPOLL -DWEBRTC_OPUS_SUPPORT_120MS_PTIME=0 \
            -DWEBRTC_OPUS_VARIABLE_COMPLEXITY=0 #-DHAVE_QUIC

SSL_DEFS=-DFEATURE_ENABLE_SSL -DSSL_USE_OPENSSL -DOPENSSL -DHAVE_OPENSSL_SSL_H

PROTOCOL_DEFS=-DHAVE_SRTP -DSRTP_RELATIVE_PATH -DHAVE_SCTP

DEFS/Linux=-DWEBRTC_POSIX -DWEBRTC_LINUX -DLINUX
DEFS/Darwin=-DWEBRTC_POSIX -DWEBRTC_MAC
DEFS/MinGW=-DWEBRTC_WIN -D_Check_return_= -DUNICODE -D_UNICODE -D_WIN32_WINNT=0x0601
DEFS/armv7l=-DWEBRTC_HAS_NEON

LIBSRTP_DEFS=-DPACKAGE_STRING='"libsrtp2 2.0.0-pre"' -DPACKAGE_VERSION='"2.0.0-pre"' \
             -DHAVE_CONFIG_H -DOPENSSL -DHAVE_STDLIB_H -DHAVE_STRING_H -DHAVE_STDINT_H \
             -DHAVE_INTTYPES_H -DHAVE_INT16_T -DHAVE_INT32_T -DHAVE_INT8_T -DHAVE_UINT16_T \
             -DHAVE_UINT32_T -DHAVE_UINT64_T -DHAVE_UINT8_T
LIBSRTP_DEFS/Linux=-DHAVE_ARPA_INET_H -DHAVE_NETINET_IN_H -DHAVE_SYS_TYPES_H -DHAVE_UNISTD_H
LIBSRTP_DEFS/MingGW=-DHAVE_WINSOCK2_H

USRSCTP_DEFS=-DSCTP_USE_OPENSSL_SHA1 -DSCTP_PROCESS_LEVEL_LOCKS -DSCTP_SIMPLE_ALLOCATOR -D__Userspace__
USRSCTP_DEFS/Darwin=-D__Userspace_os_Darwin -U__APPLE__ -D__APPLE_USE_RFC_2292
USRSCTP_DEFS/MinGW=-D__Userspace_os_Windows

DEFS=$(COMMON_DEFS) $(WEBRTC_DEFS) $(SSL_DEFS) $(PROTOCOL_DEFS) $(DEFS/$(OS)) $(DEFS/$(ARCH)) \
     $(LIBSRTP_DEFS) $(LIBSRTP_DEFS/$(OS)) $(USRSCTP_DEFS) $(USRSCTP_DEFS/$(OS))

THIRD_PARTY_INCS=-Isrc/third_party/gflags/build/include \
                 -Isrc/third_party/libyuv/include \
                 -Isrc/third_party/libsrtp/include \
                 -Isrc/third_party/libsrtp/config \
                 -Isrc/third_party/libsrtp/crypto/include \
                 -Isrc/third_party/opus/src/celt \
                 -Isrc/third_party/opus/src/include \
                 -Isrc/third_party/opus/src/src \
                 -Isrc/third_party/usrsctp

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

COMMON_CFLAGS=-g -O2 --param=ssp-buffer-size=4 -fno-strict-aliasing -fdata-sections \
              -ffunction-sections -fno-ident -pipe
CFLAGS/Linux=-pthread -fstack-protector
CFLAGS/Darwin=-mmacosx-version-min=10.7 -pthread -fstack-protector -Wno-c++11-narrowing -m64
CFLAGS/MINGW=
CFLAGS/x86_64=-msse2
CFLAGS/i686=-msse2
CFLAGS/armv7l=-mfpu=neon -fPIC
CFLAGS=$(COMMON_CFLAGS) $(CFLAGS/$(OS)) $(CFLAGS/$(ARCH))

CXXFLAGS=$(CFLAGS) -fno-exceptions -funwind-tables -fno-rtti -fno-threadsafe-statics \
         -fvisibility-inlines-hidden -std=gnu++11
ifeq (clang++,$(CXX))
    CXXFLAGS+=-stdlib=libc++
endif

depend: .cdepend .cxxdepend

.cdepend: $(C_SRCS)
	rm -f $@
	for x in $^ ; do \
	    $(CC) $(DEFS) $(INCS) $(CFLAGS) -MM -MT $${x%.c}.o $$x >> $@ ; \
	done

.cxxdepend: $(CXX_SRCS)
	rm -f $@
	for x in $^ ; do \
	    $(CXX) $(DEFS) $(INCS) $(CXXFLAGS) -MM -MT $${x%.cc}.o $$x >> $@ ; \
	done

include .cdepend
include .cxxdepend

$(YUV_OBJS): %.o: %.cc
	$(CXX) -c $(COMMON_DEFS) -Isrc/third_party/libyuv/include $(CXXFLAGS) $< -o $@

$(LIBSRTP_OBJS): %.o: %.c
	$(CC) -c $(COMMON_DEFS) $(LIBSRTP_DEFS) $(LIBSRTP_DEFS/$(OS)) $(CFLAGS) $< -o $@ \
	      -Isrc/third_party/libsrtp -Isrc/third_party/libsrtp/config \
	      -Isrc/third_party/libsrtp/include -Isrc/third_party/libsrtp/crypto/include


$(USRSCTP_OBJS): %.o: %.c
	$(CC) -c $(COMMON_DEFS) $(USRSCTP_DEFS) $(USRSCTP_DEFS/$(OS)) $(CFLAGS) $< -o $@ \
	      -Isrc/third_party/usrsctp/usrsctplib

.c.o:
	$(CC) $(DEFS) $(INCS) $(CFLAGS) -c -o $@ $<

.cc.o:
	$(CXX) $(DEFS) $(INCS) $(CXXFLAGS) -c -o $@ $<

%.o : %.mm
	$(CXX) $(DEFS) $(INCS) $(CXXFLAGS) -c -o $@ $<

libwebrtc.a: $(OBJS)
ifeq ($(OS),MinGW)
	find src -name "*.o" > objs.txt
	ar rcs $@ @objs.txt
else
	ar rcs $@ $^
endif

define TEST_WEBRTC_CC_SRC
#include <iostream>
#include <api/mediastreaminterface.h>
#include <api/peerconnectioninterface.h>
#include <rtc_base/ssladapter.h>
int main(int argc, char** argv) {
    if (!rtc::InitializeSSL()) {
        std::cerr << "Failed to init SSL." << std::endl;
        return 1;
    }
    auto factory = webrtc::CreatePeerConnectionFactory(nullptr, nullptr, nullptr, nullptr, nullptr);
    webrtc::PeerConnectionInterface::RTCConfiguration config;
    auto pc = factory->CreatePeerConnection(config, nullptr, nullptr, nullptr, nullptr);
    auto video_source = factory->CreateVideoSource(nullptr, nullptr);
    auto video_track = factory->CreateVideoTrack("test", video_source);;
    auto stream = factory->CreateLocalMediaStream("test");
    stream->AddTrack(video_track);
    pc->AddStream(stream);
    if (!rtc::CleanupSSL()) {
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
	   ./libwebrtc.a -Wl,-Bstatic -lopus -levent -lssl -lcrypto -Wl,-Bdynamic -ldl

clean:
	rm -f $(OBJS) objs.txt libwebrtc.a

install_webrtc_hdrs:
	mkdir -p $(PREFIX)/include/webrtc
	install -C src/*.h $(PREFIX)/include/webrtc/
	mkdir -p $(PREFIX)/include/webrtc/api
	install -C src/api/*.h $(PREFIX)/include/webrtc/api
	mkdir -p $(PREFIX)/include/webrtc/api/audio
	install -C src/api/audio/*.h $(PREFIX)/include/webrtc/api/audio
	mkdir -p $(PREFIX)/include/webrtc/api/audio_codecs
	install -C src/api/audio_codecs/*.h $(PREFIX)/include/webrtc/api/audio_codecs
	mkdir -p $(PREFIX)/include/webrtc/api/call
	install -C src/api/call/*.h $(PREFIX)/include/webrtc/api/call
	mkdir -p $(PREFIX)/include/webrtc/api/stats
	install -C src/api/stats/*.h $(PREFIX)/include/webrtc/api/stats
	mkdir -p $(PREFIX)/include/webrtc/api/video
	install -C src/api/video/*.h $(PREFIX)/include/webrtc/api/video
	mkdir -p $(PREFIX)/include/webrtc/api/video_codecs
	install -C src/api/video_codecs/*.h $(PREFIX)/include/webrtc/api/video_codecs
	mkdir -p $(PREFIX)/include/webrtc/rtc_base
	install -C src/rtc_base/*.h $(PREFIX)/include/webrtc/rtc_base
	mkdir -p $(PREFIX)/include/webrtc/call
	install -C src/call/*.h $(PREFIX)/include/webrtc/call
	mkdir -p $(PREFIX)/include/webrtc/common_video
	install -C src/common_video/*.h $(PREFIX)/include/webrtc/common_video
	mkdir -p $(PREFIX)/include/webrtc/common_video/include
	install -C src/common_video/include/*.h $(PREFIX)/include/webrtc/common_video/include
	mkdir -p $(PREFIX)/include/webrtc/media/base
	install -C src/media/base/*.h $(PREFIX)/include/webrtc/media/base
	mkdir -p $(PREFIX)/include/webrtc/media/engine
	install -C src/media/engine/*.h $(PREFIX)/include/webrtc/media/engine
	mkdir -p $(PREFIX)/include/webrtc/modules/include
	install -C src/modules/include/*.h $(PREFIX)/include/webrtc/modules/include
	mkdir -p $(PREFIX)/include/webrtc/modules/audio_coding/codecs
	install -C src/modules/audio_coding/codecs/*.h \
	        $(PREFIX)/include/webrtc/modules/audio_coding/codecs
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
	install -C src/p2p/base/*.h $(PREFIX)/include/webrtc/p2p/base
	mkdir -p $(PREFIX)/include/webrtc/p2p/client
	install -C src/p2p/client/*.h $(PREFIX)/include/webrtc/p2p/client
	mkdir -p $(PREFIX)/include/webrtc/pc
	install -C src/pc/*.h $(PREFIX)/include/webrtc/pc
	mkdir -p $(PREFIX)/include/webrtc/system_wrappers/include
	install -C src/system_wrappers/include/*.h \
	        $(PREFIX)/include/webrtc/system_wrappers/include

install: libwebrtc.a install_webrtc_hdrs
	install -C libwebrtc.a $(PREFIX)/lib
