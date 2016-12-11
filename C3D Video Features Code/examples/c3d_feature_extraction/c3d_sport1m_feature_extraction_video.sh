mkdir -p output/c3d/April_09_brush_hair_u_nm_np1_ba_goo_0
GLOG_logtosterr=1 ../../build/tools/extract_image_features.bin prototxt/c3d_sport1m_feature_extractor_video.prototxt conv3d_deepnetA_sport1m_iter_1900000 -1 50 1 prototxt/output_list_video_prefix.txt fc7-1 fc6-1 prob
