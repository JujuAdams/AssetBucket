/// @param bucketName

function AbBucketFetchTextureGroups(_bucketName)
{
    static _arrayStatic = [];
    
    var _array = AbBucketGetTextureGroups(_bucketName, _arrayStatic);
    var _i = 0;
    repeat(array_length(_array))
    {
        texturegroup_load(_array[_i]);
        ++_i;
    }
}