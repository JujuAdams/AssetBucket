function __AsepriteReadVector(_buffer)
{
    var _count      = buffer_read(_buffer, buffer_u32);
    var _sharedType = buffer_read(_buffer, buffer_u16);
    
    var _array = array_create(_count, undefined);
    
    if (_sharedType != 0x00) //Valid shared type
    {
        var _i = 0;
        repeat(_count)
        {
            _array[@ _i] = __AsepriteReadPropertyValue(_buffer, _sharedType);
            ++_i;
        }
    }
    else
    {
        var _i = 0;
        repeat(_count)
        {
            var _type = buffer_read(_buffer, buffer_u16);
            _array[@ _i] = __AsepriteReadPropertyValue(_buffer, _type);
            ++_i;
        }
    }
    
    return _array;
}