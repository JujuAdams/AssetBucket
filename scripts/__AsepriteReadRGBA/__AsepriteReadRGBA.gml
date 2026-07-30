/// @param buffer

function __AsepriteReadRGBA(_buffer)
{
    var _red   = buffer_read(_buffer, buffer_u8);
    var _green = buffer_read(_buffer, buffer_u8);
    var _blue  = buffer_read(_buffer, buffer_u8);
    var _alpha = buffer_read(_buffer, buffer_u8);
    
    return (_alpha << 24) | (_blue << 16) | (_green << 8) | _red;
}