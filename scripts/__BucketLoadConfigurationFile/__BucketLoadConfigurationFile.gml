function __BucketLoadConfigurationFile()
{
    static _system = __BucketSystem();
    
    if (not BUCKET_DEV_MODE)
    {
        __BucketSoftError("Cannot load configuration file, not running in developer mode");
        return false;
    }
    
    var _configPath = $"{filename_dir(GM_project_filename)}/{BUCKET_CONFIG_FILENAME}";
    if (not file_exists(_configPath))
    {
        __BucketTrace($"Could not find configuration file at \"{_configPath}\"");
        
        if (show_question($"Could not find configuration file at \"{_configPath}\".\n \nWould you like to make it now?"))
        {
            var _string = json_stringify(new __BucketClassConfigRoot(), true);
            var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
            buffer_write(_buffer, buffer_text, _string);
            buffer_save(_buffer, _configPath);
            buffer_delete(_buffer);
            
            if (not file_exists(_configPath))
            {
                __BucketError($"Failed to save \"{_configPath}\"");
                return false;
            }
        }
        else
        {
            return false;
        }
    }
    
    var _buffer = buffer_load(_configPath);
    if (not buffer_exists(_buffer))
    {
        __BucketError($"Failed to load \"{_configPath}\"");
        return false;
    }
    
    var _string = buffer_peek(_buffer, 0, buffer_text);
    
    var _config = undefined;
    try
    {
        _config = json_parse(_string);
    }
    catch(_error)
    {
        show_debug_message(_error);
        
        if (not BUCKET_ALLOW_LOOSE_JSON)
        {
            __BucketError("Failed to parse configuration file as JSON");
            
            return false;
        }
        else
        {
            try
            {
                _config = __BucketLooseJSONRead(_buffer);
            }
            catch(_error)
            {
                show_debug_message(_error);
                __BucketError("Failed to parse configuration file as either JSON or Loose JSON");
                
                return false;
            }
        }
    }
    
    buffer_delete(_buffer);
    
    show_debug_message(json_stringify(_config, true));
    __BucketTrace("Parsed configuration file successfully");
    
    _system.__config = new __BucketClassConfigRoot().__Deserialize(_config);
    
    return true;
}