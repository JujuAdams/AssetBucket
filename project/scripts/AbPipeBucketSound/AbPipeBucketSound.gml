/// The source can be one of the following:
/// - File path as a string (absolute path)
/// - Buffer. The entire buffer will be saved
/// - Struct constructed by `AbFileDescription()`
/// - Struct constructed by `AbBufferDescription()`
/// 
/// @param bucketName
/// @param alias
/// @param source
/// @param [forceFormat]

function AbPipeBucketSound(_bucketName, _alias, _source, _forceFormat = undefined)
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_last(_builderStack);
    if (_builder == undefined)
    {
        __AbError($"Pipeline has not been started with `AbPipeBegin()`");
    }
    
    _builder.__AddSoundToBucket(_bucketName, _alias, _source, _forceFormat);
}