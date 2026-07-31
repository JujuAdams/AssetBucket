/// @param bucketName

function AbBucketTextureGroupsGetFetched(_bucketName)
{
    static _arrayStatic = [];
    
    if (not AbBucketGetLoaded(_bucketName))
    {
        return false;
    }
    
    var _array = AbBucketTextureGroupsGetArray(_bucketName, _arrayStatic);
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