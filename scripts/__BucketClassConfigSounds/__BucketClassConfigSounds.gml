function __BucketClassConfigSounds() : __BucketClassConfigAsset() constructor
{
    static __ExecuteAction = function(_processStruct, _fileArray)
    {
        var _bucketDict = _processStruct.__bucketDict;
        
        with(__action)
        {
            var _i = 0;
            repeat(array_length(_fileArray))
            {
                var _sourcePath = _fileArray[_i];
                
                var _fileExtension = string_lower(filename_ext(_sourcePath));
                if (_fileExtension == "wav")
                {
                    if (__importBucket != undefined)
                    {
                        _processStruct.__RegisterAsset(_sourcePath, __importBucket);
                        
                        var _i = 0;
                        repeat(array_length(__importBucket))
                        {
                            var _bucketName = __importBucket[_i];
                            
                            var _bucketStruct = _bucketDict[$ _bucketName];
                            if (_bucketStruct == undefined)
                            {
                                __BucketError($"Couldn't find bucket with name \"{_bucketName}\"");
                            }
                            else
                            {
                                _bucketStruct.__AddWAV(_sourcePath);
                            }
                            
                            ++_i;
                        }
                    }
                    
                    if (__projectImportFolder != undefined)
                    {
                        
                    }
                }
                else if (_fileExtension == "ogg")
                {
                    if (__importBucket != undefined)
                    {
                        _processStruct.__RegisterAsset(_sourcePath, __importBucket);
                        
                        var _i = 0;
                        repeat(array_length(__importBucket))
                        {
                            var _bucketName = __importBucket[_i];
                            
                            var _bucketStruct = _bucketDict[$ _bucketName];
                            if (_bucketStruct == undefined)
                            {
                                __BucketError($"Couldn't find bucket with name \"{_bucketName}\"");
                            }
                            else
                            {
                                _bucketStruct.__AddOGG(_sourcePath);
                            }
                            
                            ++_i;
                        }
                    }
                    
                    if (__projectImportFolder != undefined)
                    {
                        
                    }
                }
                else
                {
                    __BucketError($"Audio file extension \"{_fileExtension}\" not supported (path was \"{_sourcePath}\")");
                }
                
                ++_i;
            }
        }
    }
}