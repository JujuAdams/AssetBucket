function BucketIngest()
{
    if (not BUCKET_DEV_MODE)
    {
        __BucketSoftError("Cannot ingest files, not running in developer mode");
        return;
    }
    
    if (GM_is_sandboxed)
    {
        __BucketError("Please disable sandboxing for this platform");
    }
    
    with(__BucketSystem())
    {
        var _configPath = $"{BUCKET_PROJECT_DIRECTORY}notes/{BUCKET_CONFIG_NOTE_ASSET_NAME}/{BUCKET_CONFIG_NOTE_ASSET_NAME}.txt";
        if (not file_exists(_configPath))
        {
            __BucketTrace($"Could not find configuration file at \"{_configPath}\"");
            
            if (show_question($"Could not find configuration file at \"{_configPath}\".\n \nWould you like to make it now?"))
            {
                __BucketYYCreateNote(BUCKET_PROJECT_DIRECTORY, BUCKET_PROJECT_NAME, BUCKET_CONFIG_NOTE_ASSET_NAME, _templateConfig);
            }
            else
            {
                return undefined;
            }
        }
        
        var _configStruct = BucketLoadJSON(_configPath);
        if (not is_struct(_configStruct))
        {
            __BucketError($"Failed to parse \"{_configPath}\"");
        }
        
        var _rootDirectory = $"{BUCKET_PROJECT_DIRECTORY}{_configStruct.rootDirectory}";
        if (directory_exists(_rootDirectory))
        {
            __BucketTrace($"Root directory \"{_rootDirectory}\" found");
        }
        else
        {
            __BucketTrace($"Root directory \"{_rootDirectory}\" doesn't exist, creating now");
            
            directory_create(_rootDirectory);
            directory_create($"{_rootDirectory}datafiles");
            directory_create($"{_rootDirectory}sprites");
            directory_create($"{_rootDirectory}sounds");
            
            __BucketSaveString(_introText, $"{_rootDirectory}README.md");
        }
        
        return BucketIngestExt(_configPath, GM_project_filename);
    }
    
    static _templateConfig = @'{
    "version": 1,
    "rootDirectory": "asset_bucket",

    "buckets": [
        {
            "name": "bucketDefault",
        },
    ],

    "tasks": [
        {
            "include": {
                "path": "datafiles/*",
            },
            "worker": {
                "resourceType": "datafile",
                "function": "importToBucket",
                "bucket": "bucketDefault"
            },
        },
        {
            "include": {
                "path": "sprites/*.png",
            },
            "worker": {
                "resourceType": "sprite",
                "function": "importToProject",
                "folder": "Sprites/",
                "textureGroup": "Default",
            },
        },
        {
            "include": {
                "path": ["sounds/*.wav", "sounds/*.ogg"],
            },
            "worker": {
                "resourceType": "sound",
                "function": "importToProject",
                "folder": "Sounds/",
                "audioGroup": "audiogroup_default",
            },
        },
    ],
}';
    
    static _introText = @'# Welcome

Welcome to Asset Bucket by Juju Adams!';
}