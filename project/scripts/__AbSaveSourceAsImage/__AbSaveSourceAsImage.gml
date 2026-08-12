/// @param path
/// @param source
/// @param imageWidth
/// @param imageHeight

function __AbSaveSourceAsImage(_source, _path, _imageWidth, _imageHeight)
{
    if (is_string(_source))
    {
        if (_source != _path)
        {
            file_copy(_source, _path);
        }
    }
    else if (is_handle(_source))
    {
        if (buffer_exists(_source))
        {
            __AbSaveBufferAsPNG(_path, _source, _imageWidth, _imageHeight);
        }
        else if (surface_exists(_source))
        {
            surface_save(_source, _path);
        }
        else if (sprite_exists(_source))
        {
            sprite_save(_source, 0, _path);
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
            if ((_source.imageWidth == undefined) || (_source.imageHeight == undefined))
            {
                __AbError($"Buffer description does not have an image width/height defined");
            }
            else
            {
                __AbSaveBufferAsPNG(_path, _source.buffer, _source.imageWidth, _source.imageHeight, _source.offset);
            }
        }
        else if (is_instanceof(_source, AbSurfaceDescription))
        {
            surface_save_part(_source.surface, _path, _source.left, _source.top, _source.width, _source.height);
        }
        else if (is_instanceof(_source, __AbClassSpriteImage))
        {
            var _extension = filename_ext(_path);
            var _basePath = filename_change_ext(_path, "");
            sprite_save(_source.__sprite, _source.__image, $"{_basePath}_image{_source.__image}{_extension}");
        }
        else
        {
            __AbError($"Struct type unsupported as a source (was {instanceof(_source)})");
        }
    }
    else
    {
        __AbError($"Datatype unsupported as a source ({typeof(_source)})");
    }
}