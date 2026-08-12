/// Returns an array of names of buckets that have been both loadead and fetched.

function AbBucketGetAllFetched()
{
    static _projectBucketMap = __AbSystem().__projectBucketMap
    static _bucketArrayStatic = [];
    static _resultStatic = [];
    
    var _result = _resultStatic;
    var _bucketArray = _bucketArrayStatic;
    
    array_resize(_result, 0);
    array_resize(_bucketArray, 0);
    
    ds_map_values_to_array(_projectBucketMap, _bucketArray);
    
    var _i = 0;
    repeat(array_length(_bucketArray))
    {
        var _bucket = _bucketArray[_i];
        if (_bucket.__fetched)
        {
            array_push(_result, _bucket.__name);
        }
        
        ++_i;
    }
    
    return _result;
}