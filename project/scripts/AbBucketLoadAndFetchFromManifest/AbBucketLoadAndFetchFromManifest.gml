/// Loads and fetches all buckets described in the target manifest file.
/// 
/// @param [path=AB_MANIFEST_FILENAME]

function AbBucketLoadAndFetchFromManifest(_path = AB_MANIFEST_FILENAME)
{
    var _bucketNameArray = AbBucketLoadFromManifest(_path);
    
    var _i = 0;
    repeat(array_length(_bucketNameArray))
    {
        AbBucketFetch(_bucketNameArray[_i]);
        ++_i;
    }
    
    return _bucketNameArray;
}