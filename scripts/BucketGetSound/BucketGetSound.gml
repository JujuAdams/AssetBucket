function BucketGetSound(_alias)
{
    static _runtimeBucketSoundMap = __BucketSystem().__runtimeBucketSoundMap;
    return _runtimeBucketSoundMap[? _alias];
}