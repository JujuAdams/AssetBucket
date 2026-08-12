/// Flushes a bucket, freeing up some memory used by its assets. This is the opposite of fetching.
/// A flushed bucket remains partially in memory and may later be re-fetched.
/// 
/// @param bucketName

function AbBucketFlush(_bucketName)
{
    static _projectBucketMap = __AbSystem().__projectBucketMap;
    
    var _bucket = _projectBucketMap[? _bucketName];
    if (_bucket != undefined)
    {
        _bucket.__Flush();
    }
}