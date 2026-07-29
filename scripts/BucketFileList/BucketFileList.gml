/// @param [rootDirectory=""]

#macro __BUCKET_PATH_WILDCARD  ((os_type == os_windows)? "*.*" : "*")

function BucketFileList(_rootDirectory = "") constructor
{
    __rootDirectory = "";
    __fileDataArray = [];
    
    static ChangeRootDirectory = function(_newRootDirectory)
    {
        _newRootDirectory = __BucketEnsureDirectory(_newRootDirectory);
        var _oldRootDirectory = __rootDirectory;
        
        if (_oldRootDirectory == _newRootDirectory) return;
        __rootDirectory = _newRootDirectory;
        
        if ((string_pos(_oldRootDirectory, _newRootDirectory) == 1) || (string_pos(_newRootDirectory, _oldRootDirectory) == 1))
        {
            var _newRootDirLength = string_length(_newRootDirectory);
            
            var _fileDataArray = __fileDataArray;
            var _i = array_length(_fileDataArray)-1;
            repeat(array_length(_fileDataArray))
            {
                with(_fileDataArray[_i])
                {
                    if (string_pos(_newRootDirectory, absolutePath) == 1)
                    {
                        rootDirectory = _newRootDirectory;
                        localPath     = string_delete(absolutePath, 1, _newRootDirLength);
                    }
                    else
                    {
                        array_delete(_fileDataArray, _i, 1);
                    }
                }
                
                --_i;
            }
        }
        else
        {
            array_resize(__fileDataArray, 0);
        }
        
        return self;
    }
    
    static AddLocalPath = function(_pathOrArray)
    {
        var _rootDirectory = __rootDirectory;
        var _fileDataArray = __fileDataArray;
        _pathOrArray = __BucketEnsureArray(_pathOrArray);
        
        var _i = 0;
        repeat(array_length(_pathOrArray))
        {
            array_push(_fileDataArray, new __BucketClassPathDescription(_rootDirectory, __BucketEnsureDirectory(_pathOrArray[_i])));
            ++_i;
        }
        
        return self;
    }
    
    static AddAbsolutePath = function(_pathOrArray)
    {
        var _fileDataArray = __fileDataArray;
        _pathOrArray = __BucketEnsureArray(_pathOrArray);
        
        var _i = 0;
        repeat(array_length(_pathOrArray))
        {
            array_push(_fileDataArray, new __BucketClassPathDescription("", __BucketEnsureDirectory(_pathOrArray[_i])));
            ++_i;
        }
        
        return self;
    }
    
    static PopulateFromSubdirectory = function(_path)
    {
        _path = __BucketEnsureDirectory(_path);
        
        var _rootDirectory = __rootDirectory;
        var _fileDataArray = __fileDataArray;
        
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
                _file = (_file == undefined)? file_find_first(_rootDirectory + _directory + __BUCKET_PATH_WILDCARD, fa_directory) : file_find_next();
                if (_file == "") break;
                
                if (directory_exists(_rootDirectory + _directory + _file))
                {
                    array_push(_directoryArray, _directory + _file + "/");
                }
                else
                {
                    array_push(_fileDataArray, new __BucketClassPathDescription(_rootDirectory, _directory + _file));
                }
            }
            
            file_find_close();
        }
        
        //Iterate over all existing cached file info and check their hashes. Any file info that
        //fails the hash check has its variables wiped ready for recalculation
        var _fileInfoDict = __BucketSystem().__fileInfoDict;
        var _i = 0;
        repeat(array_length(_fileDataArray))
        {
            var _fileInfo = _fileInfoDict[$ _fileDataArray[_i].absolutePath];
            if (is_struct(_fileInfo))
            {
                _fileInfo.__CheckHash();
            }
            
            ++_i;
        }
        
        return self;
    }
    
    static IncludeLocalPaths = function(_maskOrArray)
    {
        var _fileDataArray = __fileDataArray;
        
        var _i = array_length(_fileDataArray)-1;
        repeat(array_length(_fileDataArray))
        {
            if (not __BucketTestStringMaskAny(_fileDataArray[_i].localPath, _maskOrArray))
            {
                array_delete(_fileDataArray, _i, 1);
            }
            
            --_i;
        }
        
        return self;
    }
    
    static ExcludeLocalPaths = function(_maskOrArray)
    {
        var _fileDataArray = __fileDataArray;
        
        var _i = array_length(_fileDataArray)-1;
        repeat(array_length(_fileDataArray))
        {
            if (__BucketTestStringMaskAny(_fileDataArray[_i].localPath, _maskOrArray))
            {
                array_delete(_fileDataArray, _i, 1);
            }
            
            --_i;
        }
        
        return self;
    }
    
    static CollectImageFrames = function()
    {
        //TODO
        
        //Remove files that look like frames of sprites
        var _fileArray = [];
        var _i = 0;
        for(var _i = 0; _i < array_length(_localPathArray); _i++)
        {
            var _localPath = _localPathArray[_i];
            if (__BucketTestStringMask(_localPath, "*_frame0.*"))
            {
                var _framesPathArray = __BucketFindSpriteFrames(_rootDirectory, _localPath);
                
                var _j = 0;
                repeat(array_length(_framesPathArray))
                {
                    var _index = array_get_index(_localPathArray, _framesPathArray[_j]);
                    if (_index >= 0) array_delete(_localPathArray, _index, 1);
                    ++_j;
                }
                
                var _spriteName = filename_change_ext(string_replace_all(filename_name(_localPath), "_frame0.", "."), "");
                array_push(_fileArray, new __BucketClassFile(_spriteName, _framesPathArray));
            }
            else
            {
                var _spriteName = filename_change_ext(filename_name(_localPath), "");
                array_push(_fileArray, new __BucketClassFile(_spriteName, _localPath));
            }
            
            --_i;
        }
    }
    
    static Duplicate = function()
    {
        var _new = new BucketFileList();
        _new.__rootDirectory = __rootDirectory;
        _new.__fileDataArray = variable_clone(__fileDataArray);
        return _new;
    }
}