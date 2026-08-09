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