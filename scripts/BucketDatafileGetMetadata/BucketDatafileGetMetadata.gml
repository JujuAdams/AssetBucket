function BucketDatafileGetMetadata(_originalPath)
{
    static _system = __BucketSystem();
    static _runtimeBucketMap = _system.__runtimeBucketMap;
    static _result = {};
    
    var _bucketName = _system.__manifest.bucketLookup[$ _originalPath];
    var _bucket = _runtimeBucketMap[? _bucketName];
    if (not is_struct(_bucket))
    {
        __BucketError($"Bucket not found for path \"{_originalPath}\"");
    }
    
    if (not _bucket.__loaded)
    {
        __BucketError($"Bucket \"{_bucket.__name}\" for path \"{_originalPath}\" not loaded");
    }
    
    var _assetInfo = _bucket.__assetDict[$ _originalPath];
    if (not is_struct(_assetInfo))
    {
        __BucketError($"Missing file metadata for \"{_originalPath}\" in bucket \"{_bucketName}\"");
    }
    
    return _assetInfo[$ "metadata"];
}