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
/// `.Render([keepSurfaces=true])`
///     Renders the Aseprite content onto internal surfaces, allowing the Aseprite file to be
///     drawn.
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
///     Draws a frame from the given tag. The frame number is such that frame `0` is the first
///     frame of the tag. The frame number should be greater than or equal to zero.
/// 
/// `.DrawTagExt(tagName, frame, x, y, xScale, yScale, angle, blend, alpha)`
///     N.B. You must call `.Render()` before calling this method.
///     
///     As above but with extra scaling options.
/// 
/// `.HideLayersByMask(mask)`
///     Hides layers whose name first the string mask provided. The string mask should use `*` as a
///     wildcard character e.g. `"*[ignore]` will hide all layers whose name ends in exactly
///     `"[ignore]"`.
/// 
/// `.DeleteTagsByMask(mask)`
///     Deletes tags whose name first the string mask provided. The string mask should use `*` as a
///     wildcard character e.g. `"*[ignore]` will hide all tags whose name ends in exactly
///     `"[ignore]"`.
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
/// `.width`
/// `.height`
/// `.colorProfile`
/// `.layerArray`
/// `.tagDict`
/// `.tagArray`
/// `.sliceArray`
/// `.frameArray`
/// `.hasUUIDs`
/// `.paletteArray`
/// `.paletteNameArray`
/// `.colorDepth`
/// `.pixelRatio`
/// `.userData`
/// `.grid`

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
    
    return (new __AsepriteClassFile()).__Deserialize(_buffer);
}