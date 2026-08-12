/// Returns an array of texture group names for the given bucket.
/// 
/// @param bucketName
/// @param [outputArray]

function AbBucketTextureGroupsGetArray(_bucketName, _outputArray = undefined)
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