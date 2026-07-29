/// @param path

function AbClassImageNative(_path)
{
    __parent = undefined;
    
    __path = _path;
    
    __sprite = undefined;
    __width  = undefined;
    __height = undefined;
    
    static GetSprite = function()
    {
        if (sprite_exists(__sprite)) return __sprite;
        __sprite = sprite_add(__path, 1, false, false, 0, 0);
    }
    
    static GetWidth = function()
    {
        if (__width == undefined)
        {
            __width = sprite_get_width(GetSprite());
        }
        
        return __width;
    }
    
    static GetHeight = function()
    {
        if (__height == undefined)
        {
            __height = sprite_get_height(GetSprite());
        }
        
        return __height;
    }
    
    static SaveAs = function(_filename)
    {
        file_copy(__path, _filename);
    }
    
    static FreeMemory = function()
    {
        if (sprite_exists(__sprite))
        {
            sprite_delete(__sprite);
            __sprite = undefined;
        }
    }
}