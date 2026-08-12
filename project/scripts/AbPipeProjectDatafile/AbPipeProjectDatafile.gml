/// The source can be one of the following:
/// - File path as a string (absolute path)
/// - Buffer. The entire buffer will be saved
/// - Surface. The entire surface will be saved
/// - Sprite. Each image in the sprite will be saved as a separate file
/// - Struct constructed by `AbFileDescription()`
/// - Struct constructed by `AbBufferDescription()`
/// - Struct constructed by `AbSurfaceDescription()`
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
    
    _builder.__AddDatafileToProject(_datafilesPath, _source);
}