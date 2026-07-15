#macro BUCKET_RUNNING_FROM_IDE  (GM_build_type == "run")

#macro BUCKET_DEV_MODE  (BUCKET_ALLOW_DEV_MODE && BUCKET_RUNNING_FROM_IDE && (os_type == os_windows))

#macro BUCKET_PROJECT_DIRECTORY  $"{filename_dir(GM_project_filename)}/"