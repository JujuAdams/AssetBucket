/// @param source
/// @param datafilesPath

function AbPipeProjectDatafile(_source, _datafilesPath)
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_last(_builderStack);
    if (_builder == undefined)
    {
        __AbError($"Pipeline has not been started with `AbPipeBegin()`");
    }
    
    _builder.AddDatafileToProject(_datafilesPath, _source);
}