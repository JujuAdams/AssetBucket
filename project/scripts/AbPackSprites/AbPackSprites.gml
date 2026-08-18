/// Packs sprites from an array of structs created by `AbPackableSprite()`. Please see
/// documentation for `AbPackableSprite()` for more information on what properties are available.
/// The two optional parameters `textureSize` and `imageBorder` control respectively the maximum
/// texture page size and the spacing between individual images on each texture page.
/// 
/// This function will return a struct. What struct is returned depends on what the `returnBuffers`
/// parameter is set to:
/// 
/// `returnBuffers` = `true`:
///   The struct returned will contain `.bufferArray`, which contains an array of RAW-formatted
///   buffers that represent individual texture pages, and `.description` which contains the
///   description struct required by `texturegroup_add()`.
/// 
/// `returnBuffers` = `false`:
///   The struct returned will contain `.surfaceArray`, which contains an array of surfaces that
///   represent individual texture pages, and `.description` which contains the description struct
///   required by `texturegroup_add()`.
/// 
/// The struct that this function returns can be easily submitted to `texturegroup_add()` to load
/// the textures and sprites:
/// 
/// `returnBuffers` = `true`:
///   
///   packedSprites = AbPackSprites(_packableSpriteArray, true);
///   texturegroup_add("groupName", packedSprites.bufferArray, packedSprites.description);
/// 
/// `returnBuffers` = `false`:
///   
///   packedSprites = AbPackSprites(_packableSpriteArray, false);
///   texturegroup_add("groupName", packedSprites.surfaceArray, packedSprites.description);
/// 
/// @param packableSpriteArray
/// @param returnBuffers
/// @param [textureSize=2048]
/// @param [imageBorder=2]

function AbPackSprites(_packableSpriteArray, _returnBuffers, _textureSize = 2048, _imageBorder = 2)
{
    var _packResult = __AbPackSpritesInner(_packableSpriteArray, _textureSize, _imageBorder);
    
    if (not _returnBuffers)
    {
        return _packResult;
    }
    else
    {
        var _bufferArray = [];
        
        var _surfaceArray = _packResult.surfaceArray;
        var _i = 0;
        repeat(array_length(_surfaceArray))
        {
            var _surface = _surfaceArray[_i];
            array_push(_bufferArray, __AbSurfaceGetRAW(_surface));
            surface_free(_surface);
            ++_i;
        }
        
        return {
            bufferArray: _bufferArray,
            description: _packResult.description,
        }
    }
}