/// @param imagePathArray
/// @param bucketName
/// @param [alias=sourcePath]
/// @param [textureGroup=bucketName]
/// @param [metadata]

function BucketIngestBucketSprite(_imagePathArray, _bucketName, _alias = undefined, _textureGroup = _bucketName, _metadata = undefined)
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
            _bucketStruct.__AddSprite(__textureGroup, __imagePathArray, __alias);
        }
    },
    {
        __imagePathArray: _imagePathArray,
        __bucketName:     _bucketName,
        __alias:          _alias,
        __textureGroup:   _textureGroup,
        __metadata:       _metadata,
    }));
}