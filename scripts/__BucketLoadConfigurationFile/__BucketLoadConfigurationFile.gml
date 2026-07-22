/// @param path

function __BucketLoadConfigurationFile(_path)
{
    static _system = __BucketSystem();
    
    if (not BUCKET_DEV_MODE)
    {
        __BucketSoftError("Cannot load configuration file, not running in developer mode");
        return undefined;
    }
    
    var _configStruct = BucketLoadJSON(_path);
    if (_configStruct == undefined)
    {
        __BucketError($"Failed to parse \"{_path}\"");
    }
    
    return new __BucketClassConfigRoot().__Deserialize(_configStruct);
}