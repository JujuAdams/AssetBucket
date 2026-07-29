/// @param bucketName

function AbSoundsGetArray(_bucketName)
{
    static _runtimeBucketMap = __AbSystem().__runtimeBucketMap;
    
    var _bucket = _runtimeBucketMap[? _bucketName];
    
    if (not is_struct(_bucket))
    {
        __AbError($"Ab \"{_bucketName}\" not found");
    }
    
    if (not _bucket.__loaded)
    {
        __AbError($"Ab \"{_bucketName}\" not loaded");
    }
    
    return _bucket.__soundNameArray;
}