function __AbLoadString(_path)
{
    if (not file_exists(_path))
    {
        __AbError($"Could not find {_path}");
    }
    
    var _buffer = buffer_load(_path);
    if (not buffer_exists(_buffer))
    {
        __AbError($"Failed to load {_path}");
    }
    
    var _string = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);
    
    return _string;
}