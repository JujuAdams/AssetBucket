function BucketInitialize()
{
    static _system = __BucketSystem();
    
    with(_system)
    {
        if (BUCKET_DEV_MODE)
        {
            if (GM_is_sandboxed)
            {
                __BucketError("Please disable sandboxing for this platform");
            }
            
            if (not __BucketLoadConfigurationFile())
            {
                return false;
            }
            
            var _rootDirectory = $"{BUCKET_PROJECT_DIRECTORY}{__config.__rootDirectory}";
            
            if (directory_exists(_rootDirectory))
            {
                __BucketTrace($"Root directory \"{_rootDirectory}\" found");
            }
            else
            {
                __BucketTrace($"Root directory \"{_rootDirectory}\" doesn't exist, creating now");
                directory_create(_rootDirectory);
                
                var _introText = "# Welcome\n\nWelcome to Asset Bucket by Juju Adams!";
                
                var _buffer = buffer_create(string_byte_length(_introText), buffer_fixed, 1);
                buffer_write(_buffer, buffer_text, _introText);
                buffer_save(_buffer, $"{_rootDirectory}README.md");
                buffer_delete(_buffer);
            }
        }
        else
        {
            
        }
        
        if (file_exists(BUCKET_MANIFEST_FILENAME))
        {
            var _buffer = buffer_load(BUCKET_MANIFEST_FILENAME);;
            if (not buffer_exists(_buffer))
            {
                __BucketError($"Failed to open \"{BUCKET_MANIFEST_FILENAME}\"");
            }
            
            var _json = buffer_read(_buffer, buffer_text);
            try
            {
                __manifest = json_parse(_json);
            }
            catch(_error)
            {
                show_debug_message(_error);
                __BucketError($"Failed to parse JSON in {BUCKET_MANIFEST_FILENAME}");
            }
            
            __BucketVariableAssertExactly(__manifest, ["buckets", "bucketLookup", "datafiles", "sprites", "sounds"]);
            __runtimeAllAssetsArray = array_concat(__manifest.datafiles, __manifest.sprites, __manifest.sounds);
            
            var _loadedBucketDict = {};
            
            var _i = 0;
            repeat(array_length(__runtimeBucketArray))
            {
                var _bucket = __runtimeBucketArray[_i];
                
                if (_bucket.__loaded)
                {
                    _loadedBucketDict[$ _bucket.__name] = true;
                }
                
                _bucket.__Destroy();
                
                ++_i;
            }
            
            array_resize(__runtimeBucketArray, 0);
            ds_map_clear(__runtimeBucketMap);
            
            var _manifestBucketArray = __manifest.buckets;
            var _i = 0;
            repeat(array_length(_manifestBucketArray))
            {
                var _bucketName = _manifestBucketArray[_i];
                
                var _runtimeBucket = new __BucketClassBucket(_bucketName);
                array_push(__runtimeBucketArray, _runtimeBucket);
                __runtimeBucketMap[? _bucketName] = _runtimeBucket;
                
                ++_i;
            }
            
            var _loadedBucketArray = struct_get_names(_loadedBucketDict);
            var _i = 0;
            repeat(array_length(_loadedBucketArray))
            {
                __runtimeBucketMap[? _loadedBucketArray[_i]].__Load();
                ++_i;
            }
        }
        
        return true;
    }
}