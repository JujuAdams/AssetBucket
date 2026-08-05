/// The constructed struct has the following public read-only variables:
/// `.userData`

function __AsepriteClassTileset() constructor
{
    tilesetID  = undefined;
    flags      = undefined;
    tileCount  = undefined;
    tileWidth  = undefined;
    tileHeight = undefined;
    baseIndex  = undefined;
    name       = undefined;
    
    externalFileID    = undefined;
    externalTilesetID = undefined;
    
    userData = undefined;
    
    buffer            = undefined;
    __tempBuffer      = undefined;
    __tempBufferDirty = undefined;
    __surface         = undefined;
    
    
    
    
    
    static DrawTile = function(_index, _x, _y)
    {
        draw_surface_part(GetSurface(), 0, _index*tileHeight, tileWidth, tileHeight, _x, _y);
    }
    
    static DrawTileExt = function(_index, _x, _y, _xScale, _yScale, _blend, _alpha)
    {
        draw_surface_part_ext(GetSurface(), 0, _index*tileHeight, tileWidth, tileHeight, _x, _y, _xScale, _yScale, _blend, _alpha);
    }
    
    static GetSurface = function()
    {
        if (not surface_exists(__surface))
        {
            __surface = surface_create(tileWidth, tileHeight*tileCount);
            
            if (buffer_exists(buffer))
            {
                buffer_set_surface(buffer, __surface, 0);
            }
            else
            {
                surface_set_target(__surface);
                draw_clear_alpha(c_black, 0);
                surface_reset_target();
            }
        }
        
        return __surface;
    }
    
    static __Render = function(_frameSurface, _layerArray, _paletteArray, _keepSurfaces)
    {
        if (__tempBufferDirty)
        {
            var _buffer = buffer_create(4*width*height, buffer_fixed, 1);
            
            var _tempBuffer = __tempBuffer;
            buffer_seek(_tempBuffer, buffer_seek_start, 0);
            
            repeat(width*height)
            {
                buffer_write(_buffer, buffer_u32, _paletteArray[buffer_read(_tempBuffer, buffer_u8)]);
            }
            
            buffer = _buffer;
            buffer_delete(__tempBuffer);
            __tempBuffer = undefined;
            __tempBufferDirty = false;
        }
        else
        {
            buffer = __tempBuffer;
        }
    }
    
    static __Deserialize = function(_buffer, _fileStruct)
    {
        var _colorDepth = _fileStruct.colorDepth;
        
        tilesetID  = buffer_read(_buffer, __ASEPRITE_BUFFER_DWORD);
        flags      = buffer_read(_buffer, __ASEPRITE_BUFFER_DWORD);
        tileCount  = buffer_read(_buffer, __ASEPRITE_BUFFER_DWORD);
        tileWidth  = buffer_read(_buffer, __ASEPRITE_BUFFER_WORD);
        tileHeight = buffer_read(_buffer, __ASEPRITE_BUFFER_WORD);
        baseIndex  = buffer_read(_buffer, __ASEPRITE_BUFFER_SHORT);
        buffer_seek(_buffer, buffer_seek_relative, 14); //Reserved
        name = __AsepriteReadString(_buffer);
        
        if not (flags & 0b100)
        {
            __AsepriteError("Tileset flag 0x04 is not set. Please update this Aseprite file");
        }
        
        if (flags & 0b001)
        {
            externalFileID    = buffer_read(_buffer, __ASEPRITE_BUFFER_DWORD);
            externalTilesetID = buffer_read(_buffer, __ASEPRITE_BUFFER_DWORD);
        }
        
        if (flags & 0b010)
        {
            var _length = buffer_read(_buffer, __ASEPRITE_BUFFER_DWORD);
            
            var _decompressedBuffer = __AsepriteBufferDecompressExt(_buffer, buffer_tell(_buffer), buffer_tell(_buffer) + _length);
            __tempBuffer = __AsepriteReadImageBuffer(_decompressedBuffer, tileWidth*tileHeight*tileCount, _colorDepth);
            __tempBufferDirty = (_colorDepth == 8);
            buffer_delete(_decompressedBuffer);
            
            buffer_seek(_buffer, buffer_seek_start, _length);
        }
        
        return self;
    }
}