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
        
        var _sprite = __AbAddSprite(_source, undefined, undefined, _cacheSprite);
        _spriteWidthCacheDict[$  _source] = sprite_get_width(_sprite);
        _spriteHeightCacheDict[$ _source] = sprite_get_height(_sprite);
        
        return sprite_get_height(_sprite);
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
    }
    else
    {
        __AbError($"Datatype unsupported as a source ({typeof(_source)})");
    }
}