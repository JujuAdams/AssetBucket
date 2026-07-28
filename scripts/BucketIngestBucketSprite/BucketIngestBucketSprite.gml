/// `imageArray` parameter may be an array of one of the following contents:
///     1. A string that is the local path to a PNG image file
///     2. A struct that contains `.buffer` `.offset` `.width` `.height`
/// 
/// @param imageArray
/// @param bucketName
/// @param [alias=sourcePath]
/// @param [textureGroup=bucketName]
/// @param [metadata]

function BucketIngestBucketSprite(_imageArray, _bucketName, _alias = undefined, _textureGroup = _bucketName, _metadata = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestBucketSprite()` outside of a worker function");
    }
    
    _imageArray = __BucketEnsureArray(_imageArray);
    _alias ??= _imageArray[0];
    
    _ingestStruct.__QueueBucketOperation(_alias, new __BucketClassDeferredFunction(function(_ingestStruct)
    {
        static _system = __BucketSystem();
        
        _ingestStruct.__SetBucketMetadata(__alias, __metadata);
        
        var _bucketStruct = _ingestStruct.__bucketDict[$ __bucketName];
        if (_bucketStruct == undefined)
        {
            __BucketError($"Couldn't find bucket with name \"{__bucketName}\"");
        }
        else
        {
            _bucketStruct.__AddSprite(__textureGroup, __imageArray, __alias);
        }
    },
    {
        __imageArray:   _imageArray,
        __bucketName:   _bucketName,
        __alias:        _alias,
        __textureGroup: _textureGroup,
        __metadata:     _metadata,
    }));
}