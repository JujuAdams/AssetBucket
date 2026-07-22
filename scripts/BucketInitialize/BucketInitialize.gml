function BucketInitialize()
{
    static _system = __BucketSystem();
    with(_system)
    {
        if (file_exists(BUCKET_MANIFEST_PATH))
        {
            var _buffer = buffer_load(BUCKET_MANIFEST_PATH);
            if (not buffer_exists(_buffer))
            {
                __BucketError($"Failed to open \"{BUCKET_MANIFEST_PATH}\"");
            }
            
            var _manifest = undefined;
            var _json = buffer_read(_buffer, buffer_text);
            try
            {
                _manifest = json_parse(_json);
            }
            catch(_error)
            {
                show_debug_message(_error);
                __BucketError($"Failed to parse JSON in {BUCKET_MANIFEST_PATH}");
            }
            
            __BucketVariableAssertExactly(_manifest, ["buckets"]);
            
            var _loadedBucketDict = {};
            var _i = 0;
            repeat(array_length(__runtimeBucketArray))
            {
                var _bucket = __runtimeBucketArray[_i];
                
                //Find out which buckets are already loaded
                if (_bucket.__loaded)
                {
                    _loadedBucketDict[$ _bucket.__name] = true;
                }
                
                //Unload
                _bucket.__Destroy();
                
                ++_i;
            }
            
            array_resize(__runtimeBucketArray, 0);
            ds_map_clear(__runtimeBucketMap);
            
            ds_map_clear(__runtimeBucketDatafileMap);
            ds_map_clear(__runtimeBucketSoundMap);
            
            //Create new bucket stubs
            var _manifestBucketArray = _manifest.buckets;
            var _i = 0;
            repeat(array_length(_manifestBucketArray))
            {
                var _bucketInfo = _manifestBucketArray[_i];
                var _bucketName = _bucketInfo.name;
                
                var _runtimeBucket = new __BucketClassRuntimeBucket(_bucketName, _bucketInfo.blobSize);
                array_push(__runtimeBucketArray, _runtimeBucket);
                __runtimeBucketMap[? _bucketName] = _runtimeBucket;
                
                ++_i;
            }
            
            //Reload buckets that were previously loaded
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