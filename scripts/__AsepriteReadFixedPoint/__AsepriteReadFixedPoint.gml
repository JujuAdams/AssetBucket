function __AsepriteReadFixedPoint(_buffer)
{
    return buffer_read(_buffer, buffer_s32) / 32768; //TODO - Is this correct?
}