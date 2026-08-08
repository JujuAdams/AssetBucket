/// @param source
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
    
    var _sprite = _builder.__projectStruct.MakeSprite(_assetName).SetSource(_sourceOrArray, _width, _height);
    
    if (_defaultFolder != undefined)
    {
        _sprite.SetFolderIfRoot(_defaultFolder)
    }
    
    _builder.AddSpriteToProject(_sprite);
    
    return _sprite;
}