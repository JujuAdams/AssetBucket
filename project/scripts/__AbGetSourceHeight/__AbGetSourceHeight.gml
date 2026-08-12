/// @param source
/// @param [cacheSprite=false]

function __AbGetSourceHeight(_source, _cacheSprite = false)
{
    if (is_string(_source))
    {
        var _spriteWidthCacheDict  = __AbSystem().__spriteWidthCacheDict;
        var _spriteHeightCacheDict = __AbSystem().__spriteHeightCacheDict;
        
        var _height = _spriteHeightCacheDict[$ _source];
        if (is_numeric(_height)) return _height;
        
        var _sprite = __AbGetSourceImageAsSprite(_source, undefined, undefined, _cacheSprite);
        var _height = sprite_get_height(_sprite);
        
        _spriteWidthCacheDict[$  _source] = sprite_get_width(_sprite);
        _spriteHeightCacheDict[$ _source] = _height;
        
        if (not AbGetSpriteIsCached(_sprite))
        {
            sprite_delete(_sprite);
        }
        
        return _height;
    }
    else if (is_handle(_source))
    {
        if (surface_exists(_source))
        {
            return surface_get_height(_source);
        }
        else if (buffer_exists(_source))
        {
            __AbError($"Buffer source type not supported. Please pass a `AbBufferDescription()`");
        }
        else if (sprite_exists(_source))
        {
            return sprite_get_height(_source);
        }
        else
        {
            __AbError($"Datatype unsupported as a source ({typeof(_source)})");
        }
    }
    else if (is_struct(_source))
    {
        if (is_instanceof(_source, AbBufferDescription))
        {
            if (_source.imageHeight == undefined)
            {
                __AbError($"Buffer description does not have an image height defined");
            }
            else
            {
                return _source.imageHeight;
            }
        }
        else if (is_instanceof(_source, AbSurfaceDescription))
        {
            return _source.height;
        }
        else if (is_instanceof(_source, __AbClassSpriteImage))
        {
            return sprite_get_height(_source.__sprite);
        }
        else
        {
            __AbError($"Source type unsupported as a source ({instanceof(_source)})");
        }
    }
    else
    {
        __AbError($"Datatype unsupported as a source ({typeof(_source)})");
    }
}