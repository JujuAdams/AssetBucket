/// @param buffer
/// @param offset
/// @param size
/// @param [ownsBuffer=false]

function BucketBufferDescription(_buffer, _offset, _size, _ownsBuffer = false) constructor
{
    buffer     = _buffer;
    offset     = _offset;
    size       = _size;
    ownsBuffer = _ownsBuffer;
}