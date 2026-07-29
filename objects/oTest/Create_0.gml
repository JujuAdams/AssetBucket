var _commandList = (new BucketCommandList())
                   .DefineBucket("bucketDefault");

var _baseFileList = (new BucketFileList())
                    .ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket")
                    .PopulateFromSubdirectory("");

var _datafilesList = _baseFileList.Duplicate()
                     .ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/datafiles");

var _datafilesWorker = BucketWorkerCreate(function(_fileData)
{
    AddDatafileToBucket(bucket, _fileData.localPath, _fileData.absolutePath);
},
{
    bucket: "bucketDefault",
});

_datafilesWorker.SendToCommandList(_commandList, _datafilesList);
_commandList.SaveToProject(GM_project_filename);

//BucketLoad("bucketDefault");
//texturegroup_load("bucketDefault");
//
//show_debug_message(BucketDatafileGetString("datafiles/localization/english.txt"));

//job = {
//    buckets: [
//        {
//            name: "bucketDefault",
//        }
//    ],
//    fileLists: [
//        {
//            name: "base"
//            rootDirectory: "../asset_bucket/datafiles",
//            populateFromSubdirectory: "",
//        },
//        {
//            name: "datafiles"
//            duplicateOf: "base",
//            rootDirectory: "../asset_bucket/datafiles",
//        },
//    ],
//    workers: [
//        {
//            name: "addDatafileToBucket",
//            fileList: "datafiles",
//            bucket: "bucketDefault",
//        },
//    ],
//};