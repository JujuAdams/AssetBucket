function BucketGetExists(_bucketName)
{
    static _runtimeBucketMap = __BucketSystem().__runtimeBucketMap;
    
    return ds_map_exists(_runtimeBucketMap, _bucketName);
}