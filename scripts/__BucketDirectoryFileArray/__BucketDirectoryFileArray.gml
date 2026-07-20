// Feather disable all

/// @param rootDirectory

function __BucketDirectoryFileArray(_rootDirectory)
{
    var _wildcard = ((os_type == os_windows)? "*.*" : "*");
    
    _rootDirectory = __BucketEnsureDirectory(_rootDirectory);
    
    var _outputArray = [];
    
    var _directoryArray = [];
    array_push(_directoryArray, "");
    
    while(array_length(_directoryArray) > 0)
    {
        var _directory = array_pop(_directoryArray);
        
        var _file = undefined;
        while(true)
        {
            //On Linux the attribute argument is ignored, and everything that we can read is returned (even directories with a proper pattern).
            //This doesn't affect this function in particular but good to keep that in mind.
            _file = (_file == undefined)? file_find_first(_rootDirectory + _directory + _wildcard, fa_directory) : file_find_next();
            if (_file == "") break;
            
            if (directory_exists(_rootDirectory + _directory + _file))
            {
                array_push(_directoryArray, _directory + _file + "/");
            }
            else
            {
                array_push(_outputArray, _directory + _file);
            }
        }
        
        file_find_close();
    }
    
    return _outputArray;
}