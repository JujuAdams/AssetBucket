/// The constructed struct has the following public methods:
/// `.GetSurface()`
/// 
/// The constructed struct has the following public read-only variables:
/// `.userData`
/// `.layerIndex`
/// `.x`
/// `.y`
/// `.opacity`
/// `.type`
/// `.zIndex`
/// `.width`
/// `.height`
/// `.buffer`
/// `.order`
/// `.flags`
/// `.xPrecise`
/// `.yPrecise`
/// `.widthPrecise`
/// `.heightPrecise`

function __AsepriteClassCel() constructor
{
    static _system = __AsepriteSystem();
    
    userData = undefined;
    
    layerIndex = undefined;
    x          = undefined;
    y          = undefined;
    opacity    = undefined;
    type       = undefined;
    zIndex     = undefined;
    width      = undefined;
    height     = undefined;
    buffer     = undefined;
    order      = undefined;
    
    flags         = 0;
    xPrecise      = undefined;
    yPrecise      = undefined;
    widthPrecise  = undefined;
    heightPrecise = undefined;
    
    tilesetDict   = undefined;
    tilemapStruct = undefined;
    
    __linkFrame       = undefined;
    __surface         = undefined;
    __tempBuffer      = undefined;
    __tempBufferDirty = false;
    
    
    
    static GetSurface = function()
    {
        if (type == 3)
        {
            return tilemapStruct.__GetSurface();
        }
        else
        {
            if (not surface_exists(__surface))
            {
                __surface = surface_create(width, height);
                buffer_set_surface(buffer, __surface, 0);
            }
        }
        
        return __surface;
    }
    
    static __Destroy = function()
    {
        if (buffer_exists(buffer))
        {
            buffer_delete(buffer);
            buffer = undefined;
        }
        
        if (buffer_exists(__tempBuffer))
        {
            buffer_delete(__tempBuffer);
            __tempBuffer = undefined;
        }
        
        if (surface_exists(__surface))
        {
            surface_free(__surface);
            __surface = undefined;
        }
        
        if (is_struct(tilemapStruct))
        {
            tilemapStruct.__Destroy();
            tilemapStruct = undefined;
        }
    }
    
    static __Render = function(_frameSurface, _layerArray, _paletteArray, _keepSurfaces)
    {
        if (type == 3)
        {
            if (is_struct(tilemapStruct))
            {
                var _tilesetID = _layerArray[layerIndex].tilesetID;
                if (_tilesetID == undefined)
                {
                    __AsepriteError($"Layer tileset ID invalid");
                }
                
                var _tilesetStruct = tilesetDict[$ _tilesetID];
                if (_tilesetID == undefined)
                {
                    __AsepriteError($"Tileset ID {_tilesetID} doesn't exist");
                }
                
                tilemapStruct.__Render(_tilesetStruct, _paletteArray);
                
                if (_layerArray[layerIndex].flags & 0b0001)
                {
                    surface_set_target(_frameSurface);
                    gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
                    draw_surface(GetSurface(), x, y);
                    gpu_set_blendmode(bm_normal);
                    surface_reset_target();
                    
                    if (not _keepSurfaces)
                    {
                        surface_free(tilemapStruct.__surface);
                        tilemapStruct.__surface = undefined;
                    }
                }
            }
        }
        else
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
            
            if (_layerArray[layerIndex].flags & 0b0001)
            {
                surface_set_target(_frameSurface);
                gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
                draw_surface(GetSurface(), x, y);
                gpu_set_blendmode(bm_normal);
                surface_reset_target();
                
                if (not _keepSurfaces)
                {
                    surface_free(__surface);
                    __surface = undefined;
                }
            }
        }
    }
    
    static __Deserialize = function(_fileBuffer, _fileStruct, _chunkEnd)
    {
        var _colorDepth = _fileStruct.colorDepth;
        
        layerIndex = buffer_read(_fileBuffer, buffer_u16);
        x          = buffer_read(_fileBuffer, buffer_s16);
        y          = buffer_read(_fileBuffer, buffer_s16);
        opacity    = buffer_read(_fileBuffer, buffer_u8);
        type       = buffer_read(_fileBuffer, buffer_u16);
        //0 - Raw Image Data (unused, compressed image is preferred)
        //1 - Linked Cel
        //2 - Compressed Image
        //3 - Compressed Tilemap
                
        zIndex = buffer_read(_fileBuffer, buffer_s16);
        // 0 = default layer ordering
        //+N = show this cel N layers later
        //-N = show this cel N layers back
        
        order = layerIndex + zIndex;
                
        buffer_seek(_fileBuffer, buffer_seek_relative, 5); //Reserved
        
        if (type == 0)
        {
            width  = buffer_read(_fileBuffer, buffer_u16);
            height = buffer_read(_fileBuffer, buffer_u16);
            __tempBuffer = __AsepriteReadImageBuffer(_fileBuffer, width*height, _colorDepth);
            __tempBufferDirty = (_colorDepth == 8);
        }
        else if (type == 1)
        {
            __linkFrame = buffer_read(_fileBuffer, buffer_u16);
        }
        else if (type == 2)
        {
            width  = buffer_read(_fileBuffer, buffer_u16);
            height = buffer_read(_fileBuffer, buffer_u16);
            
            var _decompressedBuffer = __AsepriteBufferDecompressExt(_fileBuffer, buffer_tell(_fileBuffer), _chunkEnd);
            __tempBuffer = __AsepriteReadImageBuffer(_decompressedBuffer, width*height, _colorDepth);
            __tempBufferDirty = (_colorDepth == 8);
            buffer_delete(_decompressedBuffer);
            
            buffer_seek(_fileBuffer, buffer_seek_start, _chunkEnd);
        }
        else if (type == 3)
        {
            tilesetDict = _fileStruct.tilesetDict;
            tilemapStruct = (new __AsepriteClassTilemap()).__Deserialize(_fileBuffer, _chunkEnd);
        }
        else
        {
            __AsepriteError($"Cel type {type} unhandled");
        }
        
        return self;
    }
    
    static __DeserializeExtra = function(_buffer)
    {
        flags         = buffer_read(_buffer, buffer_u32);
        xPrecise      = __AsepriteReadFixedPoint(_buffer);
        yPrecise      = __AsepriteReadFixedPoint(_buffer);
        widthPrecise  = __AsepriteReadFixedPoint(_buffer);
        heightPrecise = __AsepriteReadFixedPoint(_buffer);
        buffer_seek(_buffer, buffer_seek_relative, 16);
    }
}