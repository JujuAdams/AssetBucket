/// The source can be one of the following:
/// - File path as a string (absolute path)
/// - Buffer. The entire buffer will be added
/// - Surface. The entire surface will be added
/// - Sprite. Each image will be added separately
/// - Struct constructed by `AbFileDescription()`
/// - Struct constructed by `AbBufferDescription()`
/// - Struct constructed by `AbSurfaceDescription()`
/// 
/// @param bucketName
/// @param alias
/// @param source

function AbPipeBucketDatafile(_bucketName, _alias, _source)
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_last(_builderStack);
    if (_builder == undefined)
    {
        __AbError($"Pipeline has not been started with `AbPipeBegin()`");
    }
    
    _builder.__AddDatafileToBucket(_bucketName, _alias, _source);
}