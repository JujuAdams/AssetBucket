/// @param key
/// @param value

function AbPipeProjectMetadata(_key, _value)
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_last(_builderStack);
    if (_builder == undefined)
    {
        __AbError($"Pipeline has not been started with `AbPipeBegin()`");
    }
    
    _builder.__SetProjectMetadata(_key, _value);
}