/// @param size
/// @param chunkPathArray

function __BucketClassRuntimeBlob(_size, _chunkPathArray) constructor
{
    __size           = _size;
    __chunkPathArray = _chunkPathArray;
    __chunkCount     = array_length(_chunkPathArray);
    
    __bufferFinal  = undefined;
    __bufferLoaded = false;
    
    __timeSource = undefined;
    __chunkIndex = 0;
    
    
    
    
    static __GetBuffer = function(_loadType)
    {
        if (_loadType == BUCKET_LOAD_INSTANT)
        {
            return __Load();
        }
        else if (_loadType == BUCKET_LOAD_ASYNC)
        {
            return __LoadAsync();
        }
        else
        {
            return __bufferFinal;
        }
    }
    
    static __GetState = function()
    {
        if (__bufferLoaded)
        {
            return BUCKET_STATE_LOADED;
        }
        else if (__timeSource == undefined)
        {
            return BUCKET_STATE_LOADING;
        }
        else
        {
            return BUCKET_STATE_UNLOADED;
        }
    }
    
    static __Load = function()
    {
        if (__bufferLoaded) return __bufferFinal;
        
        if (not buffer_exists(__bufferFinal))
        {
            __bufferFinal = buffer_create(__size, buffer_fixed, 1);
        }
        
        __StopTimeSource();
        
        repeat(__chunkCount - __chunkIndex)
        {
            __LoadNextChunk();
        }
        
        return __bufferFinal;
    }
    
    static __LoadAsync = function()
    {
        if (__bufferLoaded) return __bufferFinal;
        if (__timeSource != undefined) return undefined;
        
        if (not buffer_exists(__bufferFinal))
        {
            __bufferFinal = buffer_create(__size, buffer_fixed, 1);
        }
        
        __timeSource = time_source_create(time_source_global, 1, time_source_global, __LoadNextChunk(), [], -1);
        time_source_start(__timeSource);
        
        return undefined;
    }
    
    static __Unload = function()
    {
        if (buffer_exists(__bufferFinal))
        {
            buffer_delete(__bufferFinal);
            __bufferFinal = undefined;
        }
        
        __bufferLoaded = false;
        __chunkIndex   = 0;
        
        __StopTimeSource();
    }
    
    static __Destroy = function()
    {
        __Unload();
    }
    
    static __StopTimeSource = function()
    {
        if (__timeSource != undefined)
        {
            time_source_stop(__timeSource);
            time_source_destroy(__timeSource);
            __timeSource = undefined;
        }
    }
    
    static __LoadNextChunk = function()
    {
        var _path = __chunkPathArray[__chunkIndex++];
        if (not file_exists(_path))
        {
            __BucketError($"Could not find \"{_path}\"");
        }
        
        var _buffer = buffer_load(_path);
        if (not buffer_exists(_buffer))
        {
            __BucketError($"Failed to load \"{_path}\"");
        }
        
        var _chunkSize = buffer_get_size(_buffer);
        var _bufferFinal = __bufferFinal;
        
        buffer_copy(_buffer, 0, _chunkSize, _bufferFinal, buffer_tell(_bufferFinal));
        buffer_seek(_bufferFinal, buffer_seek_relative, _chunkSize);
        
        if (__chunkIndex >= __chunkCount)
        {
            __bufferLoaded = true;
            __StopTimeSource();
            
            buffer_seek(_bufferFinal, buffer_seek_start, 0);
            
            return true;
        }
        else
        {
            return false;
        }
    }
}