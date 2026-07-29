function AbDatafileGetRef(_originalPath)
{
    static _runtimeBucketDatafileMap = __AbSystem().__runtimeBucketDatafileMap;
    return _runtimeBucketDatafileMap[? _originalPath];
}