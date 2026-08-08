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
    
    _builder.AddDatafileToBucket(_bucketName, _alias, _source);
}