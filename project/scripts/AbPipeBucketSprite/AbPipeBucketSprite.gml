/// The source can be one of the following:
/// - File path as a string (absolute path)
/// - Buffer. The entire buffer will be saved
/// - Surface. The entire surface will be saved
/// - Struct constructed by `AbFileDescription()`
/// - Struct constructed by `AbBufferDescription()`
/// - Struct constructed by `AbSurfaceDescription()`
/// - Sprite. Only the images of the source sprite will be used and other information (peed etc.)
///   will not be carried over
/// 
/// @param bucketName
/// @param assetName
/// @param sourceOrArray
/// @param [width]
/// @param [height]

function AbPipeBucketSprite(_bucketName, _assetName, _sourceOrArray, _width = undefined, _height = undefined)
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_last(_builderStack);
    if (_builder == undefined)
    {
        __AbError($"Pipeline has not been started with `AbPipeBegin()`");
    }
    
    var _packableSprite = new AbPackableSprite(_assetName, __AbSourceIngest(_sourceOrArray), _width, _height);
    _builder.__AddSpriteToBucket(_bucketName, _packableSprite);
    
    return _packableSprite;
}