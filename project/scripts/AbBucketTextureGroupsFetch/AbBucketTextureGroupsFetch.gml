/// Fetches all texture groups for a bucket. This is not instant and may take a few frames. Please
/// call `AbBucketTextureGroupsGetFetched()` to check when texture groups have been loaded.
/// 
/// @param bucketName

function AbBucketTextureGroupsFetch(_bucketName)
{
    static _arrayStatic = [];
    
    var _array = AbBucketTextureGroupsGetArray(_bucketName, _arrayStatic);
    var _i = 0;
    repeat(array_length(_array))
    {
        texturegroup_load(_array[_i]);
        ++_i;
    }
}