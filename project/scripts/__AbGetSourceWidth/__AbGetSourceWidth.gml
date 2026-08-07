function __AbGetSourceWidth(_source)
{
    if (is_string(_source))
    {
        return __AbEnsureIngestFileInfo(_source).__GetWidth();
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