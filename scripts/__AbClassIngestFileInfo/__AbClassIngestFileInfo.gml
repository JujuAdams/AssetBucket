function __AbClassIngestFileInfo(_absolutePath) constructor
{
    static _system = __AbSystem();
    
    __absolutePath = _absolutePath;
    
    if (not file_exists(_absolutePath))
    {
        __AbError($"Could not find \"{__absolutePath}\"");
    }
    
    __hash = undefined;
    __ResetVariables();
    
    
    
    
    
    static __ResetVariables = function()
    {
        __bytes  = undefined;
        __width  = undefined;
        __height = undefined;
        __length = undefined;
    }
    
    static __CheckHash = function()
    {
        var _foundHash = md5_file(__absolutePath);
        if (_foundHash != __hash)
        {
            __hash = _foundHash;
            __ResetVariables();
        }
    }
    
    static __GetBytes = function()
    {
        if (__bytes == undefined)
        {
            var _buffer = buffer_load(__absolutePath);
            if (not buffer_exists(_buffer))
            {
                __AbError($"Failed to load \"{__absolutePath}\"");
            }
            
            __bytes = buffer_get_size(_buffer);
            buffer_delete(_buffer);
        }
        
        return __bytes;
    }
    
    static __GetWidth = function()
    {
        if (__width == undefined)
        {
            __GetSpriteDimensions();
        }
        
        return __width;
    }
    
    static __GetHeight = function()
    {
        if (__height == undefined)
        {
            __GetSpriteDimensions();
        }
        
        return __height;
    }
    
    static __GetLength = function()
    {
        if (__length == undefined)
        {
            
        }
        
        return __length;
    }
    
    static __GetSpriteDimensions = function()
    {
        var _sprite = __AbAddSprite(__absolutePath);
        if (not sprite_exists(_sprite))
        {
            __AbError($"Failed to load \"{__absolutePath}\"");
        }
        
        __width  = sprite_get_width(_sprite);
        __height = sprite_get_height(_sprite);
        
        sprite_delete(_sprite);
    }
}