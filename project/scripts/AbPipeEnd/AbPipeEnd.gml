/// @param [clearSpriteCache=true]

function AbPipeEnd(_clearSpriteCache = true)
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_pop(_builderStack);
    if (_builder == undefined)
    {
        __AbError($"Pipeline has not been started with `AbPipeBegin()`");
    }
    
    _builder.__End();
    
    if (_clearSpriteCache)
    {
        AbClearSpriteCache();
    }
}