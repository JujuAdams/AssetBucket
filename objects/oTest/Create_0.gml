var _commandList = new BucketCommandList();

var _baseFileList = (new BucketFileList())
                    .ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket")
                    .PopulateFromSubdirectory("");

_baseFileList.Duplicate()
.ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/datafiles")
.Foreach(method({
    commandLine: _commandList,
    bucketName: "bufferDefault",
},
function(_fileData)
{
    commandLine.AddDatafileToProject(bucketName, _fileData.localPath, _fileData.absolutePath);
}));

_baseFileList.Duplicate()
.ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/sprites")
.IncludeLocalPaths("*.png")
.CollectImageFrames()
.Foreach(method({
    commandLine: _commandList,
    bucketName: "bufferDefault",
},
function(_fileData)
{
    commandLine.AddSpriteToProject(_fileData.suggestedName, _fileData.linkedPaths, "Sprites");
}));

_baseFileList.Duplicate()
.ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/sounds")
.IncludeLocalPaths(["*.wav", "*.ogg"])
.Foreach(method({
    commandLine: _commandList,
    bucketName: "bufferDefault",
},
function(_fileData)
{
    commandLine.AddSoundToProject(_fileData.suggestedName, _fileData.absolutePath, "Sounds");
}));

//_baseFileList.Duplicate()
//.ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/datafiles")
//.Foreach(method({
//    commandLine: _commandList,
//    bucketName: "bufferDefault",
//},
//function(_fileData)
//{
//    commandLine.AddDatafileToBucket(bucketName, _fileData.localPath, _fileData.absolutePath);
//}));
//
//_baseFileList.Duplicate()
//.ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/sprites")
//.IncludeLocalPaths("*.png")
//.CollectImageFrames()
//.Foreach(method({
//    commandLine: _commandList,
//    bucketName: "bufferDefault",
//},
//function(_fileData)
//{
//    commandLine.AddSpriteToBucket(bucketName, _fileData.suggestedName, _fileData.linkedPaths);
//}));
//
//_baseFileList.Duplicate()
//.ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/sounds")
//.IncludeLocalPaths(["*.wav", "*.ogg"])
//.Foreach(method({
//    commandLine: _commandList,
//    bucketName: "bufferDefault",
//},
//function(_fileData)
//{
//    if (_fileData.extension == ".wav")
//    {
//        commandLine.AddWAVToBucket(bucketName, _fileData.suggestedName, _fileData.absolutePath);
//    }
//    else if (_fileData.extension == ".ogg")
//    {
//        commandLine.AddOGGToBucket(bucketName, _fileData.suggestedName, _fileData.absolutePath);
//    }
//    else
//    {
//        __BucketError($"Sound file extension \"{_fileData.extension}\" is not supported\nPath was \"{_fileData.absolutePath}\"");
//    }
//}));

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