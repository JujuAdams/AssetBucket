function __AsepriteReadPropertyValue(_buffer, _type)
{
    if (_type == 0x01) //Boolean
    {
        return (buffer_read(_buffer, buffer_u8) != 0);
    }
    else if (_type == 0x02) //Signed 8-bit integer
    {
        return buffer_read(_buffer, buffer_s8);
    }
    else if (_type == 0x03) //Unsigned 8-bit integer
    {
        return buffer_read(_buffer, buffer_u8);
    }
    else if (_type == 0x04) //Signed 16-bit integer
    {
        return buffer_read(_buffer, buffer_s16);
    }
    else if (_type == 0x05) //Unsigned 16-bit integer
    {
        return buffer_read(_buffer, buffer_u16);
    }
    else if (_type == 0x06) //Signed 32-bit integer
    {
        return buffer_read(_buffer, buffer_s32);
    }
    else if (_type == 0x07) //Unsigned 32-bit integer
    {
        return buffer_read(_buffer, buffer_u32);
    }
    else if (_type == 0x08) //Signed 64-bit integer
    {
        return buffer_read(_buffer, buffer_u64); //Not technically supported
    }
    else if (_type == 0x09) //Unsigned 64-bit integer
    {
        return buffer_read(_buffer, buffer_u64);
    }
    else if (_type == 0x0A) //32-bit fixed point
    {
        return __AsepriteReadFixedPoint(_buffer);
    }
    else if (_type == 0x0B) //32-bit floating point
    {
        return buffer_read(_buffer, buffer_f32);
    }
    else if (_type == 0x0C) //64-bit floating point
    {
        return buffer_read(_buffer, buffer_f64);
    }
    else if (_type == 0x0D) //String
    {
        return __AsepriteReadString(_buffer);
    }
    else if (_type == 0x0E) //Point
    {
        var _x = buffer_read(_buffer, buffer_s32);
        var _y = buffer_read(_buffer, buffer_s32);
        return new __AsepriteClassPropertyPoint(_x, _y);
    }
    else if (_type == 0x0F) //Size
    {
        var _width  = buffer_read(_buffer, buffer_s32);
        var _height = buffer_read(_buffer, buffer_s32);
        return new __AsepriteClassPropertySize(_width, _height);
    }
    else if (_type == 0x10) //Rectangle
    {
        var _x      = buffer_read(_buffer, buffer_s32);
        var _y      = buffer_read(_buffer, buffer_s32);
        var _width  = buffer_read(_buffer, buffer_s32);
        var _height = buffer_read(_buffer, buffer_s32);
        return new __AsepriteClassPropertyRectangle(_x, _y, _width, _height);
    }
    else if (_type == 0x11) //Vector
    {
        return __AsepriteReadVector(_buffer);
    }
    else if (_type == 0x12) //Nested property map
    {
        return __AsepriteReadPropertyMap(_buffer);
    }
    else if (_type == 0x13) //UUID
    {
        return __AsepriteReadUUID(_buffer);
    }
    else
    {
        __AsepriteTrace($"Datatype {_type} unhandled");
        return undefined;
    }
}