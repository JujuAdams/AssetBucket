/// @param source
/// @param assetName
/// @param [defaultFolder]
/// @param [compression]

function AbPipeProjectSound(_source, _assetName, _defaultFolder = undefined, _compression = undefined)
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_last(_builderStack);
    if (_builder == undefined)
    {
        __AbError($"Pipeline has not been started with `AbPipeBegin()`");
    }
    
    var _sound = _builder.__projectStruct.MakeSound(_assetName).SetSource(_source, _compression);
    
    if (_defaultFolder != undefined)
    {
        _sound.SetFolderIfRoot(_defaultFolder)
    }
    
    _builder.AddSoundToProject(_sound);
    
    return _sound;
}