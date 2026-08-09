//Create a project representation for us to work with
var _project = new AbProject(GM_project_filename);
AbPipeBeginForProject(_project);

AbForeachFile($"{AB_PROJECT_DIRECTORY}../asset_bucket/datafiles", false, function(_fileDesc)
{
    AbPipeBucketDatafile("bucketDefault", _fileDesc.localPath, _fileDesc.absolutePath);
});

AbForeachFileFiltered($"{AB_PROJECT_DIRECTORY}../asset_bucket/sounds", false, ["*.wav", "*.ogg"], undefined, function(_fileDesc)
{
    AbPipeBucketSound("bucketDefault", _fileDesc.suggestedName, _fileDesc.absolutePath);
});

AbForeachFileFiltered($"{AB_PROJECT_DIRECTORY}../asset_bucket/sprites", true, ["*.png", "*.ase", "*.aseprite"], undefined, function(_fileDesc)
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