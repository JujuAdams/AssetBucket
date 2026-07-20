/// @param alias
/// @param buffer
/// @param offset
/// @param size
/// @param bucketName

function BucketIngestBufferToBucket(_alias, _buffer, _offset, _size, _bucketName)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestDatafileToBucket()` outside of a worker function");
    }
    
    _ingestStruct.__RegisterBucketDatafile(_alias, _bucketName);
    
    var _bucketStruct = _ingestStruct.__bucketDict[$ _bucketName];
    if (_bucketStruct == undefined)
    {
        __BucketError($"Couldn't find bucket with name \"{_bucketName}\"");
    }
    else
    {
        _bucketStruct.__AddBuffer(_alias, _buffer, _offset, _size);
    }
}