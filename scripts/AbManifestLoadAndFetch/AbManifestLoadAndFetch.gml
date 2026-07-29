function AbManifestLoadAndFetch(_path)
{
    var _bucketArray = AbManifestLoad(_path);
    
    var _i = 0;
    repeat(array_length(_bucketArray))
    {
        _bucketArray[_i].Fetch();
        ++_i;
    }
    
    return _bucketArray;
}