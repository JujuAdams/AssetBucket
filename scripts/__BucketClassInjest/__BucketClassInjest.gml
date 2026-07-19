function __BucketClassInjest(_configStruct) constructor
{
    __configStruct = variable_clone(_configStruct);
    
    __workingFileArray = [];
    __bucketArray = [];
    __bucketDict = {};
    
    __ensureFolderArray = {};
    __projectImportAssetArray = [];
    
    __assetToBucketDict    = {};
    __projectDatafileArray = [];
    __projectSpriteArray   = [];
    __projectSoundArray    = [];
    
    
    
    static __RegisterBucketDatafile = function(_originalPath, _bucketNameArray)
    {
        array_push(__projectDatafileArray, _originalPath);
        __assetToBucketDict[$ _originalPath] = _bucketNameArray;
    }
    
    static __RegisterProjectDatafile = function(_originalPath)
    {
        array_push(__projectDatafileArray, _originalPath);
    }
    
    static __RegisterProjectSprite = function(_originalPath)
    {
        array_push(__projectSpriteArray, _originalPath);
    }
    
    static __RegisterProjectSound = function(_originalPath)
    {
        array_push(__projectSoundArray, _originalPath);
    }
    
    static __Injest = function()
    {
        var _yypString = __BucketLoadString(GM_project_filename);
        
        var _audioGroupsContent   = __BucketYYPExtract(_yypString, "AudioGroups");
        var _foldersContent       = __BucketYYPExtract(_yypString, "Folders");
        var _datafilesContent     = __BucketYYPExtract(_yypString, "IncludedFiles");
        var _resourcesContent     = __BucketYYPExtract(_yypString, "resources");
        var _textureGroupsContent = __BucketYYPExtract(_yypString, "TextureGroups");
        
        if (_audioGroupsContent.__error)
        {
            __BucketError($"Failed to extract audio groups from \"{GM_project_filename}\"");
        }
        
        if (_foldersContent.__error)
        {
            __BucketError($"Failed to extract IDE folders from \"{GM_project_filename}\"");
        }
        
        if (_datafilesContent.__error)
        {
            __BucketError($"Failed to extract datafiles from \"{GM_project_filename}\"");
        }
        
        if (_resourcesContent.__error)
        {
            __BucketError($"Failed to extract resources from \"{GM_project_filename}\"");
        }
        
        if (_textureGroupsContent.__error)
        {
            __BucketError($"Failed to extract texture groups from \"{GM_project_filename}\"");
        }
        
        var _yypAudioGroupsDict = {};
        var _yypAudioGroupsArray = _audioGroupsContent.__array;
        var _i = 0;
        repeat(array_length(_yypAudioGroupsArray))
        {
            _yypAudioGroupsDict[$ _yypAudioGroupsArray[_i].name] = true;
            ++_i;
        }
        
        var _yypFoldersDict = {};
        var _yypFoldersArray = _foldersContent.__array;
        var _i = 0;
        repeat(array_length(_yypFoldersArray))
        {
            _yypFoldersDict[$ string_delete(filename_change_ext(_yypFoldersArray[_i].folderPath, ""), 1, 8)] = true;
            ++_i;
        }
        
        var _yypDatafilesDict = {};
        var _yypDatafilesArray = _datafilesContent.__array;
        var _i = 0;
        repeat(array_length(_yypDatafilesArray))
        {
            _yypDatafilesDict[$ _yypDatafilesArray[_i].name] = true;
            ++_i;
        }
        
        var _yypResourcesDict = {};
        var _yypResourcesArray = _resourcesContent.__array;
        var _i = 0;
        repeat(array_length(_yypResourcesArray))
        {
            _yypResourcesDict[$ _yypResourcesArray[_i].id.name] = true;
            ++_i;
        }
        
        var _yypTextureGroupsDict = {};
        var _yypTextureGroupsArray = _textureGroupsContent.__array;
        var _i = 0;
        repeat(array_length(_yypTextureGroupsArray))
        {
            _yypTextureGroupsDict[$ _yypTextureGroupsArray[_i][$ "%Name"]] = true;
            ++_i;
        }
        
        var _newAudioGroupsString   = _audioGroupsContent.__string;
        var _newFoldersString       = _foldersContent.__string;
        var _newDatafilesString     = _datafilesContent.__string;
        var _newResourcesString     = _resourcesContent.__string;
        var _newTextureGroupsString = _textureGroupsContent.__string;
        
        if (_audioGroupsContent.__emptyArray) _newAudioGroupsString += "\n";
        _newAudioGroupsString += string_replace_all(_audioGroupTemplate, "%name%", "TestAudioGroup");
        if (_audioGroupsContent.__emptyArray) _newAudioGroupsString += "  ";
        
        if (_foldersContent.__emptyArray) _newFoldersString += "\n";
        _newFoldersString += string_replace_all(string_replace_all(_folderTemplate, "%name%", "TestFolder"), "%path%", "TestFolder");
        if (_foldersContent.__emptyArray) _newFoldersString += "  ";
        
        if (_datafilesContent.__emptyArray) _newDatafilesString += "\n";
        _newDatafilesString += string_replace_all(_datafileTemplate, "%name%", "TestDatafile");
        if (_datafilesContent.__emptyArray) _newDatafilesString += "  ";
        
        if (_resourcesContent.__emptyArray) _newResourcesString += "\n";
        _newResourcesString += string_replace_all(string_replace_all(_resourceTemplate, "%name%", "TestResource"), "%resourceType%", "notes");
        if (_resourcesContent.__emptyArray) _newResourcesString += "  ";
        
        if (_textureGroupsContent.__emptyArray) _newTextureGroupsString += "\n";
        _newTextureGroupsString += string_replace_all(_textureGroupTemplate, "%name%", "TestTextureGroup");
        if (_textureGroupsContent.__emptyArray) _newTextureGroupsString += "  ";
        
        _yypString = __BucketYYPInject(_yypString, _textureGroupsContent, _newTextureGroupsString);
        _yypString = __BucketYYPInject(_yypString, _resourcesContent,     _newResourcesString);
        _yypString = __BucketYYPInject(_yypString, _datafilesContent,     _newDatafilesString);
        _yypString = __BucketYYPInject(_yypString, _foldersContent,       _newFoldersString);
        _yypString = __BucketYYPInject(_yypString, _audioGroupsContent,   _newAudioGroupsString);
        
        __BucketSaveString(_yypString, GM_project_filename + "new");
        
        var _i = 0;
        repeat(array_length(__bucketArray))
        {
            __bucketArray[_i].__Save();
            ++_i;
        }
        
        var _json = json_stringify({
            buckets:      struct_get_names(__bucketDict),
            bucketLookup: __assetToBucketDict,
            datafiles:    __projectDatafileArray,
            sprites:      __projectSpriteArray,
            sounds:       __projectSoundArray,
        });
        
        __BucketSaveString(_json, $"{BUCKET_PROJECT_DIRECTORY}datafiles/{BUCKET_MANIFEST_FILENAME}");
    }
    
    static _audioGroupTemplate = "    {\"$GMAudioGroup\":\"v1\",\"%Name\":\"%name%\",\"exportDir\":\"\",\"name\":\"%name%\",\"resourceType\":\"GMAudioGroup\",\"resourceVersion\":\"2.0\",\"targets\":-1,},\n";
    
    static _folderTemplate = "    {\"$GMFolder\":\"\",\"%Name\":\"%name%\",\"folderPath\":\"folders/%path%.yy\",\"name\":\"%name%\",\"resourceType\":\"GMFolder\",\"resourceVersion\":\"2.0\",},\n";
    
    static _datafileTemplate = "    {\"$GMIncludedFile\":\"\",\"%Name\":\"%name%\",\"CopyToMask\":-1,\"filePath\":\"datafiles\",\"name\":\"%name%\",\"resourceType\":\"GMIncludedFile\",\"resourceVersion\":\"2.0\",},\n";
    
    static _resourceTemplate = "    {\"id\":{\"name\":\"%name%\",\"path\":\"%resourceType%/%name%/%name%.yy\",},},\n";
    
    static _textureGroupTemplate = "    {\"$GMTextureGroup\":\"\",\"%Name\":\"%name%\",\"autocrop\":true,\"border\":2,\"compressFormat\":\"bz2\",\"customOptions\":\"\",\"directory\":\"\",\"groupParent\":null,\"isScaled\":true,\"loadType\":\"default\",\"mipsToGenerate\":0,\"name\":\"%name%\",\"resourceType\":\"GMTextureGroup\",\"resourceVersion\":\"2.0\",\"targets\":-1,},\n";
}