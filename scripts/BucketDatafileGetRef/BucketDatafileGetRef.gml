function BucketDatafileGetRef(_originalPath)
{
    static _runtimeBucketDatafileMap = __BucketSystem().__runtimeBucketDatafileMap;
    return _runtimeBucketDatafileMap[? _originalPath];
}