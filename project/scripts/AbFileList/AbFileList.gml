/// @param [rootDirectory]
/// @param [subDirectory]

function AbFileList(_rootDirectory = undefined, _subDirectory = "") constructor
{
    __rootDirectory = "";
    __fileDataArray = [];
    
    if (is_string(_rootDirectory))
    {
        __rootDirectory = _rootDirectory;
        
        _rootDirectory = __AbEnsureDirectory(_rootDirectory);
        if (not directory_exists(_rootDirectory))
        {
            __AbError($"Directory \"{_rootDirectory}\" doesn't exist");
        }
        
        if (is_string(_subDirectory))
        {
            _subDirectory = __AbEnsureDirectory(_subDirectory);
            
            var _fileDescArray = __fileDataArray;
            
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
                    _file = (_file == undefined)? file_find_first(_rootDirectory + _directory + __AB_PATH_WILDCARD, fa_directory) : file_find_next();
                    if (_file == "") break;
                    
                    if (directory_exists(_rootDirectory + _directory + _file))
                    {
                        array_push(_directoryArray, _directory + _file + "/");
                    }
                    else
                    {
                        array_push(_fileDescArray, new AbFileDescription(_rootDirectory, _directory + _file));
                    }
                }
                
                file_find_close();
            }
            
            //Iterate over all existing cached file info and check their hashes. Any file info that
            //fails the hash check has its variables wiped ready for recalculation
            var _fileInfoDict = __AbSystem().__fileInfoDict;
            var _i = 0;
            repeat(array_length(_fileDescArray))
            {
                var _fileInfo = _fileInfoDict[$ _fileDescArray[_i].absolutePath];
                if (is_struct(_fileInfo))
                {
                    _fileInfo.__CheckHash();
                }
                
                ++_i;
            }
        }
    }
    
    static AddLocalPath = function(_pathOrArray)
    {
        var _rootDirectory = __rootDirectory;
        var _fileDescArray = __fileDataArray;
        _pathOrArray = __AbEnsureArray(_pathOrArray);
        
        var _i = 0;
        repeat(array_length(_pathOrArray))
        {
            array_push(_fileDescArray, new AbFileDescription(_rootDirectory, __AbEnsureDirectory(_pathOrArray[_i])));
            ++_i;
        }
        
        return self;
    }
    
    static AddAbsolutePath = function(_pathOrArray)
    {
        var _fileDescArray = __fileDataArray;
        _pathOrArray = __AbEnsureArray(_pathOrArray);
        
        var _i = 0;
        repeat(array_length(_pathOrArray))
        {
            array_push(_fileDescArray, new AbFileDescription("", __AbEnsureDirectory(_pathOrArray[_i])));
            ++_i;
        }
        
        return self;
    }
    
    static IncludeLocalPaths = function(_maskOrArray)
    {
        var _fileDescArray = __fileDataArray;
        
        var _i = array_length(_fileDescArray)-1;
        repeat(array_length(_fileDescArray))
        {
            if (not __AbTestStringMaskAny(_fileDescArray[_i].localPath, _maskOrArray))
            {
                array_delete(_fileDescArray, _i, 1);
            }
            
            --_i;
        }
        
        return self;
    }
    
    static ExcludeLocalPaths = function(_maskOrArray)
    {
        var _fileDescArray = __fileDataArray;
        
        var _i = array_length(_fileDescArray)-1;
        repeat(array_length(_fileDescArray))
        {
            if (__AbTestStringMaskAny(_fileDescArray[_i].localPath, _maskOrArray))
            {
                array_delete(_fileDescArray, _i, 1);
            }
            
            --_i;
        }
        
        return self;
    }
    
    static LinkImageFiles = function()
    {
        var _collectionDict = {};
        
        var _fileDescArray = __fileDataArray;
        var _i = array_length(_fileDescArray)-1;
        repeat(array_length(_fileDescArray))
        {
            var _fileDesc = _fileDescArray[_i];
            
            var _filenameStripped = _fileDesc.suggestedName;
            var _substringPos = string_pos("_frame", _filenameStripped);
            if (_substringPos > 0)
            {
                var _nextChar = ord(string_char_at(_filenameStripped, _substringPos + 6));
                if ((_nextChar >= 0x30) && (_nextChar <= 0x39))
                {
                    var _number = string_delete(_filenameStripped, 1, _substringPos+5);
                    try
                    {
                        _number = real(_number);
                    }
                    catch(_error)
                    {
                        show_debug_message(_error);
                    }
                    
                    if (is_numeric(_number))
                    {
                        var _basicName = string_copy(_filenameStripped, 1, _substringPos-1);
                        
                        var _pathArray = _collectionDict[$ _basicName];
                        if (not is_array(_pathArray))
                        {
                            _pathArray = [];
                            _collectionDict[$ _basicName] = _pathArray;
                        }
                        
                        _pathArray[@ _number] = _fileDesc.absolutePath;
                        
                        if (_number == 0)
                        {
                            _fileDesc.suggestedName = string_copy(_filenameStripped, 1, _substringPos-1);
                            _fileDesc.linkedPaths = _pathArray;
                        }
                        else
                        {
                            array_delete(_fileDescArray, _i, 1);
                        }
                    }
                }
            }
            
            --_i;
        }
        
        return self;
    }
    
    static Duplicate = function()
    {
        var _new = new AbFileList();
        _new.__rootDirectory = __rootDirectory;
        _new.__fileDataArray = variable_clone(__fileDataArray);
        return _new;
    }
    
    static Foreach = function(_method)
    {
        array_foreach(__fileDataArray, _method);
        
        return self;
    }
}