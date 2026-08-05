/// N.B. You *must* call the `.Destroy()` method when an Aseprite file is no longer in use. This
///      will free memory associated with the Aseprite file (which can be quite a lot).
///
/// This parser is based on the official Aseprite file specification:
///     https://github.com/aseprite/aseprite/blob/main/docs/ase-file-specs.md
///
///
///
/// The constructed struct has the following public methods:
/// 
/// `.Destroy()`
///     You *must* call this function when an Aseprite file is no longer in use. This will free
///     memory associated with the Aseprite file (which can be quite a lot).
/// 
/// `.HideLayersByMask(mask)`
///     Hides layers whose name first the string mask provided. The string mask should use `*` as a
///     wildcard character e.g. `"*[ignore]` will hide all layers whose name ends in exactly
///     `"[ignore]"`. This is useful to ensure guide layers etc. aren't drawn. You should call this
///     function before `.Render()`. You may not dynamically toggle layers and once `.Render()` has
///     been called, the layers that are visible will be baked.
/// 
/// `.DeleteTagsByMask(mask)`
///     Deletes tags whose name first the string mask provided. The string mask should use `*` as a
///     wildcard character e.g. `"*[ignore]` will hide all tags whose name ends in exactly
///     `"[ignore]"`.
/// 
/// `.Render([keepSurfaces=true])`
///     Processes all the raw buffer data for the Aseprite file, generating raw ABGR buffers that
///     can be used to generate surfaces for drawing. This method must be called before drawing or
///     saving images from the Aseprite file.
/// 
/// `.Draw(frame, x, y)`
///     N.B. You must call `.Render()` before calling this method.
///     
///     Draws the given frame. The frame number should be greater than or equal to zero. If a frame
///     number is larger than the total number of frames in the Aseprite file then the frame number
///     will wrap around.
/// 
/// `.DrawExt(frame, x, y, xScale, yScale, angle, blend, alpha)`
///     N.B. You must call `.Render()` before calling this method.
///     
///     As above but with extra scaling options.
/// 
/// `.DrawTag(tagName, frame, x, y)`
///     N.B. You must call `.Render()` before calling this method.
///     
///     Draws a frame from the given tag.
/// 
/// `.DrawTagExt(tagName, frame, x, y, xScale, yScale, angle, blend, alpha)`
///     N.B. You must call `.Render()` before calling this method.
///     
///     As above but with extra scaling options.
/// 
/// `.DrawSlice(sliceName, frame, x, y)`
///     N.B. You must call `.Render()` before calling this method.
///     
///     Draws the given frame using a slice.
/// 
/// `.DrawSliceExt(sliceName, frame, x, y, xScale, yScale, blend, alpha)`
///     N.B. You must call `.Render()` before calling this method.
///     
///     As above but with extra scaling options.
/// 
/// `.GetTagFrames(tagName)`
///     Returns an array frame structs for the given tag name. If the tag does not exist, this
///     function will return an empty array. Elements in the returned array will be structs that
///     are instances of `__AsepriteClassFrame()`.
/// 
/// `.SaveAllFrames(pathPattern)`
///     N.B. You must call `.Render()` before calling this method.
///     
///     Saves all frames from the Aseprite file as PNGs to the given path. The path pattern may
///     the `#` character to indicate where the frame number should be inserted e.g. the pattern
///     `"run_#.png"` will export files `"run_0.png"`, `"run_1.png"` etc.
/// 
/// `.SaveTag(tagName, pathPattern)`
///     N.B. You must call `.Render()` before calling this method.
///     
///     Saves all frames for the tag as PNGs to the given path. The path pattern works as above.
/// 
/// 
///
/// The constructed struct has the following public read-only variables:
/// 
/// `.width` `.height`
///     Width and height of the canvas in pixels. Unless the artist has used slices, this is the
///     overall size of the sprite.
/// 
/// `.layerArray`
///     Array of structs that have been constructed by `__AsepriteClassLayer`.
/// 
/// `.tagArray`
///     Array of structs that have been constructed by `__AsepriteClassTag`.
/// 
/// `.tagDict`
///     Struct (dictionary) of structs that have been constructed by `__AsepriteClassTag`. The key
///     used for each element is the name of the tag.
/// 
/// `.sliceArray`
///     Array of structs that have been constructed by `__AsepriteClassSlice`.
/// 
/// `.frameArray`
///     Array of structs that have been constructed by `__AsepriteClassFrame`.
/// 
/// `.paletteArray`
///     Array of ABGR colours (32-bit). These correspond to the palette define in the Aseprite
///     file. This array always has 256 entries. Any unused palette slot has the colour 0x00000000
///     (fully transparent and black).
/// 
/// `.paletteNameArray`
///     Array of strings. Each element of this array corresponds to a palette colour in the array
///     above. If a palette colour has no name, this array will contain `undefined`.
/// 
/// `.colorProfile`
///     A struct. This contains information regarding the colour profile used to author the sprite.
///     The colour profile does not affect images generated by the library at this time but the
///     data is available if you'd like to implemented that yourself.
/// 
/// `.pixelRatio`
///     The ratio between the width and height of pixels. This feature is not implemented.
/// 
/// `.gridEnabled` `.gridX` `.gridY` `.gridWidth` `.gridHeight`
///     Information regarding the Aseprite grid. This does not affect rendering.
/// 
/// `.colorDepth`
///     The original colour depth of the Aseprite file: `32` for full colour, `16` for greyscale
///     with transparency, and `8` for palettized colours. This value is provided for your own
///     information: once you call `.Render()`, the file is rendered down to ABGR colours on native
///     GameMaker surfaces.
/// 
/// `.userData`
///     Extra data attached to the file. This can be any data type, or `undefined` if no data
///     exists.

