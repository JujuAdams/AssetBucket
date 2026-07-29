function AbGetExists(_bucketName)
{
    static _runtimeBucketMap = __AbSystem().__runtimeBucketMap;
    
    return ds_map_exists(_runtimeBucketMap, _bucketName);
}