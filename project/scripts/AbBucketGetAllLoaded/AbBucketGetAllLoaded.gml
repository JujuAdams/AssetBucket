function AbBucketGetAllLoaded()
{
    static _projectBucketMap = __AbSystem().__projectBucketMap
    static _result = [];
    
    array_resize(_result, 0);
    ds_map_keys_to_array(_projectBucketMap, _result);
    
    return _result;
}