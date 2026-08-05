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
    }
    else if (is_struct(_source))
    {
        if (is_instanceof(_source, AbBufferDescription))
        {
            //TODO
            //__AbSaveBufferAsPNG(_path, _source, _imageWidth, _imageHeight);
        }
        else if (is_instanceof(_source, AbSurfaceDescription))
        {
            surface_save_part(_source.surface, _path, _source.left, _source.top, _source.width, _source.height);
        }
    }
}