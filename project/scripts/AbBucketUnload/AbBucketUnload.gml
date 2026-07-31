/// @param bucketName

function AbBucketUnload(_bucketName)
{
    static _projectBucketMap = __AbSystem().__projectBucketMap;
    
    var _bucket = _projectBucketMap[? _bucketName];
    if (_bucket != undefined)
    {
        _bucket.__Unload();
    }
}