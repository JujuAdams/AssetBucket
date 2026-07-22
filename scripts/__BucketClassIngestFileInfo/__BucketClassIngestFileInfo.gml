function __BucketClassIngestFileInfo(_filePath) constructor
{
    static _system = __BucketSystem();
    
    __sourcePath = _filePath;
    
    __absolutePath = $"{_system.__currentYYPDirectory}{_system.__currentIngestStruct.__configStruct.__rootDirectory}{__sourcePath}";
    if (not file_exists(__absolutePath))
    {
        __BucketError($"Could not find \"{__absolutePath}\"");
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
                __BucketError($"Failed to load \"{__absolutePath}\"");
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
        var _sprite = __BucketAddSprite(__absolutePath);
        if (not sprite_exists(_sprite))
        {
            __BucketError($"Failed to load \"{__absolutePath}\"");
        }
        
        __width  = sprite_get_width(_sprite);
        __height = sprite_get_height(_sprite);
        
        sprite_delete(_sprite);
    }
}