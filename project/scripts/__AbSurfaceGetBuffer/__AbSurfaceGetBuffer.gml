/// @param surface

function __AbSurfaceGetBuffer(_surface)
{
    var _buffer = buffer_create(4*surface_get_width(_surface)*surface_get_height(_surface), buffer_fixed, 1);
    buffer_get_surface(_buffer, _surface, 0);
    return _buffer;
}