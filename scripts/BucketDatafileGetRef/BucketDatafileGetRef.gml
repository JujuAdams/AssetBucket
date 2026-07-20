function BucketDatafileGetRef(_originalPath)
{
    static _system = __BucketSystem();
    static _runtimeBucketMap = _system.__runtimeBucketMap;
    static _result = {};
    
    var _bucket = _runtimeBucketMap[? _system.__manifest.bucketLookup[$ _originalPath]];
    if (not is_struct(_bucket))
    {
        __BucketError($"Bucket not found for path \"{_originalPath}\"");
    }
    
    if (not _bucket.__loaded)
    {
        __BucketError($"Bucket \"{_bucket.__name}\" for path \"{_originalPath}\" not loaded");
    }
    
    with(_result)
    {
        buffer = _bucket.__buffer;
        offset = _bucket.__assetOffsetDict[$ _originalPath];
        size   = _bucket.__assetSizeDict[$ _originalPath];
    }
    
    return _result;
}