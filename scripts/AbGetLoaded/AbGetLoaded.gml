/// @param bucketName
/// @param [strict=false]

function AbGetLoaded(_bucketName, _strict = false)
{
    static _system = __AbSystem();
    static _runtimeBucketMap = _system.__runtimeBucketMap;
    
    if (not _system.__manifestLoaded)
    {
        if (_strict)
        {
            __AbError("Please call `AbLoadManifest()` before `AbGetLoaded()`");
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
            __AbError($"Ab \"{_bucketName}\" not found");
        }
        else
        {
            return false;
        }
    }
    
    return _bucket.__loaded;
}