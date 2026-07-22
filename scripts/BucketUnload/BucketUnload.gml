function BucketUnload(_bucketName)
{
    static _system = __BucketSystem();
    static _runtimeBucketMap = _system.__runtimeBucketMap;
    
    if (not _system.__manifestLoaded)
    {
        __BucketError("Please call `BucketLoadManifest()` before `BucketUnload()`");
    }
    
    var _bucket = _runtimeBucketMap[? _bucketName];
    
    if (not is_struct(_bucket))
    {
        __BucketError($"Bucket \"{_bucketName}\" not found");
    }
    
    _bucket.__Unload();
}