/// @param configPath

function BucketLoadJSON(_configPath)
{
    if (not file_exists(_configPath))
    {
        __BucketError($"Could not find \"{_configPath}\"");
        return undefined;
    }
    
    var _buffer = buffer_load(_configPath);
    if (not buffer_exists(_buffer))
    {
        __BucketError($"Failed to load \"{_configPath}\"");
        return undefined;
    }
    
    var _string = buffer_peek(_buffer, 0, buffer_text);
    var _configStruct = undefined;
    try
    {
        _configStruct = json_parse(_string);
    }
    catch(_error)
    {
        show_debug_message(_error);
        
        if (not BUCKET_ALLOW_LOOSE_JSON)
        {
            __BucketError("Failed to parse configuration file as JSON");
            return undefined;
        }
        else
        {
            try
            {
                _configStruct = __BucketLooseJSONRead(_buffer);
            }
            catch(_error)
            {
                show_debug_message(_error);
                
                __BucketError("Failed to parse configuration file as either JSON or Loose JSON");
                return undefined;
            }
        }
    }
    
    buffer_delete(_buffer);
    
    return _configStruct;
}