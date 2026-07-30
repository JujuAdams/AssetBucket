function __AsepriteReadUUID(_buffer)
{
    var _uuidHigh = buffer_read(_buffer, buffer_u64);
    var _uuidLow  = buffer_read(_buffer, buffer_u64);
    return string(ptr(_uuidHigh)) + string(ptr(_uuidLow));
}