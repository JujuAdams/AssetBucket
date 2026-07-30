/// @param bucketName

function AbBucketGetLoaded(_bucketName)
{
    static _runtimeBucketMap = __AbSystem().__runtimeBucketMap
    
    var _bucket = _runtimeBucketMap[? _bucketName];
    return (_bucket == undefined)? false : _bucket.__loaded;
}