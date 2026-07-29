var _commandList = new BucketCommandList();

var _baseFileList = (new BucketFileList())
                    .ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket")
                    .PopulateFromSubdirectory("");



var _datafileList = _baseFileList.Duplicate()
                     .ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/datafiles");
var _datafileWorker = BucketWorkerCreate(function(_fileData)
{
    AddDatafileToBucket(bucket, _fileData.localPath, _fileData.absolutePath);
},
{ bucket: "bucketDefault" });
_datafileWorker.SendToCommandList(_commandList, _datafileList);



var _spriteList = _baseFileList.Duplicate()
                   .ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/sprites")
                   .IncludeLocalPaths("*.png");
var _spriteWorker = BucketWorkerCreate(function(_fileData)
{
    AddSpriteToBucket(bucket, filename_change_ext(filename_name(_fileData.absolutePath), ""), _fileData.absolutePath);
},
{ bucket: "bucketDefault" });
_spriteWorker.SendToCommandList(_commandList, _spriteList);



var _wavList = _baseFileList.Duplicate()
               .ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/sounds")
               .IncludeLocalPaths("*.wav");
var _wavWorker = BucketWorkerCreate(function(_fileData)
{
    AddWAVToBucket(bucket, filename_change_ext(filename_name(_fileData.absolutePath), ""), _fileData.absolutePath);
},
{ bucket: "bucketDefault" });
_wavWorker.SendToCommandList(_commandList, _wavList);



var _oggList = _baseFileList.Duplicate()
               .ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/sounds")
               .IncludeLocalPaths("*.ogg");
var _oggWorker = BucketWorkerCreate(function(_fileData)
{
    AddOGGToBucket(bucket, filename_change_ext(filename_name(_fileData.absolutePath), ""), _fileData.absolutePath);
},
{ bucket: "bucketDefault" });
_oggWorker.SendToCommandList(_commandList, _oggList);



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