/// @param callback
/// @param [callbackMetadata]

function AbPipeCallbackOnEnd(_callback, _callbackMetadata = undefined)
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_last(_builderStack);
    if (_builder == undefined)
    {
        __AbError($"Pipeline has not been started with `AbPipeBegin()`");
    }
    
    _builder.__AddCallbackOnEnd(_callback, _callbackMetadata);
}