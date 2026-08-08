var _project = new AbProject(GM_project_filename);

var _commandList = new AbCommandList();

var _baseFileList = (new AbFileList())
                    .ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket")
                    .PopulateFromSubdirectory("");

_baseFileList.Duplicate()
.ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket/datafiles")
.Foreach(method({
    commandList: _commandList,
},
function(_fileDesc)
{
    commandList.AddDatafileToBucket("bucketDefault", _fileDesc.localPath, _fileDesc.absolutePath);
}));

_baseFileList.Duplicate()
.ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket/sounds")
.IncludeLocalPaths(["*.wav", "*.ogg"])
.Foreach(method({
    commandList: _commandList,
},
function(_fileDesc)
{
    commandList.AddSoundToBucket("bucketDefault", _fileDesc.suggestedName, _fileDesc.absolutePath);
}));

_baseFileList.Duplicate()
.ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket/sprites")
.IncludeLocalPaths(["*.png", "*.ase", "*.aseprite"])
.CollectImageFrames()
.Foreach(method({
    commandList: _commandList,
},
function(_fileDesc)
{
    var _extension = filename_ext(_fileDesc.absolutePath);
    if ((_extension != ".ase") && (_extension != ".aseprite"))
    {
        var _bucketSprite = new AbBucketSprite(_fileDesc.suggestedName, _fileDesc.linkedPaths);
        commandList.AddSpriteToBucket("bucketDefault", _bucketSprite);
    }
    else
    {
        AddAsepriteFileToBucket(_fileDesc.suggestedName, _fileDesc, "bucketDefault", commandList);
    }
}));

_commandList.SaveToProject(_project);

AbBucketLoadAndFetchFromManifest(AbGetIncludedFilesPath(AB_MANIFEST_FILENAME));
AbBucketTextureGroupsFetch("bucketDefault");
AbBucketSoundPlay("sndChickenNuggets", true);