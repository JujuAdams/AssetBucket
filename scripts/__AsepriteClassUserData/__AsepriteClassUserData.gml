/// The constructed struct has the following public read-only variables:
/// `.name`
/// `.color`
/// `.propertyMaps`

function __AsepriteClassUserData() constructor
{
    name         = undefined;
    color        = 0xFF000000;
    propertyMaps = [];
    
    static __Deserialize = function(_buffer)
    {
        var _flags = buffer_read(_buffer, buffer_u32);
        if (_flags & 0b001)
        {
            name = __AsepriteReadString(_buffer);
        }
        
        if (_flags & 0b010)
        {
            color = __AsepriteReadRGBA(_buffer);
        }
        
        if (_flags & 0b100)
        {
            var _mapStart = buffer_tell(_buffer);
            var _mapSize  = buffer_read(_buffer, buffer_u32);
            
            var _mapCount = buffer_read(_buffer, buffer_u32);
            propertyMaps = array_create(_mapCount, undefined);
            
            var _i = 0;
            repeat(_mapCount)
            {
                //TODO - What does this do?
                var _propertyMapsKey = buffer_read(_buffer, buffer_u32);
                
                propertyMaps[@ _i] = __AsepriteReadPropertyMap(_buffer);
                ++_i;
            }
        }
        
        return self;
    }
}