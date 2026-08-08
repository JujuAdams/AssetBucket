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
    
    xPivot = undefined;
    yPivot = undefined;
    
    __bufferArray  = undefined;
    __surfaceArray = undefined;
    
    
    
    
    
    static __Draw = function(_frame, _x, _y)
    {
        var _surface = GetSurface(max(0, _frame) mod array_length(__bufferArray));
        if (surface_exists(_surface))
        {
            draw_surface(_surface, _x, _y);
        }
    }
    
    static __DrawExt = function(_frame, _drawX0, _drawY0, _xScale, _yScale, _angle, _blend, _alpha)
    {
        var _surface = GetSurface(max(0, _frame) mod array_length(__bufferArray));
        if (surface_exists(_surface))
        {
            if (xCenter == undefined) //Not a nineslice
            {
                draw_surface_ext(_surface, _drawX0, _drawY0, _xScale, _yScale, _angle, _blend, _alpha);
            }
            else
            {
                draw_surface_ext(_surface, _drawX0, _drawY0, _xScale, _yScale, _angle, _blend, _alpha);
                
                var _drawW = _xScale*width;
                var _drawH = _yScale*height;
                
                var _surfX0 = xOrigin;
                var _surfX1 = xCenter;
                var _surfX2 = _surfX1 + centerWidth;
                var _surfX3 = xOrigin + width;
                
                var _surfY0 = yOrigin;
                var _surfY1 = yCenter;
                var _surfY2 = _surfY1 + centerHeight;
                var _surfY3 = yOrigin + height;
                
                var _surfW01 = _surfX1 - _surfX0;
                var _surfW12 = _surfX2 - _surfX1;
                var _surfW23 = _surfX3 - _surfX2;
                
                var _surfH01 = _surfY1 - _surfY0;
                var _surfH12 = _surfY2 - _surfY1;
                var _surfH23 = _surfY3 - _surfY2;
                
                var _drawX1 = _drawX0 + _surfW01;
                var _drawX2 = _drawX0 + _drawW - _surfW23;
                
                var _drawY1 = _drawY0 + _surfH01;
                var _drawY2 = _drawY0 + _drawH - _surfH23;
                
                var _scaleX12 = (_drawW - (_surfW01 + _surfW23)) / _surfW12;
                var _scaleY12 = (_drawH - (_surfH01 + _surfH23)) / _surfH12;
                
                //Top-left
                draw_surface_part_ext(_surface, _surfX0, _surfY0, _surfW01, _surfH01, _drawX0, _drawY0, 1, 1, _blend, _alpha);
                
                //Top
                draw_surface_part_ext(_surface, _surfX1, _surfY0, _surfW12, _surfH01, _drawX1, _drawY0, _scaleX12, 1, _blend, _alpha);
                
                //Top-right
                draw_surface_part_ext(_surface, _surfX2, _surfY0, _surfW23, _surfH01, _drawX2, _drawY0, 1, 1, _blend, _alpha);
                
                //Left
                draw_surface_part_ext(_surface, _surfX0, _surfY1, _surfW01, _surfH12, _drawX0, _drawY1, 1, _scaleY12, _blend, _alpha);
                
                //Centre
                draw_surface_part_ext(_surface, _surfX1, _surfY1, _surfW12, _surfH12, _drawX1, _drawY1, _scaleX12, _scaleY12, _blend, _alpha);
                
                //Right
                draw_surface_part_ext(_surface, _surfX2, _surfY1, _surfW23, _surfH12, _drawX2, _drawY1, 1, _scaleY12, _blend, _alpha);
                
                //Bottom-left
                draw_surface_part_ext(_surface, _surfX0, _surfY2, _surfW01, _surfH23, _drawX0, _drawY2, 1, 1, _blend, _alpha);
                
                //Bottom
                draw_surface_part_ext(_surface, _surfX1, _surfY2, _surfW12, _surfH23, _drawX1, _drawY2, _scaleX12, 1, _blend, _alpha);
                
                //Bottom-right
                draw_surface_part_ext(_surface, _surfX2, _surfY2, _surfW23, _surfH23, _drawX2, _drawY2, 1, 1, _blend, _alpha);
            }
        }
    }
    
    static GetBuffer = function(_frame)
    {
        return __bufferArray[_frame];
    }
    
    static GetSurface = function(_frame)
    {
        var _surface = __surfaceArray[_frame];
        if (not surface_exists(_surface))
        {
            _surface = surface_create(width, height);
            
            if (buffer_exists(__bufferArray[_frame]))
            {
                buffer_set_surface(__bufferArray[_frame], _surface, 0);
            }
            else
            {
                surface_set_target(_surface);
                draw_clear_alpha(c_black, 0);
                surface_reset_target();
            }
            
            __surfaceArray[@ _frame] = _surface;
        }
        
        return _surface;
    }
    
    static __Render = function(_frameArray, _canvasWidth, _canvasHeight, _keepSurfaces)
    {
        if (is_array(__bufferArray)) return;
        
        var _pixelWidth  = min(_canvasWidth  - xOrigin, width);
        var _pixelHeight = min(_canvasHeight - yOrigin, height);
        
        var _sliceStride = 4*_pixelWidth;
        var _sliceSize   = 4*_pixelWidth*_pixelHeight;
        var _frameOffset = 4*(xOrigin + _canvasWidth*yOrigin);
        var _lineStride  = 4*_canvasWidth;
        
        __bufferArray  = array_create(array_length(_frameArray), undefined);
        __surfaceArray = array_create(array_length(_frameArray), -1);
        
        var _i = 0;
        repeat(array_length(_frameArray))
        {
            var _sliceBuffer = buffer_create(_sliceSize, buffer_fixed, 1);
            __bufferArray[@ _i] = _sliceBuffer;
            
            var _frameStruct = _frameArray[_i];
            buffer_copy_stride(_frameStruct.buffer, _frameOffset, _sliceStride, _lineStride, _pixelHeight,
                               _sliceBuffer, 0, _sliceStride);
            
            if (_keepSurfaces)
            {
                GetSurface(_i);
            }
            
            ++_i;
        }
    }
    
    static __Destroy = function()
    {
        var _i = 0;
        repeat(array_length(__bufferArray))
        {
            buffer_delete(__bufferArray[_i]);
            
            var _surface = __surfaceArray[_i];
            if (surface_exists(_surface))
            {
                surface_free(_surface);
            }
            
            ++_i;
        }
        
        __bufferArray  = undefined;
        __surfaceArray = undefined;
    }
    
    static __Deserialize = function(_buffer, _flags)
    {
        frameStart = buffer_read(_buffer, buffer_u32);
        xOrigin    = buffer_read(_buffer, buffer_s32);
        yOrigin    = buffer_read(_buffer, buffer_s32);
        width      = buffer_read(_buffer, buffer_u32);
        height     = buffer_read(_buffer, buffer_u32);
        
        if (_flags & 0b01)
        {
            //Nineslice
            xCenter      = buffer_read(_buffer, buffer_s32);
            yCenter      = buffer_read(_buffer, buffer_s32);
            centerWidth  = buffer_read(_buffer, buffer_u32);
            centerHeight = buffer_read(_buffer, buffer_u32);
        }
        
        if (_flags & 0b10)
        {
            //TODO - Custom pivot
            xPivot = buffer_read(_buffer, buffer_s32);
            yPivot = buffer_read(_buffer, buffer_s32);
        }
        
        return self;
    }
}