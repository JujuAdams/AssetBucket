function BucketDatafilesGetLoaded(_bucketName)
{
    static _runtimeBucketMap = __BucketSystem().__runtimeBucketMap;
    
    var _bucket = _runtimeBucketMap[? _bucketName];
    
    if (not is_struct(_bucket))
    {
        __BucketError($"Bucket \"{_bucketName}\" not found");
    }
    
    return _bucket.__loaded;
}