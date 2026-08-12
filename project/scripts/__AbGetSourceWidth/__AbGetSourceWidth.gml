/// @param source
/// @param [cacheSprite=false]

function __AbGetSourceWidth(_source, _cacheSprite = false)
{
    if (is_string(_source))
    {
        var _spriteWidthCacheDict  = __AbSystem().__spriteWidthCacheDict;
        var _spriteHeightCacheDict = __AbSystem().__spriteHeightCacheDict;
        
        var _width = _spriteWidthCacheDict[$ _source];
        if (is_numeric(_width)) return _width;
        
        var _sprite = __AbAddSprite(_source, undefined, undefined, _cacheSprite);
        _spriteWidthCacheDict[$  _source] = sprite_get_width(_sprite);
        _spriteHeightCacheDict[$ _source] = sprite_get_height(_sprite);
        
        return sprite_get_width(_sprite);
    }
    else if (is_handle(_source))
    {
        if (surface_exists(_source))
        {
            return surface_get_width(_source);
        }
        else if (buffer_exists(_source))
        {
            __AbError($"Buffer source type not supported. Please pass a `AbBufferDescription()`");
        }
    }
    else if (is_struct(_source))
    {
        if (is_instanceof(_source, AbBufferDescription))
        {
            if (_source.imageWidth == undefined)
            {
                __AbError($"Buffer description does not have an image width defined");
            }
            else
            {
                return _source.imageWidth;
            }
        }
        else if (is_instanceof(_source, AbSurfaceDescription))
        {
            return _source.width;
        }
    }
    else
    {
        __AbError($"Datatype unsupported as a source ({typeof(_source)})");
    }
}