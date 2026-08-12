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