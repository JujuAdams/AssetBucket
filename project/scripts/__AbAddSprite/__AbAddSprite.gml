/// @param source
/// @param [hintWidth]
/// @param [hintHeight]
/// @param [cacheSprite=false]

function __AbAddSprite(_source, _hintWidth = undefined, _hintHeight = undefined, _cacheSprite = false)
{
    static _spriteFormatDict = __AbSystem().__spriteFormatDict;
    var _spriteCacheDict = __AbSystem().__spriteCacheDict;
    
    var _sprite = -1;
    
    if (is_handle(_source))
    {
        if (buffer_exists(_source))
        {
            if ((_hintWidth == undefined) || (_hintHeight == undefined))
            {
                __AbError($"Buffer source type not supported without hinted width & height\nPlease hint a width and height or pass a `AbBufferDescription()`");
            }
            else
            {
                var _surface = surface_create(_hintWidth, _hintHeight);
                buffer_set_surface(_source, _surface, 0);
                var _sprite = sprite_create_from_surface(_surface, 0, 0, _hintWidth, _hintHeight, false, false, 0, 0);
                surface_free(_surface);
            }
        }
        else if (surface_exists(_source))
        {
            var _sprite = sprite_create_from_surface(_surface, 0, 0, surface_get_width(_source), surface_get_height(_source), false, false, 0, 0);
        }
        else
        {
            __AbError($"Source type not supported ({typeof(_source)})");
        }
    }
    else if (is_struct(_source))
    {
        if (is_instanceof(_source, AbBufferDescription))
        {
            var _surface = surface_create(_source.imageWidth, _source.imageHeight);
            buffer_set_surface(_source.buffer, _surface, _source.offset);
            var _sprite = sprite_create_from_surface(_surface, 0, 0, _source.imageWidth, _source.imageHeight, false, false, 0, 0);
            surface_free(_surface);
        }
        else if (is_instanceof(_source, AbSurfaceDescription))
        {
            var _sprite = sprite_create_from_surface(_source.surface, _source.left, _source.top, _source.width, _source.height, false, false, 0, 0);
        }
        else
        {
            __AbError($"Source struct not supported ({instanceof(_source)})");
        }
    }
    else if (is_string(_source))
    {
        var _sprite = _spriteCacheDict[$ _source];
        if (not sprite_exists(_sprite))
        {
            var _funcLoad = _spriteFormatDict[$ filename_ext(_source)];
            if (is_callable(_funcLoad))
            {
                _sprite = _funcLoad(_source);
            }
            else
            {
                _sprite = sprite_add(_source, 0, false, false, 0, 0);
            }
            
            if (_cacheSprite)
            {
                _spriteCacheDict[$ _source] = _sprite;
            }
        }
    }
    else
    {
        __AbError($"Source type not supported ({typeof(_source)})");
    }
    
    if (not sprite_exists(_sprite))
    {
        __AbError($"Failed to load \"{_source}\" as a sprite");
    }
    
    return _sprite;
}