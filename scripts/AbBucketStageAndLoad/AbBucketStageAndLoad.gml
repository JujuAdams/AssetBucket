/// @param path

function AbBucketStageAndLoad(_path)
{
    var _bucket = AbBucketStage(_path);
    _bucket.__Load();
    return _bucket;
}