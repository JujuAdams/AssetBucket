function AbSoundGet(_alias)
{
    static _runtimeBucketSoundMap = __AbSystem().__runtimeBucketSoundMap;
    return _runtimeBucketSoundMap[? _alias] ?? -1;
}