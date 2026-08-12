/// @param bucketName
/// @param [outputArray]

function AbBucketGetSpriteNames(_bucketName, _outputArray = undefined)
{
    static _projectBucketMap = __AbSystem().__projectBucketMap
    
    var _bucket = _projectBucketMap[? _bucketName];
    if (_bucket == undefined)
    {
        if (_outputArray == undefined)
        {
            _outputArray = [];
        }
        else
        {
            array_resize(_outputArray, 0);
        }
    }
    else
    {
        if (_outputArray == undefined)
        {
            _outputArray = variable_clone(_bucket.__spriteNameArray);
        }
        else
        {
            array_resize(_outputArray, 0);
            array_copy(_outputArray, 0, _bucket.__spriteNameArray, 0, array_length(_bucket.__spriteNameArray));
        }
    }
    
    return _outputArray;
}