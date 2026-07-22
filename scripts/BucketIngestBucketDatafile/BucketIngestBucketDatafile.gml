/// @param sourcePath
/// @param bucketName
/// @param [alias]
/// @param [metadata]

function BucketIngestBucketDatafile(_sourcePath, _bucketName, _alias = _sourcePath, _metadata = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestBucketDatafile()` outside of a worker function");
    }
    
    _ingestStruct.__QueueBucketOperation(_alias, new __BucketClassDeferredFunction(function(_ingestStruct)
    {
        _ingestStruct.__SetBucketMetadata(__alias, __metadata);
        
        var _bucketStruct = _ingestStruct.__bucketDict[$ __bucketName];
        if (_bucketStruct == undefined)
        {
            __BucketError($"Couldn't find bucket with name \"{__bucketName}\"");
        }
        else
        {
            var _buffer = buffer_load($"{BUCKET_PROJECT_DIRECTORY}{_ingestStruct.__configStruct.__rootDirectory}{__sourcePath}");
            _bucketStruct.__AddBuffer(__alias, _buffer, 0, buffer_get_size(_buffer));
            buffer_delete(_buffer);
        }
    },
    {
        __alias:      _alias,
        __sourcePath: _sourcePath,
        __bucketName: _bucketName,
        __metadata:   _metadata,
    }));
}