function __AsepriteClassFile() constructor
{
    static _system = __AsepriteSystem();
    
    width  = undefined;
    height = undefined;
    
    colorProfile = {
        type: 1, //Default to sRGB
        flags: 0,
        fixedGamma: 1, //Linear sRGB
    };
    
    layerArray   = [];
    tagDict      = {};
    tagArray     = [];
    sliceArray   = [];
    sliceDict    = {};
    frameArray   = [];
    tilesetArray = [];
    tilesetDict  = {};
    
    paletteArray     = array_create(256, 0x00000000);
    paletteNameArray = array_create(256, undefined);
    
    colorDepth = undefined;
    pixelRatio = 1;
    
    userData = undefined;
    
    gridEnabled = false;
    gridX       = 0;
    gridY       = 0;
    gridWidth   = 0;
    gridHeight  = 0;
    
    __hasUUIDs       = false;
    __linkedCelArray = [];
    
    
    
    static Draw = function(_frame, _x, _y)
    {
        frameArray[max(0, _frame) mod array_length(frameArray)].Draw(_x, _y);
    }
    
    static DrawTag = function(_tagName, _frame, _x, _y)
    {
        with(tagDict[$ _tagName])
        {
            other.Draw((_frame mod (1 + toFrame - fromFrame)) + fromFrame, _x, _y);
        }
    }
    
    static DrawSlice = function(_sliceName, _frame, _x, _y)
    {
        var _sliceStruct = sliceDict[$ _sliceName];
        if (_sliceStruct == undefined)
        {
            __AsepriteError($"Slice \"{_sliceName}\" not found");
        }
        
        var _frameStruct = frameArray[max(0, _frame) mod array_length(frameArray)];
        if (_sliceStruct.flags & 0b01)
        {
            with(_sliceStruct.keyArray[0])
            {
                _frameStruct.DrawPart(xOrigin, yOrigin, width, height, _x, _y);
            }
        }
        else
        {
            with(_sliceStruct.keyArray[0])
            {
                _frameStruct.DrawPart(xOrigin, yOrigin, width, height, _x, _y);
            }
        }
    }
    
    static DrawExt = function(_frame, _x, _y, _xScale, _yScale, _angle, _blend, _alpha)
    {
        frameArray[max(0, _frame) mod array_length(frameArray)].DrawExt(_x, _y, _xScale, _yScale, _angle, _blend, _alpha);
    }
    
    static DrawTagExt = function(_tagName, _frame, _x, _y, _xScale, _yScale, _angle, _blend, _alpha)
    {
        with(tagDict[$ _tagName])
        {
            other.DrawExt((_frame mod (1 + toFrame - fromFrame)) + fromFrame, _x, _y, _xScale, _yScale, _angle, _blend, _alpha);
        }
    }
    
    static DrawSliceExt = function(_sliceName, _frame, _drawX0, _drawY0, _xScale, _yScale, _blend, _alpha)
    {
        var _sliceStruct = sliceDict[$ _sliceName];
        if (_sliceStruct == undefined)
        {
            __AsepriteError($"Slice \"{_sliceName}\" not found");
        }
        
        var _frameStruct = frameArray[max(0, _frame) mod array_length(frameArray)];
        if (_sliceStruct.flags & 0b01)
        {
            with(_sliceStruct.keyArray[0])
            {
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
                _frameStruct.DrawPartExt(_surfX0, _surfY0, _surfW01, _surfH01, _drawX0, _drawY0, 1, 1, _blend, _alpha);
                
                //Top
                _frameStruct.DrawPartExt(_surfX1, _surfY0, _surfW12, _surfH01, _drawX1, _drawY0, _scaleX12, 1, _blend, _alpha);
                
                //Top-right
                _frameStruct.DrawPartExt(_surfX2, _surfY0, _surfW23, _surfH01, _drawX2, _drawY0, 1, 1, _blend, _alpha);
                
                //Left
                _frameStruct.DrawPartExt(_surfX0, _surfY1, _surfW01, _surfH12, _drawX0, _drawY1, 1, _scaleY12, _blend, _alpha);
                
                //Centre
                _frameStruct.DrawPartExt(_surfX1, _surfY1, _surfW12, _surfH12, _drawX1, _drawY1, _scaleX12, _scaleY12, _blend, _alpha);
                
                //Right
                _frameStruct.DrawPartExt(_surfX2, _surfY1, _surfW23, _surfH12, _drawX2, _drawY1, 1, _scaleY12, _blend, _alpha);
                
                //Bottom-left
                _frameStruct.DrawPartExt(_surfX0, _surfY2, _surfW01, _surfH23, _drawX0, _drawY2, 1, 1, _blend, _alpha);
                
                //Bottom
                _frameStruct.DrawPartExt(_surfX1, _surfY2, _surfW12, _surfH23, _drawX1, _drawY2, _scaleX12, 1, _blend, _alpha);
                
                //Bottom-right
                _frameStruct.DrawPartExt(_surfX2, _surfY2, _surfW23, _surfH23, _drawX2, _drawY2, 1, 1, _blend, _alpha);
            }
        }
        else
        {
            with(_sliceStruct.keyArray[0])
            {
                _frameStruct.DrawPartExt(xOrigin, yOrigin, width, height, _drawX0, _drawY0, _xScale, _yScale, _blend, _alpha);
            }
        }
    }
    
    static HideLayersByMask = function(_mask)
    {
        var _layerArray = layerArray;
        var _i = array_length(_layerArray)-1;
        repeat(array_length(_layerArray))
        {
            if (__AsepriteTestStringMask(_layerArray[_i].name, _mask))
            {
                _layerArray[_i].Hide();
            }
            
            --_i;
        }
        
        return self;
    }
    
    static ShowLayersByMask = function(_mask)
    {
        var _layerArray = layerArray;
        var _i = array_length(_layerArray)-1;
        repeat(array_length(_layerArray))
        {
            if (__AsepriteTestStringMask(_layerArray[_i].name, _mask))
            {
                _layerArray[_i].Show();
            }
            
            --_i;
        }
        
        return self;
    }
    
    static DeleteTagsByMask = function(_mask)
    {
        var _tagArray = tagArray;
        
        var _i = array_length(_tagArray)-1;
        repeat(array_length(_tagArray))
        {
            if (__AsepriteTestStringMask(_tagArray[_i].name, _mask))
            {
                array_delete(_tagArray, _i, 1);
            }
            
            --_i;
        }
        
        return self;
    }
    
    static GetTagFrames = function(_tagName)
    {
        var _output = [];
        
        var _tagStruct = tagDict[$ _tagName];
        if (_tagStruct == undefined)
        {
            __AsepriteTrace($"Tag \"{_tagName}\" not recognized");
            return _output;
        }
        
        var _i = _tagStruct.fromFrame;
        repeat(1 + _tagStruct.toFrame - _i)
        {
            array_push(_output, frameArray[_i]);
            ++_i;
        }
        
        return _output;
    }
    
    static Render = function(_keepSurfaces = true)
    {
        var _i = 0;
        repeat(array_length(tilesetArray))
        {
            tilesetArray[_i].__Render(paletteArray, transparentIndex, _keepSurfaces);
            ++_i;
        }
        
        var _i = 0;
        repeat(array_length(frameArray))
        {
            frameArray[_i].__Render(paletteArray, transparentIndex, _keepSurfaces);
            ++_i;
        }
        
        return self;
    }
    
    static SaveAllFrames = function(_pathPattern)
    {
        if (string_pos("#", _pathPattern) <= 0)
        {
            _pathPattern = filename_change_ext(_pathPattern, "#" + filename_ext(_pathPattern));
        }
        
        var _i = 0;
        repeat(array_length(frameArray))
        {
            frameArray[_i].SaveAs(string_replace_all(_pathPattern, "#", _i));
            ++_i;
        }
        
        return self;
    }
    
    static SaveTag = function(_tagName, _pathPattern)
    {
        var _tagStruct = tagDict[$ _tagName];
        if (_tagStruct == undefined)
        {
            __AsepriteError($"Tag \"{_tagName}\" not recognized");
        }
        
        if (string_pos("#", _pathPattern) <= 0)
        {
            _pathPattern = filename_change_ext(_pathPattern, "#" + filename_ext(_pathPattern));
        }
        
        var _fromFrame = _tagStruct.fromFrame;
        var _i = 0;
        repeat(1 + _tagStruct.toFrame - _fromFrame)
        {
            frameArray[_i + _fromFrame].SaveAs(string_replace_all(_pathPattern, "#", _i));
            ++_i;
        }
        
        return self;
    }
    
    static Destroy = function()
    {
        var _i = 0;
        repeat(array_length(frameArray))
        {
            frameArray[_i].__Destroy();
            ++_i;
        }
    }
    
    
    
    static __Deserialize = function(_buffer)
    {
        _system.__writePaletteIndex  = 0;
        _system.__userDataToTagIndex = 0;
        
        var _filesize = buffer_read(_buffer, buffer_u32);
        if (buffer_get_size(_buffer) != _filesize)
        {
            __AsepriteTrace($"Warning! Buffer size {buffer_get_size(_buffer)} doesn't agree with Aseprite filesize {_filesize}");
        }
        
        var _magicNumber = buffer_read(_buffer, buffer_u16);
        if (_magicNumber != 0xA5E0)
        {
            __AsepriteError($"Magic number check failed; got 0x{string_delete(string(ptr(_magicNumber)), 1, 12)}, expecting 0xA5E0");
        }
        
        array_resize(frameArray, buffer_read(_buffer, buffer_u16));
        width      = buffer_read(_buffer, buffer_u16);
        height     = buffer_read(_buffer, buffer_u16);
        colorDepth = buffer_read(_buffer, buffer_u16);
        flags      = buffer_read(_buffer, buffer_u32); __hasUUIDs = ((flags & 0b100) > 0);
        buffer_seek(_buffer, buffer_seek_relative, 2); //Deprecated
        buffer_seek(_buffer, buffer_seek_relative, 8); //Unused
        transparentIndex = buffer_read(_buffer, buffer_u8);
        buffer_seek(_buffer, buffer_seek_relative, 3); //Unused
        
        colorCount = buffer_read(_buffer, buffer_u16);
        if (colorCount <= 0) colorCount = 256;
        
        var _pixelWidth  = buffer_read(_buffer, buffer_u8);
        var _pixelHeight = buffer_read(_buffer, buffer_u8);
        pixelRatio = ((_pixelWidth == 0) || (_pixelHeight == 0))? 1 : (_pixelWidth / _pixelHeight);
        
        gridX       = buffer_read(_buffer, buffer_s16);
        gridY       = buffer_read(_buffer, buffer_s16);
        gridWidth   = buffer_read(_buffer, buffer_u16);
        gridHeight  = buffer_read(_buffer, buffer_u16);
        gridEnabled = ((gridWidth != 0) && (gridHeight != 0));
        
        buffer_seek(_buffer, buffer_seek_relative, 84); //Reserved
        
        var _i = 0;
        repeat(array_length(frameArray))
        {
            frameArray[@ _i] = (new __AsepriteClassFrame()).__Deserialize(_buffer, self);
            ++_i;
        }
        
        var _i = 0;
        repeat(array_length(__linkedCelArray))
        {
            var _linkData = __linkedCelArray[_i];
            var _linkFrame    = _linkData.__frame;
            var _linkLayer    = _linkData.__layerIndex;
            var _linkCelArray = _linkData.__celArray;
            var _linkCelIndex = _linkData.__celIndex;
            
            var _frameStruct = frameArray[_linkFrame];
            var _frameCelArray = _frameStruct.celArray;
            
            var _found = false;
            var _j = 0;
            repeat(array_length(_frameCelArray))
            {
                if (_frameCelArray[_j].layerIndex == _linkLayer)
                {
                    _found = true;
                    _linkCelArray[@ _linkCelIndex] = _frameCelArray[_j];
                    break;
                }
                
                ++_j;
            }
            
            if (not _found)
            {
                __AsepriteError($"Failed to find cel link");
            }
            
            ++_i;
        }
        
        if (colorDepth == 8)
        {
            paletteArray[@ transparentIndex] &= 0x00_FFFFFF;
        }
        
        return self;
    }
}