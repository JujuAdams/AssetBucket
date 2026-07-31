/// @param bucketName

function AbBucketGetLoaded(_bucketName)
{
    static _projectBucketMap = __AbSystem().__projectBucketMap
    
    var _bucket = _projectBucketMap[? _bucketName];
    return (_bucket == undefined)? false : _bucket.__loaded;
}