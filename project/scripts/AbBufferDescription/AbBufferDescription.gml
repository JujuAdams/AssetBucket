/// @param buffer
/// @param offset
/// @param size
/// @param [imageWidth]
/// @param [imageHeight]

function AbBufferDescription(_buffer, _offset, _size, _imageWidth = undefined, _imageHeight = undefined) constructor
{
    buffer      = _buffer;
    offset      = _offset;
    size        = _size;
    imageWidth  = _imageWidth;
    imageHeight = _imageHeight;
}