function BucketIngest()
{
    static _system = __BucketSystem();
    static _once = (function()
    {
        BucketSetWorkerFunction("defaultToBucket", function(_filePath, _workerInfo)
        {
            __BucketVariableAssertString(_workerInfo, "name");
            __BucketVariableAssertString(_workerInfo, "type");
            __BucketVariableAssertString(_workerInfo, "bucket");
            
            var _type = _workerInfo.type;
            if (_type == "datafile")
            {
                BucketIngestDatafileToBucket(_filePath, _workerInfo.bucket);
            }
            else if (_type == "sprite")
            {
                //BucketIngestSpriteToBucket(_workerInfo.bucket);
            }
            else if (_type == "sound")
            {
                //BucketIngestSoundToBucket(_workerInfo.bucket);
            }
            else
            {
                __BucketError($"Type \"{_type}\" unhandled");
            }
        });
        
        BucketSetWorkerFunction("defaultToProject", function(_filePath, _workerInfo)
        {
            __BucketVariableAssertString(_workerInfo, "name");
            __BucketVariableAssertString(_workerInfo, "type");
            __BucketVariableAssertString(_workerInfo, "folder");
            
            var _type = _workerInfo.type;
            if (_type == "datafile")
            {
                //BucketIngestDatafileToProject(_workerInfo.folder);
            }
            else if (_type == "sprite")
            {
                var _spriteName = filename_change_ext(filename_name(_filePath), "");
                BucketIngestSpriteToProject(_spriteName, BucketFindSpriteFrames(_filePath), _workerInfo.folder, _workerInfo[$ "textureGroup"]);
            }
            else if (_type == "sound")
            {
                var _soundName = filename_change_ext(filename_name(_filePath), "");
                BucketIngestSoundToProject(_soundName, _filePath, _workerInfo.folder, _workerInfo[$ "audioGroup"]);
            }
            else
            {
                __BucketError($"Type \"{_type}\" unhandled");
            }
        });
    })();
    
    
    if (not BUCKET_DEV_MODE)
    {
        __BucketSoftError("Cannot ingest files, not running in developer mode");
        return;
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
        
        var _oldIngestStruct = __currentIngestStruct;
        __currentIngestStruct = new __BucketClassIngest(_system.__config);
        
        _system.__config.__Collect();
        __currentIngestStruct.__Ingest();
        
        __currentIngestStruct = _oldIngestStruct;
    }
}