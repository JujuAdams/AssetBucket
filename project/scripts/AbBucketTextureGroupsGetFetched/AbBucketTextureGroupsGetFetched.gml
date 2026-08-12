/// Returns whether all texture groups for a bucket have been fetched.
/// 
/// @param bucketName

function AbBucketTextureGroupsGetFetched(_bucketName)
{
    static _arrayStatic = [];
    
    if (not AbBucketGetFetched(_bucketName))
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