/// Returns a struct that contains data inside the Aseprite file. The struct is an instance of
/// `__AsepriteClassFile()`.
/// 
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

function AsepriteRead(_filename)
{
    if (not file_exists(_filename))
    {
        __AsepriteError($"Cannot find \"{_filename}\"");
    }
    
    var _buffer = buffer_load(_filename);
    if (not buffer_exists(_buffer))
    {
        __AsepriteError($"Failed to load \"{_filename}\"");
    }
    
    var _fileStruct = (new __AsepriteClassFile()).__Deserialize(_buffer);
    
    buffer_delete(_buffer);
    
    return _fileStruct;
}