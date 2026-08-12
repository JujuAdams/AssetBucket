/// Loads data from disk. You must fetch this bucket before its assets are available for use.
/// 
/// @param path

function AbBucketLoad(_path)
{
    static _system = __AbSystem();
    with(_system)
    {
        var _bucket = new __AbClassRuntimeBucket(_path);
        
        var _fetched = false;
        var _existingBucket = __projectBucketMap[? _bucket.__name];
        if (is_struct(_existingBucket))
        {
            _fetched = _existingBucket.__fetched;
            _existingBucket.__Destroy();
        }
        
        array_push(__projectBucketArray, _bucket);
        __projectBucketMap[? _bucket.__name] = _bucket;
        
        if (_fetched)
        {
            _bucket.__Fetch();
        }
    }
    
    return _bucket;
}