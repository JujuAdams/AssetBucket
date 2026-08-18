#macro AB_VERSION  "0.1.0-alpha"
#macro AB_DATE     "2026-08-18"

#macro AB_RUNNING_FROM_IDE  (GM_build_type == "run")

#macro AB_DEV_MODE  (AB_ALLOW_DEV_MODE && AB_RUNNING_FROM_IDE && (os_type == os_windows))

#macro AB_PROJECT_NAME       filename_change_ext(filename_name(GM_project_filename), "")
#macro AB_PROJECT_DIRECTORY  $"{AbFilenameDir(GM_project_filename)}/"

#macro AB_MANIFEST_FILENAME  "ab_manifest.json"

#macro AB_TEXTURE_FORMAT_RAW   "raw"
#macro AB_TEXTURE_FORMAT_PNG   "png"
#macro AB_TEXTURE_FORMAT_ZLIB  "raw_zlib"

#macro AB_AUDIO_FORMAT_WAV       "wav"
#macro AB_AUDIO_FORMAT_OGG       "ogg"
#macro AB_AUDIO_FORMAT_WAV_ZLIB  "wav_zlib"

#macro AB_COMPRESSION_AUTO               -1
#macro AB_COMPRESSION_UNCOMPRESSED        0
#macro AB_COMPRESSION_COMPRESSED          1
#macro AB_COMPRESSION_UNCOMPRESS_ON_LOAD  2
#macro AB_COMPRESSION_COMPRESSED_STREAM   3