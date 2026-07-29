function AbLoad(_bucketName)
{
    static _system = __AbSystem();
    static _runtimeBucketMap = _system.__runtimeBucketMap;
    
    if (not _system.__manifestLoaded)
    {
        __AbError("Please call `AbLoadManifest()` before `AbLoad()`");
    }
    
    var _bucket = _runtimeBucketMap[? _bucketName];
    
    if (not is_struct(_bucket))
    {
        __AbError($"Ab \"{_bucketName}\" not found");
    }
    
    _bucket.__Load();
}