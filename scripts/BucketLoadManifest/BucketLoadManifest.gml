function AbLoadManifest()
{
    static _system = __AbSystem();
    with(_system)
    {
        var _manifestPath = __AbGetDatafilePath(AB_MANIFEST_FILENAME);
        if (not file_exists(_manifestPath))
        {
            __AbError($"Could not find manifest file at \"{_manifestPath}\"");
        }
        
        var _buffer = buffer_load(_manifestPath);
        if (not buffer_exists(_buffer))
        {
            __AbError($"Failed to open manifest file \"{_manifestPath}\"");
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
            __AbError($"Failed to parse JSON in {_manifestPath}");
        }
        
        __AbVariableAssertExactly(_manifest, ["buckets", "metadata"]);
        var _manifestAbArray = __AbVariableAssertArray(_manifest, "buckets");
        var _metadataStruct      = __AbVariableAssertStruct(_manifest, "metadata");
        
        __AbVariableAssertExactly(_metadataStruct, ["bucketDatafiles", "projectDatafiles", "assets"]);
        __metadataBucketDatafileDict  = __AbVariableAssertStruct(_metadataStruct, "bucketDatafiles");
        __metadataProjectDatafileDict = __AbVariableAssertStruct(_metadataStruct, "projectDatafiles");
        __metadataAssetDict           = __AbVariableAssertStruct(_metadataStruct, "assets");
        
        var _loadedAbDict = {};
        var _i = 0;
        repeat(array_length(__runtimeBucketArray))
        {
            var _bucket = __runtimeBucketArray[_i];
                
            //Find out which buckets are already loaded
            if (_bucket.__loaded)
            {
                _loadedAbDict[$ _bucket.__name] = true;
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
        var _i = 0;
        repeat(array_length(_manifestAbArray))
        {
            var _bucketInfo = _manifestAbArray[_i];
            var _bucketName = _bucketInfo.name;
            
            var _runtimeAb = new __AbClassRuntimeAb(_bucketName, _bucketInfo.blobSize);
            array_push(__runtimeBucketArray, _runtimeAb);
            __runtimeBucketMap[? _bucketName] = _runtimeAb;
            
            ++_i;
        }
        
        //Reload buckets that were previously loaded
        var _loadedAbArray = struct_get_names(_loadedAbDict);
        var _i = 0;
        repeat(array_length(_loadedAbArray))
        {
            __runtimeBucketMap[? _loadedAbArray[_i]].__Load();
            ++_i;
        }
        
        __manifestLoaded = true;
    }
}