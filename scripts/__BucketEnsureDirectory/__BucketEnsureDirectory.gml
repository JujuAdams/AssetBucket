function __BucketEnsureDirectory(_path)
{
    if (_path == "")
    {
        return _path;
    }
    
    _path = string_replace_all(_path, "\\", "/");
    
    if (string_char_at(_path, string_length(_path)) != "/")
    {
        _path += "/";
    }
    
    return _path;
}