/// @param alias

// TODO - Optimise

function BucketGetSprite(_alias)
{
    static _system = __BucketSystem();
    static _runtimeBucketMap = _system.__runtimeBucketMap;
    
    var _bucketName = _system.__manifest.bucketLookup[$ _alias];
    var _bucket = _runtimeBucketMap[? _bucketName];
    if (not is_struct(_bucket))
    {
        __BucketError($"Bucket not found for sprite \"{_alias}\"");
    }
    
    if (not _bucket.__loaded)
    {
        __BucketError($"Bucket \"{_bucket.__name}\" for sprite \"{_alias}\" not loaded");
    }
    
    var _sprite = _bucket.__spriteDict[$ _alias];
    if (not sprite_exists(_sprite))
    {
        __BucketError($"Missing sprite for \"{_alias}\" in bucket \"{_bucketName}\"");
    }
    
    return _sprite;
}