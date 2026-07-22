#macro BUCKET_VERSION  "0.0.0"
#macro BUCKET_DATE     "2026-07-19"

#macro BUCKET_RUNNING_FROM_IDE  (GM_build_type == "run")

#macro BUCKET_DEV_MODE  (BUCKET_ALLOW_DEV_MODE && BUCKET_RUNNING_FROM_IDE && (os_type == os_windows))

#macro BUCKET_PROJECT_NAME       filename_change_ext(filename_name(GM_project_filename), "")
#macro BUCKET_PROJECT_DIRECTORY  $"{filename_dir(GM_project_filename)}/"

#macro BUCKET_CONFIG_NOTE_ASSET_NAME  "AssetBucketConfig"

#macro BUCKET_MANIFEST_FILENAME  "ab_manifest.ab"

#macro BUCKET_CONFIG_VERSION    1
#macro BUCKET_CONTENTS_VERSION  1

#macro BUCKET_TEXTURE_FORMAT_RAW   "raw"
#macro BUCKET_TEXTURE_FORMAT_PNG   "png"
#macro BUCKET_TEXTURE_FORMAT_ZLIB  "zlib"

#macro BUCKET_AUDIO_FORMAT_WAV  "wav"
#macro BUCKET_AUDIO_FORMAT_OGG  "ogg"