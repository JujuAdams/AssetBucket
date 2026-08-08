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
    
    
    
    static Draw = function(_frame, _x, _y)
    {
        return keyArray[0].__Draw(_frame, _x, _y);
    }
    
    static DrawExt = function(_frame, _x, _y, _xScale, _yScale, _angle, _blend, _alpha)
    {
        return keyArray[0].__DrawExt(_frame, _x, _y, _xScale, _yScale, _angle, _blend, _alpha);
    }
    
    static GetBuffer = function(_frame)
    {
        return keyArray[0].GetBuffer(_frame);
    }
    
    static GetSurface = function(_frame)
    {
        return keyArray[0].GetSurface(_frame);
    }
    
    static __Render = function(_frameArray, _canvasWidth, _canvasHeight, _keepSurfaces)
    {
        var _i = 0;
        repeat(array_length(keyArray))
        {
            keyArray[_i].__Render(_frameArray, _canvasWidth, _canvasHeight, _keepSurfaces);
            ++_i;
        }
    }
    
    static __Destroy = function()
    {
        var _i = 0;
        repeat(array_length(keyArray))
        {
            keyArray[@ _i].__Destroy();
            ++_i;
        }
    }
    
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