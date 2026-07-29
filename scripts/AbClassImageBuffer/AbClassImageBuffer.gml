/// @param buffer
/// @param offset
/// @param size
/// @param [ownsBuffer=true]

function AbClassImageBuffer(_buffer, _offset, _size, _ownsBuffer = true)
{
    __parent = undefined;
    
    __buffer     = _buffer;
    __offset     = _offset;
    __size       = _size;
    __ownsBuffer = _ownsBuffer;
    
    __sprite = undefined;
    
    static GetSprite = function()
    {
        if (not sprite_exists(__sprite))
        {
            var _surface = surface_create(GetWidth(), GetHeight());
            buffer_set_surface(__buffer, _surface, __offset);
            __sprite = sprite_create_from_surface(_surface, 0, 0, GetWidth(), GetHeight(), false, false, 0, 0);
            surface_free(_surface);
        }
        
        return __sprite;
    }
    
    static GetWidth = function()
    {
        return is_struct(__parent)? __parent.width : undefined;
    }
    
    static GetHeight = function()
    {
        return is_struct(__parent)? __parent.height : undefined;
    }
    
    static SaveAs = function(_filename)
    {
        sprite_save(GetSprite(), 0, _filename);
    }
    
    static FreeMemory = function()
    {
        if (__ownsBuffer)
        {
            if (buffer_exists(__buffer))
            {
                buffer_delete(__buffer);
                __buffer = undefined;
            }
        }
        
        if (sprite_exists(__sprite))
        {
            sprite_delete(__sprite);
            __sprite = undefined;
        }
    }
}