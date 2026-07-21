/// @param sourcePath
/// @param bucketName
/// @param [compress=false]
/// @param [alias=sourcePath]
/// @param [metadata]

function BucketIngestBucketSound(_sourcePath, _bucketName, _compress = false, _alias = _sourcePath, _metadata = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestBucketSound()` outside of a worker function");
    }
    
    var _fileExtension = filename_ext(_sourcePath);
    if (_fileExtension != ".wav")
    {
        __BucketError($"Audio file extension \"{_fileExtension}\" not supported by `BucketIngestBucketSound()`\nPath was \"{_sourcePath}\"");
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
            var _buffer = buffer_load($"{BUCKET_PROJECT_DIRECTORY}{_ingestStruct.__configStruct.__rootDirectory}{__sourcePath}");
            _bucketStruct.__AddWAV(__sourcePath, __alias, _buffer, 0, __compress);
            buffer_delete(_buffer);
        }
    },
    {
        __alias:      _alias,
        __sourcePath: _sourcePath,
        __compress:   _compress,
        __bucketName: _bucketName,
        __metadata:   _metadata,
    }));
}