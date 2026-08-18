/// Returns whether a sound with the given alias has been loaded and fetched.

function AbBucketSoundExists(_alias)
{
    static _runtimeBucketSoundMap = __AbSystem().__runtimeBucketSoundMap;
    return ds_map_exists(_runtimeBucketSoundMap, _alias);
}