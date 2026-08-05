/// @param surface
/// @param [left=0]
/// @param [top=0]
/// @param [width]
/// @param [height]

function AbSurfaceDescription(_surface, _left = 0, _top = 0, _width = undefined, _height = undefined) constructor
{
    surface = _surface;
    left    = _left;
    top     = _top;
    width   = _width  ?? surface_get_width( _surface) - _left;
    height  = _height ?? surface_get_height(_surface) - _top;
}