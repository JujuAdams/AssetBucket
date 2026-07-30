/// @param path

function AbBucketStage(_path)
{
    static _system = __AbSystem();
    with(_system)
    {
        var _bucket = new __AbClassRuntimeBucket(_path);
        
        var _loaded = false;
        var _existingBucket = __projectBucketMap[? _bucket.__name];
        if (is_struct(_existingBucket))
        {
            _loaded = _existingBucket.__loaded;
            _existingBucket.__Destroy();
        }
        
        array_push(__projectBucketArray, _bucket);
        __projectBucketMap[? _bucket.__name] = _bucket;
        
        if (_loaded)
        {
            _bucket.__Load();
        }
    }
    
    return _bucket;
}