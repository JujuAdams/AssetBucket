var _commandList = new AbCommandList();

var _baseFileList = (new AbFileList())
                    .ChangeRootDirectory(AB_PROJECT_DIRECTORY + "asset_bucket")
                    .PopulateFromSubdirectory("");

var _datafileFileList = _baseFileList.Duplicate()
.ChangeRootDirectory(AB_PROJECT_DIRECTORY + "asset_bucket/datafiles");

var _spriteFileList = _baseFileList.Duplicate()
.ChangeRootDirectory(AB_PROJECT_DIRECTORY + "asset_bucket/sprites")
.IncludeLocalPaths("*.png");

var _soundFileList = _baseFileList.Duplicate()
.ChangeRootDirectory(AB_PROJECT_DIRECTORY + "asset_bucket/sounds")
.IncludeLocalPaths(["*.wav", "*.ogg"]);

//_datafileFileList.Foreach(method({
//    commandLine: _commandList,
//    bucketName: "bufferDefault",
//},
//function(_fileDesc)
//{
//    commandLine.AddDatafileToProject(bucketName, _fileDesc.localPath, _fileDesc.absolutePath);
//}));
//
//_spriteFileList.Foreach(method({
//    commandLine: _commandList,
//    bucketName: "bufferDefault",
//},
//function(_fileDesc)
//{
//    commandLine.AddSpriteToProject(_fileDesc.suggestedName, _fileDesc.linkedPaths, "Sprites");
//}));
//
//_soundFileList.Foreach(method({
//    commandLine: _commandList,
//    bucketName: "bufferDefault",
//},
//function(_fileDesc)
//{
//    commandLine.AddSoundToProject(_fileDesc.suggestedName, _fileDesc.absolutePath, "Sounds");
//
//}));

_datafileFileList.Foreach(method({
    commandLine: _commandList,
    bucketName: "bufferDefault",
},
function(_fileDesc)
{
    commandLine.AddDatafileToBucket(bucketName, _fileDesc.localPath, _fileDesc.absolutePath);
}));

_spriteFileList.Foreach(method({
    commandLine: _commandList,
    bucketName: "bufferDefault",
},
function(_fileDesc)
{
    commandLine.AddSpriteToBucket(bucketName, _fileDesc.suggestedName, _fileDesc.linkedPaths);
}));

_soundFileList.Foreach(method({
    commandLine: _commandList,
    bucketName: "bufferDefault",
},
function(_fileDesc)
{
    commandLine.AddSoundToBucket(bucketName, _fileDesc.suggestedName, _fileDesc.absolutePath);
}));

_commandList.SaveToProject(GM_project_filename);

AbBucketLoad("ab_4582a72d1450f5e8816521ea5a808b06_h.json");

AbManifestLoadAndFetch(AB_MANIFEST_FILENAME);

//AbLoad("bucketDefault");
//texturegroup_load("bucketDefault");
//
//show_debug_message(AbDatafileGetString("datafiles/localization/english.txt"));