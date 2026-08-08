/// @param path

function AbBucketLoadAndFetch(_path)
{
    var _bucket = AbBucketLoad(_path);
    _bucket.__Fetch();
    return _bucket;
}