function __BucketClassIngestBucket(_name) constructor
{
    static _system = __BucketSystem();
    
    __name = _name;
    
    __accumulationBuffer = buffer_create(1024*1024, buffer_grow, 1);
    __contentsDict = {};
    
    
    
    static __AddBuffer = function(_alias, _buffer, _offset, _size)
    {
        var _accumulationBuffer = __accumulationBuffer;
        
        __contentsDict[$ _alias] = {
            offset: buffer_tell(_accumulationBuffer),
            size: _size,
        };
        
        buffer_copy(_buffer, _offset, _size, _accumulationBuffer, buffer_tell(_accumulationBuffer));
        buffer_seek(_accumulationBuffer, buffer_seek_relative, _size);
        buffer_write(_accumulationBuffer, buffer_u8, 0x00);
    }
    
    static __Save = function(_ensureDatafileDict)
    {
        var _filename = __BucketGetDatafilesName(__name);
        _ensureDatafileDict[$ _filename] = true;
        
        var _buffer = buffer_create(1024*1024, buffer_grow, 1);
        buffer_write(_buffer, buffer_string, json_stringify({ version: int64(BUCKET_CONTENTS_VERSION), contents: __contentsDict }));
        buffer_copy(__accumulationBuffer, 0, buffer_tell(__accumulationBuffer), _buffer, buffer_tell(_buffer));
        
        buffer_save_ext(_buffer, $"{BUCKET_PROJECT_DIRECTORY}datafiles/{_filename}", 0, buffer_tell(__accumulationBuffer) + buffer_tell(_buffer));
        
        buffer_delete(_buffer);
        buffer_delete(__accumulationBuffer);
    }
}