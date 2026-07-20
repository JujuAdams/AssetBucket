/// @param spriteName
/// @param imagePathArray
/// @param projectFolder
/// @param [textureGroup="Default"]

function BucketIngestSpriteToProject(_spriteName, _imagePathArray, _projectFolder, _textureGroup = "Default")
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestSpriteToProject()` outside of a worker function");
    }
    
    if (not is_array(_imagePathArray))
    {
        _imagePathArray = [_imagePathArray];
    }
    
    var _rootDirectory = $"{BUCKET_PROJECT_DIRECTORY}{_ingestStruct.__configStruct.__rootDirectory}";
    var _fileInfo = __BucketEnsureIngestFileInfo(_imagePathArray[0]);
    
    _ingestStruct.__RegisterProjectSprite(_imagePathArray[0], _spriteName);
    _ingestStruct.__EnsureProjectFolder(_projectFolder);
    _ingestStruct.__EnsureProjectTextureGroup(_textureGroup);
    
    __BucketCreateYYSprite(_rootDirectory, _imagePathArray,
                           _spriteName, _fileInfo.__GetWidth(), _fileInfo.__GetHeight(),
                           _projectFolder, _textureGroup);
}