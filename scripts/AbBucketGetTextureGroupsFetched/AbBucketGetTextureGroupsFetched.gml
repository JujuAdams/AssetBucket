/// @param bucketName

function AbBucketGetTextureGroupsFetched(_bucketName)
{
    static _arrayStatic = [];
    
    var _array = AbBucketGetTextureGroups(_bucketName, _arrayStatic);
    var _i = 0;
    repeat(array_length(_array))
    {
        if (texturegroup_get_status(_array[_i]) != texturegroup_status_fetched)
        {
            return false;
        }
        
        ++_i;
    }
    
    return true;
}