/// @param bucketName
/// @param [outputArray]

function AbBucketGetTextureGroups(_bucketName, _outputArray = undefined)
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
            _outputArray = variable_clone(_bucket.__textureGroupNameArray);
        }
        else
        {
            array_resize(_outputArray, 0);
            array_copy(_outputArray, 0, _bucket.__textureGroupNameArray, 0, array_length(_bucket.__textureGroupNameArray));
        }
    }
    
    return _outputArray;
}