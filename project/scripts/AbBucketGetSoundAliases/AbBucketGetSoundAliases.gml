/// Returns an array of strings which are the aliases for sounds in the bucket. This function will
/// return an empty array is a bucket is not loaded.
/// 
/// @param bucketName
/// @param [outputArray]

function AbBucketGetSoundAliases(_bucketName, _outputArray = undefined)
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
            _outputArray = variable_clone(_bucket.__soundAliasArray);
        }
        else
        {
            array_resize(_outputArray, 0);
            array_copy(_outputArray, 0, _bucket.__soundAliasArray, 0, array_length(_bucket.__soundAliasArray));
        }
    }
    
    return _outputArray;
}