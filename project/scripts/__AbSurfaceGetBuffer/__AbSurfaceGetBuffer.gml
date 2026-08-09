/// @param surface

function __AbSurfaceGetBuffer(_surface)
{
    var _width  = surface_get_width(_surface);
    var _height = surface_get_height(_surface);
    
    var _buffer = buffer_create(4*_width*_height, buffer_fixed, 1);
    buffer_get_surface(_buffer, _surface, 0);
    
    return _buffer;
}