/// @param parent
/// @param name

function __AbClassBuilderTextureGroup(_parent, _name) constructor
{
    static _system = __AbSystem();
    
    __parent = _parent;
    __name   = _name;
    
    __queuedSprites = [];
    
    __textureFormat = AB_TEXTURE_FORMAT_PNG;
    __textureSize   = 2048;
    __imageBorder   = 2;
    
    
    
    static __AddSprite = function(_spriteDesc)
    {
        array_push(__queuedSprites, _spriteDesc);
    }
    
    static __PackTextures = function(_directory)
    {
        var _packResult = AbPackSprites(__queuedSprites, __textureSize, __imageBorder);
        
        var _pathArray = [];
        
        var _surfaceArray = _packResult.surfaceArray;
        var _i = 0;
        repeat(array_length(_surfaceArray))
        {
            var _surface = _surfaceArray[_i];
            
            var _filename = __parent.__NewExportFilename();
            var _destinationPath = _directory + _filename;
            
            if ((__textureFormat == AB_TEXTURE_FORMAT_RAW) || (__textureFormat == AB_TEXTURE_FORMAT_ZLIB))
            {
                var _buffer = buffer_create(16 + 4*surface_get_width(_surface)*surface_get_height(_surface), buffer_fixed, 1);
                buffer_write(_buffer, buffer_text, "RAW ");
                buffer_write(_buffer, buffer_s32,  surface_get_width(_surface));
                buffer_write(_buffer, buffer_s32,  surface_get_height(_surface));
                buffer_write(_buffer, buffer_s32,  0x00);
                buffer_get_surface(_buffer, _surface, 16);
                
                if (__textureFormat == AB_TEXTURE_FORMAT_RAW)
                {
                    var _compressedBuffer = buffer_compress(_buffer, 0, buffer_get_size(_buffer));
                    buffer_delete(_buffer);
                    _buffer = _compressedBuffer;
                }
                
                buffer_save(_buffer, _destinationPath);
                buffer_delete(_buffer);
            }
            else if (__textureFormat == AB_TEXTURE_FORMAT_PNG)
            {
                surface_save(_surface, _destinationPath);
            }
            else
            {
                __AbError($"Texture format \"{__textureFormat}\" unhandled for bucket \"{__name}\"");
            }
            
            surface_free(_surface);
            array_push(_pathArray, _filename);
            
            ++_i;
        }
        
        return {
            name:        __name,
            format:      __textureFormat,
            tpages:      _pathArray,
            description: _packResult.description,
        }
    }
}