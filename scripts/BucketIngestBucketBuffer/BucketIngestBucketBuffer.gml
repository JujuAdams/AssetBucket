/// @param alias
/// @param buffer
/// @param offset
/// @param size
/// @param bucketName
/// @param [metadata]

function BucketIngestBucketBuffer(_alias, _buffer, _offset, _size, _bucketName, _metadata = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestBucketDatafile()` outside of a worker function");
    }
    
    _ingestStruct.__QueueBucketOperation(_alias, new __BucketClassDeferredFunction(function(_ingestStruct)
    {
        _ingestStruct.__RegisterBucketDatafile(__alias, __bucketName);
        _ingestStruct.__SetBucketMetadata(__alias, __metadata);
        
        var _bucketStruct = _ingestStruct.__bucketDict[$ __bucketName];
        if (_bucketStruct == undefined)
        {
            __BucketError($"Couldn't find bucket with name \"{__bucketName}\"");
        }
        else
        {
            _bucketStruct.__AddBuffer(__alias, __buffer, __offset, __size);
        }
    },
    {
        __alias:      _alias,
        __buffer:     _buffer,
        __offset:     _offset,
        __size:       _size,
        __bucketName: _bucketName,
        __metadata:   _metadata,
    }));
}