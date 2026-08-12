/// Returns the asset handle for a sound from a bucket. The bucket must first have been both
/// loaded and fetched.

function AbBucketSoundGet(_alias)
{
    static _runtimeBucketSoundMap = __AbSystem().__runtimeBucketSoundMap;
    return _runtimeBucketSoundMap[? _alias] ?? -1;
}