function __BucketClassInjestBucket(_name) constructor
{
    __name = _name;
    
    __accumulationBuffer = buffer_create(1024*1024, buffer_grow, 1);
    
    
    
    static __AddFile = function(_injestStruct, _sourcePath)
    {
        var _accumulationBuffer = __accumulationBuffer;
        
        var _absolutePath = $"{BUCKET_PROJECT_DIRECTORY}{_injestStruct.__configStruct.__rootDirectory}{_sourcePath}";
        if (not file_exists(_absolutePath))
        {
            __BucketError($"Can't find \"{_absolutePath}\"");
        }
        
        var _fileBuffer = buffer_load(_absolutePath);
        if (not buffer_exists(_fileBuffer))
        {
            __BucketError($"Failed to load \"{_absolutePath}\"");
        }
        
        var _fileSize = buffer_get_size(_fileBuffer);
        
        buffer_write(_accumulationBuffer, buffer_string, _sourcePath);
        buffer_write(_accumulationBuffer, buffer_u32, _fileSize);
        buffer_copy(_fileBuffer, 0, _fileSize, _accumulationBuffer, buffer_tell(_accumulationBuffer));
        buffer_seek(_accumulationBuffer, buffer_seek_relative, _fileSize);
        buffer_write(_accumulationBuffer, buffer_u8, 0x00);
        
        buffer_delete(_fileBuffer);
    }
    
    static __Save = function(_ensureDatafileDict)
    {
        var _filename = __BucketGetDatafilesName(__name);
        _ensureDatafileDict[$ _filename] = true;
        buffer_save(__accumulationBuffer, $"{BUCKET_PROJECT_DIRECTORY}datafiles/{_filename}");
        buffer_delete(__accumulationBuffer);
    }
}