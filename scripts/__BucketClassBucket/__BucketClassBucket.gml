function __BucketClassBucket(_bucketName) constructor
{
    __name = _bucketName;
    
    __buffer     = -1;
    __assetArray = [];
    __assetDict  = {};
    
    __globalAssetOffset = 0;
    
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
        __assetDict = {};
        __globalAssetOffset = 0;
    }
    
    static __Load = function()
    {
        if (__loaded) return;
        __loaded = true;
        
        var _path = __BucketGetDatafilePath(__BucketGetDatafilesName(__name));
        if (not file_exists(_path))
        {
            __BucketError($"Could not find \"{_path}\"");
        }
        
        __buffer = buffer_load(_path);
        var _buffer = __buffer;
        
        if (not buffer_exists(_buffer))
        {
            __BucketError($"Failed to load \"{_path}\"");
        }
        
        var _json = buffer_read(_buffer, buffer_string);
        __globalAssetOffset = buffer_tell(_buffer);
        
        var _bucketInfoStruct = undefined;
        try
        {
            _bucketInfoStruct = json_parse(_json);
        }
        catch(_error)
        {
            show_debug_message(_error);
            __BucketError("\"{_path}\" failed to parse JSON");
            return;
        }
        
        if (not is_struct(_bucketInfoStruct))
        {
            __BucketError($"\"{_path}\" parser expecting an object, got {typeof(_bucketInfoStruct)}");
        }
        
        var _version = _bucketInfoStruct[$ "version"];
        __assetDict = _bucketInfoStruct[$ "contents"];
        
        if (_version != BUCKET_CONTENTS_VERSION)
        {
            __BucketError($"\"{_path}\" was expecting version {BUCKET_CONTENTS_VERSION}, got {_version}");
        }
        
        if (not is_struct(__assetDict))
        {
            __BucketError($"\"{_path}\" `.contents` not an object, got {typeof(__assetDict)}");
        }
        
        __assetArray = struct_get_names(__assetDict);
    }
}