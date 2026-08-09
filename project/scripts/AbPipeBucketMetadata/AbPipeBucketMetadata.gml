/// @param bucketName
/// @param key
/// @param value

function AbPipeBucketMetadata(_bucketName, _key, _value)
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_last(_builderStack);
    if (_builder == undefined)
    {
        __AbError($"Pipeline has not been started with `AbPipeBegin()`");
    }
    
    _builder.SetBucketMetadata(_bucketName, _key, _value);
}