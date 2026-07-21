/// @param alias
/// @param [loop=false]

function BucketPlaySound(_alias, _loop = false)
{
    static _system = __BucketSystem();
    static _runtimeBucketMap = _system.__runtimeBucketMap;
    
    var _bucketName = _system.__manifest.bucketLookup[$ _alias];
    var _bucket = _runtimeBucketMap[? _bucketName];
    if (not is_struct(_bucket))
    {
        __BucketError($"Bucket not found for sound \"{_alias}\"");
    }
    
    if (not _bucket.__loaded)
    {
        __BucketError($"Bucket \"{_bucket.__name}\" for sound \"{_alias}\" not loaded");
    }
    
    var _sound = _bucket.__soundsDict[$ _alias];
    if (not audio_exists(_sound))
    {
        __BucketError($"Missing sound for \"{_alias}\" in bucket \"{_bucketName}\"");
    }
    
    return audio_play_sound(_sound, 0, _loop);
}