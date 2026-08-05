/// The constructed struct has the following public read-only variables:
/// `.width`
/// `.height`
/// `.bitsPerTile`
/// `.bitmask`
/// `.bitmaskXFlip`
/// `.bitmaskYFlip`
/// `.bitmaskDiag`
/// `.tileBuffer`
/// `.userData`

function __AsepriteClassTilemap() constructor
{
    width        = undefined;
    height       = undefined;
    bitsPerTile  = undefined;
    bitmask      = undefined;
    bitmaskXFlip = undefined;
    bitmaskYFlip = undefined;
    bitmaskDiag  = undefined;
    tileBuffer   = undefined;
    
    __surface       = undefined;
    __tilesetStruct = undefined;
    
    static __Destroy = function()
    {
        buffer_delete(tileBuffer);
        tileBuffer = undefined;
    }
    
    static __GetSurface = function()
    {
        if (surface_exists(__surface)) return __surface;
        
        gpu_set_blendmode_ext(bm_one, bm_zero);
        
        var _buffer        = tileBuffer;
        var _tilesetStruct = __tilesetStruct;
        
        var _tileWidth      = _tilesetStruct.tileWidth;
        var _tileHeight     = _tilesetStruct.tileHeight;
        var _tilesetSurface = _tilesetStruct.GetSurface();
        
        var _diagSurfWidth = surface_get_height(_tilesetSurface);
        var _diagSurface = surface_create(_diagSurfWidth, surface_get_width(_tilesetSurface));
        surface_set_target(_diagSurface);
        draw_clear_alpha(c_black, 0);
        draw_surface_ext(_tilesetSurface, 0, 0, -1, 1, 90, c_white, 1);
        surface_reset_target();
        
        __surface = surface_create(_tileWidth*width, _tileHeight*height);
        
        surface_set_target(__surface);
        draw_clear_alpha(c_black, 0);
        
        var _bitmaskIndex = bitmask;
        var _bitmaskXFlip = bitmaskXFlip;
        var _bitmaskYFlip = bitmaskYFlip;
        var _bitmaskDiag  = bitmaskDiag;
        
        buffer_seek(_buffer, buffer_seek_start, 0);
        
        var _tilemapWidth = width;
        var _y = 0;
        repeat(height)
        {
            var _x = 0;
            repeat(_tilemapWidth)
            {
                var _tileData = buffer_read(_buffer, __ASEPRITE_BUFFER_DWORD);
                
                var _tileIndex = _tileData & _bitmaskIndex;
                if (_tileIndex > 0)
                {
                    var _tileXFlip = _tileData & _bitmaskXFlip;
                    var _tileYFlip = _tileData & _bitmaskYFlip;
                    var _tileDiag  = _tileData & _bitmaskDiag;
                    
                    if (_tileXFlip)
                    {
                        if (_tileYFlip)
                        {
                            if (_tileDiag) // X Flip + Y Flip + Diagonal
                            {
                                draw_surface_part_ext(_diagSurface, _tileIndex*_tileHeight, 0, _tileHeight, _tileWidth, _tileWidth*(_x + 1), _tileHeight*(_y + 1), -1, -1, c_white, 1);
                            }
                            else // X Flip + Y Flip
                            {
                                draw_surface_part_ext(_tilesetSurface, 0, _tileIndex*_tileHeight, _tileWidth, _tileHeight, _tileWidth*(_x + 1), _tileHeight*(_y + 1), -1, -1, c_white, 1);
                            }
                        }
                        else
                        {
                            if (_tileDiag) // X Flip + Diagonal
                            {
                                draw_surface_part_ext(_diagSurface, _tileIndex*_tileHeight, 0, _tileHeight, _tileWidth, _tileWidth*(_x + 1), _tileHeight*_y, -1, 1, c_white, 1);
                            }
                            else // X Flip
                            {
                                draw_surface_part_ext(_tilesetSurface, 0, _tileIndex*_tileHeight, _tileWidth, _tileHeight, _tileWidth*(_x + 1), _tileHeight*_y, -1, 1, c_white, 1);
                            }
                        }
                    }
                    else
                    {
                        if (_tileYFlip)
                        {
                            if (_tileDiag) // Y Flip + Diagonal
                            {
                                draw_surface_part_ext(_diagSurface, _tileIndex*_tileHeight, 0, _tileHeight, _tileWidth, _tileWidth*_x, _tileHeight*(_y + 1), 1, -1, c_white, 1);
                            }
                            else // Y Flip
                            {
                                draw_surface_part_ext(_tilesetSurface, 0, _tileIndex*_tileHeight, _tileWidth, _tileHeight, _tileWidth*_x, _tileHeight*(_y + 1), 1, -1, c_white, 1);
                            }
                        }
                        else
                        {
                            if (_tileDiag) // Diagonal
                            {
                                draw_surface_part_ext(_diagSurface, _tileIndex*_tileHeight, 0, _tileHeight, _tileWidth, _tileWidth*_x, _tileHeight*_y, 1, 1, c_white, 1);
                            }
                            else
                            {
                                draw_surface_part(_tilesetSurface, 0, _tileIndex*_tileHeight, _tileWidth, _tileHeight, _tileWidth*_x, _tileHeight*_y);
                            }
                        }
                    }
                }
                
                ++_x;
            }
            
            ++_y;
        }
        
        surface_reset_target();
        gpu_set_blendmode(bm_normal);
    }
    
    static __Render = function(_tilesetStruct)
    {
        __tilesetStruct = _tilesetStruct;
        __GetSurface();
    }
    
    static __Deserialize = function(_fileBuffer, _chunkEnd)
    {
        width        = buffer_read(_fileBuffer, __ASEPRITE_BUFFER_SHORT);
        height       = buffer_read(_fileBuffer, __ASEPRITE_BUFFER_SHORT);
        bitsPerTile  = buffer_read(_fileBuffer, __ASEPRITE_BUFFER_SHORT); //Should always be 32
        bitmask      = buffer_read(_fileBuffer, __ASEPRITE_BUFFER_DWORD); //Should always be 0x1FFF_FFFF (536870911)
        bitmaskXFlip = buffer_read(_fileBuffer, __ASEPRITE_BUFFER_DWORD);
        bitmaskYFlip = buffer_read(_fileBuffer, __ASEPRITE_BUFFER_DWORD);
        bitmaskDiag  = buffer_read(_fileBuffer, __ASEPRITE_BUFFER_DWORD);
        buffer_seek(_fileBuffer, buffer_seek_relative, 10); //Reserved
        
        if (bitsPerTile != 32)
        {
            __AsepriteError($"Invalid bits-per-tile for tilemap. Expecting 32, got {bitsPerTile}");
        }
        
        tileBuffer = __AsepriteBufferDecompressExt(_fileBuffer, buffer_tell(_fileBuffer), _chunkEnd);
        
        return self;
    }
}