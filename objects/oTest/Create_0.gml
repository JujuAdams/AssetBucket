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
function(_fileDesc)
{
    commandLine.AddDatafileToProject(bucketName, _fileDesc.localPath, _fileDesc.absolutePath);
}));

_baseFileList.Duplicate()
.ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/sprites")
.IncludeLocalPaths("*.png")
.CollectImageFrames()
.Foreach(method({
    commandLine: _commandList,
    bucketName: "bufferDefault",
},
function(_fileDesc)
{
    commandLine.AddSpriteToProject(_fileDesc.suggestedName, _fileDesc.linkedPaths, "Sprites");
}));

_baseFileList.Duplicate()
.ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/sounds")
.IncludeLocalPaths(["*.wav", "*.ogg"])
.Foreach(method({
    commandLine: _commandList,
    bucketName: "bufferDefault",
},
function(_fileDesc)
{
    commandLine.AddSoundToProject(_fileDesc.suggestedName, _fileDesc.absolutePath, "Sounds");
}));

//_baseFileList.Duplicate()
//.ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/datafiles")
//.Foreach(method({
//    commandLine: _commandList,
//    bucketName: "bufferDefault",
//},
//function(_fileDesc)
//{
//    commandLine.AddDatafileToBucket(bucketName, _fileDesc.localPath, _fileDesc.absolutePath);
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
//function(_fileDesc)
//{
//    commandLine.AddSpriteToBucket(bucketName, _fileDesc.suggestedName, _fileDesc.linkedPaths);
//}));
//
//_baseFileList.Duplicate()
//.ChangeRootDirectory(BUCKET_PROJECT_DIRECTORY + "asset_bucket/sounds")
//.IncludeLocalPaths(["*.wav", "*.ogg"])
//.Foreach(method({
//    commandLine: _commandList,
//    bucketName: "bufferDefault",
//},
//function(_fileDesc)
//{
//    if (_fileDesc.extension == ".wav")
//    {
//        commandLine.AddWAVToBucket(bucketName, _fileDesc.suggestedName, _fileDesc.absolutePath);
//    }
//    else if (_fileDesc.extension == ".ogg")
//    {
//        commandLine.AddOGGToBucket(bucketName, _fileDesc.suggestedName, _fileDesc.absolutePath);
//    }
//    else
//    {
//        __BucketError($"Sound file extension \"{_fileDesc.extension}\" is not supported\nPath was \"{_fileDesc.absolutePath}\"");
//    }
//}));

_commandList.SaveToProject(GM_project_filename);

//BucketLoad("bucketDefault");
//texturegroup_load("bucketDefault");
//
//show_debug_message(BucketDatafileGetString("datafiles/localization/english.txt"));