/// @param bucketName

function AbBucketGetStaged(_bucketName)
{
    static _projectBucketMap = __AbSystem().__projectBucketMap
    
    return ds_map_exists(_projectBucketMap, _bucketName);
}