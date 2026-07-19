function BucketGetDatafileCopy(_originalPath)
{
    with(BucketGetDatafileRef(_originalPath))
    {
        var _buffer = buffer_create(size, buffer_fixed, 1);
        buffer_copy(buffer, offset, size, _buffer, 0);
        return _buffer;
    }
    
    return -1;
}