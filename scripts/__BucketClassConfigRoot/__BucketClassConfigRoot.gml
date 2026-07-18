function __BucketClassConfigRoot() constructor
{
    static _static_fileInfoDict = __BucketSystem().__fileInfoDict;
    
    static __Deserialize = function(_struct)
    {
        __BucketVariableAssertOnly(_struct, ["version", "rootDirectory", "includeAllPaths", "excludeAllPaths", "buckets", "datafiles", "sprites", "sounds"]);
        
        __version = __BucketVariableAssertNumber(_struct, "version");
        if (__version != 1)
        {
            __BucketError($"Version mismatch. Found {__version}, expecting 1");
        }
        
        __rootDirectory   = __BucketEnsureDirectory(__BucketVariableAssertString(_struct, "rootDirectory"));
        __includeAllPaths = __BucketVariableAssertStringOrArray(_struct, "includeAllPaths");
        __excludeAllPaths = __BucketVariableAssertStringOrArray(_struct, "excludeAllPaths");
        __bucketsArray      = __BucketDeserializeArrayOf(self, _struct[$ "buckets"    ], __BucketClassConfigBucket);
        __datafilesArray  = __BucketDeserializeArrayOf(self, _struct[$ "datafiles"], __BucketClassConfigDatafiles);
        __spritesArray    = __BucketDeserializeArrayOf(self, _struct[$ "sprites"  ], __BucketClassConfigSprites);
        __soundsArray     = __BucketDeserializeArrayOf(self, _struct[$ "sounds"   ], __BucketClassConfigSounds);
        
        return self;
    }
    
    static __Collect = function(_processStruct)
    {
        var _fileArray = __BucketDirectoryFileArray($"{BUCKET_PROJECT_DIRECTORY}{__rootDirectory}");
        _processStruct.__fileArray = _fileArray;
        
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
        
        //Collect buckets
        var _bucketsArray = __bucketsArray;
        var _i = 0;
        repeat(array_length(_bucketsArray))
        {
            _bucketsArray[_i].__Collect(_processStruct);
            ++_i;
        }
        
        //Collect datafiles
        var _datafilesArray = __datafilesArray;
        var _i = 0;
        repeat(array_length(_datafilesArray))
        {
            _datafilesArray[_i].__Collect(_processStruct);
            ++_i;
        }
        
        //Collect sprites
        var _spritesArray = __spritesArray;
        var _i = 0;
        repeat(array_length(_spritesArray))
        {
            _spritesArray[_i].__Collect(_processStruct);
            ++_i;
        }
        
        //Collect sounds
        var _soundsArray = __soundsArray;
        var _i = 0;
        repeat(array_length(_soundsArray))
        {
            _soundsArray[_i].__Collect(_processStruct);
            ++_i;
        }
    }
}