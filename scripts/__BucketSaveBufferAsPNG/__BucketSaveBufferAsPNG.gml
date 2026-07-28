/// @param filename
/// @param buffer
/// @param width
/// @param height
/// @param [offset=0]

function __BucketSaveBufferAsPNG(_filename, _buffer, _width, _height, _offset = 0)
{
    var _surface = surface_create(_width, _height);
    buffer_set_surface(_buffer, _surface, _offset);
    surface_save(_surface, _filename);
    surface_free(_surface);
}