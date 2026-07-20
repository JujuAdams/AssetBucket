function __BucketTrimDirectory(_path)
{
    if (_path == "")
    {
        return _path;
    }
    
    var _lastChar = string_char_at(_path, string_length(_path));
    if ((_lastChar == "/") || (_lastChar == "\\"))
    {
        return string_copy(_path, 1, string_length(_path)-1);
    }
    
    return _path;
}