/// The constructed struct has the following public read-only variables:
/// `.frameStart`
/// `.xOrigin`
/// `.yOrigin`
/// `.width`
/// `.height`
/// `.xCenter`
/// `.yCenter`
/// `.centerWidth`
/// `.centerHeight`
/// `.xPivot`
/// `.yPivot`

function __AsepriteClassSliceKey() constructor
{
    frameStart   = undefined;
    xOrigin      = undefined;
    yOrigin      = undefined;
    width        = undefined;
    height       = undefined;
    xCenter      = undefined;
    yCenter      = undefined;
    centerWidth  = undefined;
    centerHeight = undefined;
    xPivot       = undefined;
    yPivot       = undefined;
    
    
    static __Deserialize = function(_buffer, _flags)
    {
        frameStart = buffer_read(_buffer, buffer_u32);
        xOrigin    = buffer_read(_buffer, buffer_s32);
        yOrigin    = buffer_read(_buffer, buffer_s32);
        width      = buffer_read(_buffer, buffer_u32);
        height     = buffer_read(_buffer, buffer_u32);
        
        if (_flags & 0b01)
        {
            xCenter      = buffer_read(_buffer, buffer_s32);
            yCenter      = buffer_read(_buffer, buffer_s32);
            centerWidth  = buffer_read(_buffer, buffer_u32);
            centerHeight = buffer_read(_buffer, buffer_u32);
        }
        
        if (_flags & 0b10)
        {
            xPivot = buffer_read(_buffer, buffer_s32);
            yPivot = buffer_read(_buffer, buffer_s32);
        }
        
        return self;
    }
}