function __AbEnsureDirectory(_path)
{
    if (_path == "")
    {
        return _path;
    }
    
    _path = string_replace_all(_path, "\\", "/");
    
    var _splitArray = string_split(_path, "/", true);
    var _i = array_length(_splitArray)-1;
    while(_i > 0)
    {
        if (_splitArray[_i] == ".")
        {
            array_delete(_splitArray, _i, 1);
        }
        else if (_splitArray[_i] == "..")
        {
            array_delete(_splitArray, _i-1, 2);
            --_i;
        }
        
        --_i;
    }
    
    return string_join_ext("/", _splitArray) + "/";
}