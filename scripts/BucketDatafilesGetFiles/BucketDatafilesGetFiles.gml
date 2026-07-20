/// @param bucketName

function BucketDatafilesGetFiles(_bucketName)
{
    static _runtimeBucketMap = __BucketSystem().__runtimeBucketMap;
    
    var _bucket = _runtimeBucketMap[? _bucketName];
    
    if (not is_struct(_bucket))
    {
        __BucketError($"Bucket \"{_bucketName}\" not found");
    }
    
    if (not _bucket.__loaded)
    {
        __BucketError($"Bucket \"{_bucketName}\" not loaded");
    }
    
    return _bucket.__assetArray;
}