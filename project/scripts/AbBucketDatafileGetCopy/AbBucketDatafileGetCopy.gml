/// Returns a copy of a buffer from a bucket. The bucket must first have been both loaded and
/// fetched. If the datafile cannot be found this function will return `-1`.
/// 
/// @param alias

function AbBucketDatafileGetCopy(_alias)
{
    with(AbBucketDatafileGetRef(_alias))
    {
        var _buffer = buffer_create(size, buffer_fixed, 1);
        buffer_copy(buffer, offset, size, _buffer, 0);
        return _buffer;
    }
    
    return -1;
}