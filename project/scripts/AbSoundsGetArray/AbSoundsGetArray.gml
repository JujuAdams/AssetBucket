/// @param bucketName
/// @param [outputArray]

function AbSoundsGetArray(_bucketName, _outputArray = undefined)
{
    static _runtimeBucketMap = __AbSystem().__runtimeBucketMap
    
    var _bucket = _runtimeBucketMap[? _bucketName];
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
            _outputArray = variable_clone(_bucket.__soundNameArray);
        }
        else
        {
            array_resize(_outputArray, 0);
            array_copy(_outputArray, 0, _bucket.__soundNameArray, 0, array_length(_bucket.__soundNameArray));
        }
    }
    
    return _outputArray;
}