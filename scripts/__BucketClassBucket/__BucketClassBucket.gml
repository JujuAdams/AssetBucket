function __BucketClassBucket(_bucketName) constructor
{
    __name = _bucketName;
    
    __buffer          = -1;
    __assetArray      = [];
    __assetSizeDict   = {};
    __assetOffsetDict = {};
    
    __loaded = false;
    
    
    
    static __Destroy = function()
    {
        __Unload();
    }
    
    static __Unload = function()
    {
        if (not __loaded) return;
        __loaded = false;
        
        if (buffer_exists(__buffer))
        {
            buffer_delete(__buffer);
            __buffer = undefined;
        }
        
        array_resize(__assetArray, 0);
        __assetSizeDict   = {};
        __assetOffsetDict = {};
    }
    
    static __Load = function()
    {
        if (__loaded) return;
        __loaded = true;
        
        var _filename = __BucketGetDatafilesName(__name);
        if (not file_exists(_filename))
        {
            __BucketError($"Could not find \"{_filename}\"");
        }
        
        __buffer = buffer_load(_filename);
        var _buffer = __buffer;
        
        if (not buffer_exists(_buffer))
        {
            __BucketError($"Failed to load \"{_filename}\"");
        }
        
        var _assetArray    = __assetArray;
        var _assetSizeDict = __assetSizeDict;
        var _assetPosDict  = __assetOffsetDict;
        
        var _bufferSize = buffer_get_size(_buffer);
        while(buffer_tell(_buffer) < _bufferSize)
        {
            var _originalPath = buffer_read(_buffer, buffer_string);
            var _size = buffer_read(_buffer, buffer_u32);
            
            array_push(_assetArray, _originalPath);
            _assetSizeDict[$ _originalPath] = _size;
            _assetPosDict[$  _originalPath] = buffer_tell(_buffer);
            
            buffer_seek(_buffer, buffer_seek_relative, _size);
        }
    }
}