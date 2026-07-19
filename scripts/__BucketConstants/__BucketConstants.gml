#macro BUCKET_VERSION  "0.0.0"
#macro BUCKET_DATE     "2026-07-19"

#macro BUCKET_RUNNING_FROM_IDE  (GM_build_type == "run")

#macro BUCKET_DEV_MODE  (BUCKET_ALLOW_DEV_MODE && BUCKET_RUNNING_FROM_IDE && (os_type == os_windows))

#macro BUCKET_PROJECT_DIRECTORY  $"{filename_dir(GM_project_filename)}/"

#macro BUCKET_MANIFEST_FILENAME  "ab_manifest"