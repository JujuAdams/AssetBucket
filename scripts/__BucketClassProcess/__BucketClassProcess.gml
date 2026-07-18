function __BucketClassProcess(_configStruct) constructor
{
    __configStruct = variable_clone(_configStruct);
    
    __fileArray = [];
    __bucketArray = [];
    
    __actionToBucketArray    = [];
    __actionToProjectArray = [];
    
    
    
    static __Process = function()
    {
        var _bucketDict = {};
        
        //Build a quick access dictionary
        var _bucketArray = __bucketArray;
        var _i = 0;
        repeat(array_length(_bucketArray))
        {
            var _bucket = _bucketArray[_i];
            _bucketDict[$ _bucket.__name] = _bucket;
            ++_i;
        }
        
        var _filePathToBucketDict = {};
        
        //Store file paths per bucket
        var _actionToBucketArray = __actionToBucketArray;
        var _i = 0;
        repeat(array_length(_actionToBucketArray))
        {
            var _actionStruct = _actionToBucketArray[_i];
            var _filePath      = _actionStruct.__sourcePath;
            var _bucketNameArray = _actionStruct.__bucketNameArray;
            
            _filePathToBucketDict[$ _filePath] = _bucketNameArray;
            
            var _j = 0;
            repeat(array_length(_bucketNameArray))
            {
                var _bucketName = _bucketNameArray[_j];
                
                var _bucketStruct = _bucketDict[$ _bucketName];
                if (is_struct(_bucketStruct))
                {
                    _bucketStruct.__AddFile(_filePath);
                }
                else
                {
                    __BucketError($"Couldn't find bucket with name \"{_filePath}\"");
                }
                
                ++_j;
            }
            
            ++_i;
        }
        
        //Compile all the buckets
        var _rootDirectory = $"{BUCKET_PROJECT_DIRECTORY}{__configStruct.__rootDirectory}";
        var _bucketArray = __bucketArray;
        var _i = 0;
        repeat(array_length(_bucketArray))
        {
            _bucketArray[_i].__Compile(_rootDirectory);
            ++_i;
        }
        
        //Store file paths for import into the project
        var _actionToProjectArray = __actionToProjectArray;
        var _i = 0;
        repeat(array_length(_actionToProjectArray))
        {
            var _actionStruct = _actionToProjectArray[_i];
            ++_i;
        }
    }
}