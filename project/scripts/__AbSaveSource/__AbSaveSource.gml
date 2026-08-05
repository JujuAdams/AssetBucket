/// @param path
/// @param source

function __AbSaveSource(_source, _path)
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
            buffer_save(_source, _path);
        }
        else if (surface_exists(_source))
        {
            surface_save(_source, _path);
        }
    }
}