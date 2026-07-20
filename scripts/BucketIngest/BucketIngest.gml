function BucketIngest()
{
    static _system = __BucketSystem();
    
    if (not BUCKET_DEV_MODE)
    {
        __BucketSoftError("Cannot injest files, not running in developer mode");
    }
    
    with(_system)
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
        
        var _injestStruct = new __BucketClassInjest(_system.__config);
        _system.__config.__Collect(_injestStruct);
        _injestStruct.__Injest();
    }
}