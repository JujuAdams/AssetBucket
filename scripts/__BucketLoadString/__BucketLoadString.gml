function __BucketLoadString(_path)
{
    if (not file_exists(_path))
    {
        __BucketError($"Could not find {_path}");
    }
    
    var _buffer = buffer_load(_path);
    if (not buffer_exists(_buffer))
    {
        __BucketError($"Failed to load {_path}");
    }
    
    var _string = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);
    
    return _string;
}