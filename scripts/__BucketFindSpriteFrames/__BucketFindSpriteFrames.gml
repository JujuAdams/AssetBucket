/// @param directory
/// @param path

function __BucketFindSpriteFrames(_directory, _path)
{
    static _system = __BucketSystem();
    
    var _searchString = "_frame0";
    var _array = [_path];
    
    var _framePos = string_pos(_searchString, _path);
    var _startString = string_copy(_path, 1, _framePos-1);
    var _endString = string_delete(_path, 1, _framePos-1);
    
    if (filename_change_ext(_endString, "") != _searchString)
    {
        return _array;
    }
    
    var _extension = filename_ext(_path);
    var _i = 1;
    while(true)
    {
        var _searchPath = $"{_startString}_frame{_i}{_extension}";
        if (file_exists(_directory + _searchPath))
        {
            array_push(_array, _searchPath);
            ++_i;
        }
        else
        {
            break;
        }
    }
    
    return _array;
}