//Create a project representation for us to work with
var _project = new AbProject(GM_project_filename);
AbPipeBeginForProject(_project);

(new AbFileListDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket/datafiles"))
.Foreach(function(_fileDesc)
{
    AbPipeBucketDatafile("bucketDefault", _fileDesc.localPath, _fileDesc.absolutePath);
});

(new AbFileListDirectoryWithFilters($"{AB_PROJECT_DIRECTORY}../asset_bucket/sounds", false, ["*.wav", "*.ogg"]))
.Foreach(function(_fileDesc)
{
    AbPipeBucketSound("bucketDefault", _fileDesc.suggestedName, _fileDesc.absolutePath);
});

(new AbFileListDirectoryWithFilters($"{AB_PROJECT_DIRECTORY}../asset_bucket/sprites", true, ["*.png", "*.ase", "*.aseprite"]))
.Foreach(function(_fileDesc)
{
    var _extension = filename_ext(_fileDesc.absolutePath);
    if ((_extension != ".ase") && (_extension != ".aseprite"))
    {
        AbPipeBucketSprite("bucketDefault", _fileDesc.suggestedName, _fileDesc.linkedPaths);
    }
    else
    {
        CustomPipeBucketAseprite("bucketDefault", _fileDesc.suggestedName, _fileDesc);
    }
});

AbPipeEnd();



AbBucketLoadAndFetchFromManifest(AbGetIncludedFilesPath(AB_MANIFEST_FILENAME));
AbBucketTextureGroupsFetch("bucketDefault");
AbBucketSoundPlay("sndChickenNuggets", true);