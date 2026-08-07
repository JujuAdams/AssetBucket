function __AbGetSourceHeight(_source)
{
    if (is_string(_source))
    {
        return __AbEnsureIngestFileInfo(_source).__GetHeight();
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