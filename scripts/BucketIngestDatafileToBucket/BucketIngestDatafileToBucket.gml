/// @param path
/// @param bucketName

function BucketIngestDatafileToBucket(_path, _bucketName)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestDatafileToBucket()` outside of a worker function");
    }
    
    _ingestStruct.__RegisterBucketDatafile(_path, _bucketName);
    
    var _bucketStruct = _ingestStruct.__bucketDict[$ _bucketName];
    if (_bucketStruct == undefined)
    {
        __BucketError($"Couldn't find bucket with name \"{_bucketName}\"");
    }
    else
    {
        _bucketStruct.__AddFile(_path);
    }
}