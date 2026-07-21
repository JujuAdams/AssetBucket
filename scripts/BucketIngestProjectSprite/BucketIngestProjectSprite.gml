/// @param spriteName
/// @param imagePathArray
/// @param projectFolder
/// @param [textureGroup="Default"]
/// @param [metadata]

function BucketIngestProjectSprite(_spriteName, _imagePathArray, _projectFolder, _textureGroup = "Default", _metadata = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestProjectSprite()` outside of a worker function");
    }
    
    _ingestStruct.__QueueProjectOperation(_spriteName, new __BucketClassDeferredFunction(function()
    {
        var _imagePathArray = __BucketEnsureArray(__imagePathArray);
        
        var _rootDirectory = $"{BUCKET_PROJECT_DIRECTORY}{__ingestStruct.__configStruct.__rootDirectory}";
        var _fileInfo = __BucketEnsureIngestFileInfo(_imagePathArray[0]);
        
        __ingestStruct.__RegisterProjectSprite(_imagePathArray[0], __spriteName);
        __ingestStruct.__EnsureProjectFolder(__projectFolder);
        __ingestStruct.__EnsureProjectTextureGroup(__textureGroup);
        
        __BucketCreateYYSprite(_rootDirectory, _imagePathArray,
                               __spriteName, _fileInfo.__GetWidth(), _fileInfo.__GetHeight(),
                               __projectFolder, __textureGroup);
    },
    {
        __ingestStruct:   _ingestStruct,
        __spriteName:     _spriteName,
        __imagePathArray: _imagePathArray,
        __projectFolder:  _projectFolder,
        __textureGroup:   _textureGroup,
        __metadata:       _metadata,
    }));
}