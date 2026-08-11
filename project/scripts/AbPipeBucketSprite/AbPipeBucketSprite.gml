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
    
    var _bucketSprite = new AbSpriteDescription(_assetName, _sourceOrArray, _width, _height);
    _builder.__AddSpriteToBucket(_bucketName, _bucketSprite);
    
    return _bucketSprite;
}