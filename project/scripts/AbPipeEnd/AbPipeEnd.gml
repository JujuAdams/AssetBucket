function AbPipeEnd()
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_pop(_builderStack);
    if (_builder == undefined)
    {
        __AbError($"Pipeline has not been started with `AbPipeBegin()`");
    }
    
    _builder.__End();
}