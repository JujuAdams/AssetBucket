function __AsepriteReadPropertyMap(_buffer)
{
    var _propertyDict = {};
    
    var _propertyCount = buffer_read(_buffer, buffer_u32);
    var _j = 0;
    repeat(_propertyCount)
    {
        var _name = __AsepriteReadString(_buffer);
        var _type = buffer_read(_buffer, buffer_u16);
        _propertyDict[$ _name] = __AsepriteReadPropertyValue(_buffer, _type);
        ++_j;
    }
    
    return _propertyDict;
}