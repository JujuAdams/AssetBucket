var _commandList = (new BucketCommandList())
                   .DefineBucket("bucketDefault");

var _baseFileList = (new BucketFileList())
                    .ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket")
                    .PopulateFromSubdirectory("asset_bucket");

var _datafilesList = _baseFileList.Duplicate()
                     .ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/datafiles");

var _datafilesWorker = BucketWorkerCreate(function(_fileData)
{
    AddDatafileToBucket(bucket, _fileData.absolutePath, _fileData.localPath);
},
{
    bucket: "bucketDefault",
});

_datafilesWorker.Execute(_datafilesList, _commandList);
_commandList.Execute(GM_project_filename);


BucketIngest();
BucketLoadManifest();


BucketLoad("bucketDefault");
texturegroup_load("bucketDefault");

show_debug_message(BucketDatafileGetString("datafiles/localization/english.txt"));