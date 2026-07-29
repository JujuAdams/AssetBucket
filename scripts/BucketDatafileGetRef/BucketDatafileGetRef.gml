function AbDatafileGetRef(_originalPath)
{
    static _runtimeAbDatafileMap = __AbSystem().__runtimeBucketDatafileMap;
    return _runtimeAbDatafileMap[? _originalPath];
}