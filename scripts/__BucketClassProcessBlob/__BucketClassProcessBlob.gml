function __BucketClassProcessBlob(_name, _macroScript) constructor
{
    __name        = _name;
    __macroScript = _macroScript;
    
    __assetArray = [];
    
    static __AddFile = function(_filePath)
    {
        array_push(__assetArray, _filePath);
    }
    
    static __Compile = function(_rootDirectory)
    {
        var _assetArray = __assetArray;
        
        var _buffer = buffer_create(1024*1024, buffer_grow, 1);
        buffer_write(_buffer, buffer_text, "blob");
        buffer_write(_buffer, buffer_u16, array_length(_assetArray));
        
        var _length = array_length(_assetArray);
        var _posArray = array_create(_length, 0);
        
        var _i = 0;
        repeat(_length)
        {
            buffer_write(_buffer, buffer_string, _assetArray[_i]);
            _posArray[@ _i] = buffer_tell(_buffer);
            buffer_write(_buffer, buffer_u32, 0); //Offset
            buffer_write(_buffer, buffer_u32, 0); //Size
            ++_i;
        }
        
        var _writeOffset = buffer_tell(_buffer);
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            var _filePath = _rootDirectory + _assetArray[_i];
            if (not file_exists(_filePath))
            {
                __BucketError($"Can't find \"{_filePath}\"");
            }
            
            var _fileBuffer = buffer_load(_filePath);
            if (not buffer_exists(_fileBuffer))
            {
                __BucketError($"Failed to load \"{_filePath}\"");
            }
            
            var _fileSize = buffer_get_size(_fileBuffer);
            
            var _tableOffset = _posArray[@ _i];
            buffer_poke(_buffer, _tableOffset,   buffer_u32, _writeOffset);
            buffer_poke(_buffer, _tableOffset+4, buffer_u32, _fileSize);
            
            buffer_copy(_fileBuffer, 0, _fileSize, _buffer, _writeOffset);
            _writeOffset += _fileSize;
            
            buffer_delete(_fileBuffer);
            
            ++_i;
        }
        
        buffer_save(_buffer, $"{BUCKET_PROJECT_DIRECTORY}datafiles/{__name}.bin");
        buffer_delete(_buffer);
    }
}