var _commandList = new AbCommandList();

var _baseFileList = (new AbFileList())
                    .ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket")
                    .PopulateFromSubdirectory("");

var _datafileFileList = _baseFileList.Duplicate()
.ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket/datafiles");

var _spriteFileList = _baseFileList.Duplicate()
.ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket/sprites")
.IncludeLocalPaths(["*.png", "*.ase", "*.aseprite"]);

_spriteFileList.CollectImageFrames();

var _soundFileList = _baseFileList.Duplicate()
.ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket/sounds")
.IncludeLocalPaths(["*.wav", "*.ogg"]);

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

//AbBucketStageAndLoadFromManifest(AbGetDatafilePath(AB_MANIFEST_FILENAME));
//show_debug_message(AbBucketGetTextureGroups("bucketDefault"));
//show_debug_message(AbDatafileGetString("localization/english.txt"));