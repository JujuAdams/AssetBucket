/// The source can be one of the following:
/// - File path as a string (absolute path)
/// - Buffer. The entire buffer will be saved
/// - Surface. The entire surface will be saved
/// - Struct constructed by `AbFileDescription()`
/// - Struct constructed by `AbBufferDescription()`
/// - Struct constructed by `AbSurfaceDescription()`
/// - Sprite. Only the images of the sprite will be used and other information (speed etc.) will
///   not be carried over
/// 
/// @param sourceOrArray
/// @param assetName
/// @param [defaultFolder]
/// @param [width]
/// @param [height]

function AbPipeProjectSprite(_sourceOrArray, _assetName, _defaultFolder = undefined, _width = undefined, _height = undefined)
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_last(_builderStack);
    if (_builder == undefined)
    {
        __AbError($"Pipeline has not been started with `AbPipeBegin()`");
    }
    
    var _sprite = (new __AbClassProjectSprite(_builder.__projectStruct, _assetName)).SetSource(__AbSourceIngest(_sourceOrArray), _width, _height);
    
    if (_defaultFolder != undefined)
    {
        _sprite.SetFolderIfRoot(_defaultFolder)
    }
    
    _builder.__AddSpriteToProject(_sprite);
    
    return _sprite;
}