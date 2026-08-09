/// The source can be one of the following:
/// - File path as a string (absolute path)
/// - Struct constructed by `AbFileDescription()`
/// - Buffer. The entire buffer will be saved
/// - Instance constructed by `AbBufferDescription()`
/// - Surface. The entire surface will be saved
/// - Instance constructed by `AbSurfaceDescription()`
/// 
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