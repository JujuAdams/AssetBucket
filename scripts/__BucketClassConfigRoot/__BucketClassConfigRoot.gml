function __BucketClassConfigRoot() constructor
{
    static _system = __BucketSystem();
    static _static_fileInfoDict = _system.__fileInfoDict;
    
    static __Deserialize = function(_struct)
    {
        __BucketVariableAssertOnly(_struct, ["version", "rootDirectory", "includeAllPaths", "excludeAllPaths", "buckets", "tasks"]);
        
        __version = __BucketVariableAssertNumber(_struct, "version");
        if (__version != BUCKET_CONFIG_VERSION)
        {
            __BucketError($"Version mismatch. Found {__version}, expecting {BUCKET_CONFIG_VERSION}");
        }
        
        __rootDirectory   = __BucketEnsureDirectory(__BucketVariableAssertString(_struct, "rootDirectory"));
        __includeAllPaths = __BucketVariableAssertStringOrArray(_struct, "includeAllPaths");
        __excludeAllPaths = __BucketVariableAssertStringOrArray(_struct, "excludeAllPaths");
        __bucketsArray    = __BucketDeserializeArrayOf(self, _struct[$ "buckets"], __BucketClassConfigBucket);
        __tasksArray      = __BucketDeserializeArrayOf(self, _struct[$ "tasks"  ], __BucketClassConfigTask);
        
        return self;
    }
    
    static __Collect = function()
    {
        var _rootDirectory = $"{_system.__currentYYPDirectory}{_system.__currentIngestStruct.__configStruct.__rootDirectory}";
        var _fileArray = __BucketDirectoryFileArray($"{_system.__currentYYPDirectory}{__rootDirectory}");
        
        //Remove anything that doesn't fit the global include mask
        if (array_length(__includeAllPaths) > 0)
        {
            var _i = array_length(_fileArray)-1;
            repeat(array_length(_fileArray))
            {
                if (not __BucketTestStringMaskAny(_fileArray[_i], __includeAllPaths))
                {
                    array_delete(_fileArray, _i, 1);
                }
                
                --_i;
            }
        }
        
        //Remove anything that does fit the global exclude mask
        if (array_length(__excludeAllPaths) > 0)
        {
            var _i = array_length(_fileArray)-1;
            repeat(array_length(_fileArray))
            {
                if (__BucketTestStringMaskAny(_fileArray[_i], __excludeAllPaths))
                {
                    array_delete(_fileArray, _i, 1);
                }
                
                --_i;
            }
        }
        
        //Iterate over all existing cached file info and check their hashes. Any file info that
        //fails the hash check has its variables wiped ready for recalculation
        var _fileInfoDict = _static_fileInfoDict;
        var _i = 0;
        repeat(array_length(_fileArray))
        {
            var _fileInfo = _fileInfoDict[$ _fileArray[_i]];
            if (is_struct(_fileInfo))
            {
                _fileInfo.__CheckHash();
            }
            
            ++_i;
        }
        
        //Remove files that look like frames of sprites
        var _i = array_length(_fileArray)-1;
        repeat(array_length(_fileArray))
        {
            var _localPath = _fileArray[_i];
            if (__BucketTestStringMask(_localPath, "*_frame*.*"))
            {
                if (string_pos("_frame0.", _localPath) > 0)
                {
                    _fileArray[@ _i] = __BucketFindSpriteFrames(_rootDirectory, _localPath);
                }
                else
                {
                    array_delete(_fileArray, _i, 1);
                }
            }
            
            --_i;
        }
        
        //Build buckets
        var _bucketsArray = __bucketsArray;
        var _i = 0;
        repeat(array_length(_bucketsArray))
        {
            _bucketsArray[_i].__Build();
            ++_i;
        }
        
        //Execute tasks
        var _tasksArray = __tasksArray;
        var _i = 0;
        repeat(array_length(_tasksArray))
        {
            _tasksArray[_i].__Execute(_fileArray);
            ++_i;
        }
    }
}