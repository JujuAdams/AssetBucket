/// @param surface
/// @param left
/// @param top
/// @param width
/// @param height

function __AbSurfacePartGetBuffer(_surface, _left, _top, _width, _height)
{
    var _surfaceB = surface_create(_width, _height);
    surface_copy_part(_surfaceB, 0, 0, _surface, _left, _top, _width, _height)
    
    var _buffer = buffer_create(4*_width*_height, buffer_fixed, 1);
    buffer_get_surface(_buffer, _surfaceB, 0);
    
    surface_free(_surfaceB);
    
    return _buffer;
}