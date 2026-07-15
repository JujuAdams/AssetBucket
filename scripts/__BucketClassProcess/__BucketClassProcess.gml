function __BucketClassProcess(_configStruct) constructor
{
    __configStruct = variable_clone(_configStruct);
    
    __fileArray = [];
    __blobArray = [];
    
    __actionToBlobArray    = [];
    __actionToProjectArray = [];
    
    
    
    static __Process = function()
    {
        var _blobDict = {};
        
        //Build a quick access dictionary
        var _blobArray = __blobArray;
        var _i = 0;
        repeat(array_length(_blobArray))
        {
            var _blob = _blobArray[_i];
            _blobDict[$ _blob.__name] = _blob;
            ++_i;
        }
        
        //Store file paths per blob
        var _actionToBlobArray = __actionToBlobArray;
        var _i = 0;
        repeat(array_length(_actionToBlobArray))
        {
            var _actionStruct = _actionToBlobArray[_i];
            var _filePath      = _actionStruct.__filePath;
            var _blobNameArray = _actionStruct.__blobNameArray;
            
            var _j = 0;
            repeat(array_length(_blobNameArray))
            {
                var _blobName = _blobNameArray[_j];
                
                var _blobStruct = _blobDict[$ _blobName];
                if (is_struct(_blobStruct))
                {
                    _blobStruct.__AddFile(_filePath);
                }
                else
                {
                    __BucketError($"Couldn't find blob with name \"{_filePath}\"");
                }
                
                ++_j;
            }
            
            ++_i;
        }
        
        //Compile all the blobs
        var _rootDirectory = $"{BUCKET_PROJECT_DIRECTORY}{__configStruct.__rootDirectory}";
        var _blobArray = __blobArray;
        var _i = 0;
        repeat(array_length(_blobArray))
        {
            _blobArray[_i].__Compile(_rootDirectory);
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