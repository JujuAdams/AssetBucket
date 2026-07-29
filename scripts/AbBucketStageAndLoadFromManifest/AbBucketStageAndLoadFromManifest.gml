function AbBucketStageAndLoadFromManifest(_path)
{
    var _bucketNameArray = AbBucketStageFromManifest(_path);
    
    var _i = 0;
    repeat(array_length(_bucketNameArray))
    {
        AbBucketLoad(_bucketNameArray[_i]);
        ++_i;
    }
    
    return _bucketNameArray;
}