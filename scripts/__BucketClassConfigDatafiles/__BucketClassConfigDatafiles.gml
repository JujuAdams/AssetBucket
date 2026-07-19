function __BucketClassConfigDatafiles() : __BucketClassConfigAsset() constructor
{
    static __ExecuteImport = function(_processStruct, _fileArray)
    {
        var _bucketDict = _processStruct.__bucketDict;
        
        with(__import)
        {
            var _i = 0;
            repeat(array_length(_fileArray))
            {
                var _sourcePath = _fileArray[_i];
                
                if (__importBucket != undefined)
                {
                    _processStruct.__RegisterBucketDatafile(_sourcePath, __importBucket);
                    
                    var _bucketStruct = _bucketDict[$ __importBucket];
                    if (_bucketStruct == undefined)
                    {
                        __BucketError($"Couldn't find bucket with name \"{__importBucket}\"");
                    }
                    else
                    {
                        _bucketStruct.__AddFile(_processStruct, _sourcePath);
                    }
                }
                
                if (__projectImportFolder != undefined)
                {
                    _processStruct.__RegisterProjectDatafile(_sourcePath);
                    
                    file_copy($"{BUCKET_PROJECT_DIRECTORY}{_processStruct.__configStruct.__rootDirectory}{_sourcePath}",
                              $"{BUCKET_PROJECT_DIRECTORY}datafiles/{__projectImportFolder}ab_{md5_string_utf8(_sourcePath)}");
                }
                
                ++_i;
            }
        }
    }
}