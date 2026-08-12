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

show_debug_message(json_stringify(AbBucketGetAllLoaded()));
AbBucketLoadFromManifest(AbGetIncludedFilesPath(AB_MANIFEST_FILENAME));
show_debug_message(json_stringify(AbBucketGetAllLoaded()));

show_debug_message(json_stringify(AbBucketGetSpriteNames("bucketDefault"), true));
show_debug_message(json_stringify(AbBucketGetSoundAliases("bucketDefault"), true));
show_debug_message(json_stringify(AbBucketGetDatafileAliases("bucketDefault"), true));

show_debug_message(json_stringify(AbBucketGetAllFetched()));
AbBucketFetch("bucketDefault");
show_debug_message(json_stringify(AbBucketGetAllFetched()));

AbBucketTextureGroupsFetch("bucketDefault");
AbBucketSoundPlay("sndChickenNuggets", true);