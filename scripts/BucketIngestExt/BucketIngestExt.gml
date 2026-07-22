/// @param configPath
/// @param yypPath

function BucketIngestExt(_configPath, _yypPath)
{
    if (not BUCKET_DEV_MODE)
    {
        __BucketSoftError("Cannot ingest files, not running in developer mode");
        return;
    }
    
    if (GM_is_sandboxed)
    {
        __BucketError("Please disable sandboxing for this platform");
    }
    
    __BucketDeclareDefaultWorkerFunctions();
    
    with(__BucketSystem())
    {
        var _configStruct = __BucketLoadConfigurationFile(_configPath);
        
        var _oldYYPDirectory = __currentYYPDirectory;
        var _oldIngestStruct = __currentIngestStruct;
        
        __currentYYPDirectory = $"{filename_dir(_yypPath)}/";
        __currentIngestStruct = new __BucketClassIngest(_configStruct);
        
        _configStruct.__Collect();
        __currentIngestStruct.__Ingest();
        
        __currentYYPDirectory = _oldYYPDirectory;
        __currentIngestStruct = _oldIngestStruct;
        
        return true;
    }
}