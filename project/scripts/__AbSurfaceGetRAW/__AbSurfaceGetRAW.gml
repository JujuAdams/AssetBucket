/// @param surface

function __AbSurfaceGetRAW(_surface)
{
    var _buffer = buffer_create(16 + 4*surface_get_width(_surface)*surface_get_height(_surface), buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, "RAW ");
    buffer_write(_buffer, buffer_s32,  surface_get_width(_surface));
    buffer_write(_buffer, buffer_s32,  surface_get_height(_surface));
    buffer_write(_buffer, buffer_s32,  0x00);
    buffer_get_surface(_buffer, _surface, 16);
    return _buffer;
}