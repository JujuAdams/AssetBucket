function AbManifestLoad(_path)
{
    static _system = __AbSystem();
    
    var _outputBucketArray = [];
    
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
        
        var _manifestBucketArray = _manifest.buckets;
        
        if (_manifest.type == "project manifest v1")
        {
            __projectMetadata = _manifest.projectMetadata;
        }
        else if (_manifest.type != "loose manifest v1")
        {
            __AbError($"Input JSON is not a manifest");
        }
        
        var _directory = $"{filename_dir(_path)}/";
        var _i = 0;
        repeat(array_length(_manifestBucketArray))
        {
            array_push(_outputBucketArray, AbBucketLoad($"{_directory}{_manifestBucketArray[_i].filename}"));
            ++_i;
        }
    }
    
    return _outputBucketArray;
}