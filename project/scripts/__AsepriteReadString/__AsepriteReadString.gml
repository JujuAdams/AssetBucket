/// @param buffer

function __AsepriteReadString(_buffer)
{
    var _length = buffer_read(_buffer, buffer_u16);
    var _endPos = buffer_tell(_buffer) + _length;
    var _oldByte = buffer_peek(_buffer, _endPos, buffer_u8);
    buffer_poke(_buffer, _endPos, buffer_u8, 0x00);
    var _string = buffer_read(_buffer, buffer_string);
    buffer_poke(_buffer, _endPos, buffer_u8, _oldByte);
    buffer_seek(_buffer, buffer_seek_relative, -1);
    return _string;
}