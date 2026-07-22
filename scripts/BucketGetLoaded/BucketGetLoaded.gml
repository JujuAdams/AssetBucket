/// @param bucketName
/// @param [strict=false]

function BucketGetLoaded(_bucketName, _strict = false)
{
    static _system = __BucketSystem();
    static _runtimeBucketMap = _system.__runtimeBucketMap;
    
    if (not _system.__manifestLoaded)
    {
        if (_strict)
        {
            __BucketError("Please call `BucketLoadManifest()` before `BucketGetLoaded()`");
        }
        else
        {
            return false;
        }
    }
    
    var _bucket = _runtimeBucketMap[? _bucketName];
    
    if (not is_struct(_bucket))
    {
        if (_strict)
        {
            __BucketError($"Bucket \"{_bucketName}\" not found");
        }
        else
        {
            return false;
        }
    }
    
    return _bucket.__loaded;
}