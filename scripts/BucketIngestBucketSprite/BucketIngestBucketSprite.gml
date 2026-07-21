/// @param imagePathArray
/// @param bucketName
/// @param [alias=sourcePath]
/// @param [metadata]

function BucketIngestBucketSprite(_imagePathArray, _bucketName, _alias = undefined, _metadata = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestBucketSprite()` outside of a worker function");
    }
    
    _imagePathArray = __BucketEnsureArray(_imagePathArray);
    _alias ??= _imagePathArray[0];
    
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
            var _buffer = buffer_load($"{BUCKET_PROJECT_DIRECTORY}{_ingestStruct.__configStruct.__rootDirectory}{__sourcePath}");
            _bucketStruct.__AddBuffer(__alias, _buffer, 0, buffer_get_size(_buffer));
            buffer_delete(_buffer);
        }
    },
    {
        __alias:          _alias,
        __imagePathArray: _imagePathArray,
        __bucketName:     _bucketName,
        __metadata:       _metadata,
    }));
}