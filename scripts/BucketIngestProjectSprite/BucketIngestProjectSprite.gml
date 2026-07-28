/// `imageArray` parameter may be an array of one of the following contents:
///     1. A string that is the local path to a PNG image file
///     2. A struct that contains `.buffer` `.offset` `.width` `.height`
/// 
/// @param spriteName
/// @param imageArray
/// @param projectFolder
/// @param [textureGroup="Default"]
/// @param [metadata]

function BucketIngestProjectSprite(_spriteName, _imageArray, _projectFolder, _textureGroup = "Default", _metadata = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestProjectSprite()` outside of a worker function");
    }
    
    _ingestStruct.__QueueProjectOperation(_spriteName, new __BucketClassDeferredFunction(function(_ingestStruct)
    {
        static _system = __BucketSystem();
        
        var _imageArray = __BucketEnsureArray(__imagePathArray);
        
        var _rootDirectory = $"{_system.__currentYYPDirectory}{_ingestStruct.__configStruct.__rootDirectory}";
        
        _ingestStruct.__EnsureProjectSprite(__spriteName);
        _ingestStruct.__EnsureProjectFolder(__projectFolder);
        _ingestStruct.__EnsureProjectTextureGroup(__textureGroup);
        _ingestStruct.__SetAssetMetadata(__spriteName, __metadata);
        
        if (is_struct(_imageArray[0]))
        {
            var _width  = _imageArray[0].width;
            var _height = _imageArray[0].height;
        }
        else
        {
            var _fileInfo = __BucketEnsureIngestFileInfo(_imageArray[0]);
            var _width  = _fileInfo.__GetWidth();
            var _height = _fileInfo.__GetHeight();
        }
        
        __BucketYYWriteSpriteFile(_system.__currentYYPDirectory, BUCKET_PROJECT_NAME,
                                  _rootDirectory, _imageArray,
                                  __spriteName, _width, _height,
                                  __projectFolder, __textureGroup);
    },
    {
        __spriteName:     _spriteName,
        __imagePathArray: _imageArray,
        __projectFolder:  _projectFolder,
        __textureGroup:   _textureGroup,
        __metadata:       _metadata,
    }));
}