/// The constructed struct has the following public read-only variables:
/// `.name`
/// `.flags`
/// `.keyArray`
/// `.userData`

function __AsepriteClassSlice() constructor
{
    name  = undefined;
    flags = 0x00;
    keyArray = [];
    
    userData = undefined;
    
    static __Deserialize = function(_buffer)
    {
        var _keyCount = buffer_read(_buffer, buffer_u32);
        flags = buffer_read(_buffer, buffer_u32);
        buffer_seek(_buffer, buffer_seek_relative, 4); //Reserved
        name = __AsepriteReadString(_buffer);
        
        array_resize(keyArray, _keyCount);
        var _i = 0;
        repeat(_keyCount)
        {
            keyArray[@ _i] = (new __AsepriteClassSliceKey()).__Deserialize(_buffer, flags);
            ++_i;
        }
        
        return self;
    }
}