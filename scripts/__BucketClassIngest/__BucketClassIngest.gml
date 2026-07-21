function __BucketClassIngest(_configStruct) constructor
{
    __configStruct = variable_clone(_configStruct);
    
    __bucketArray = [];
    __bucketDict = {};
    
    __ensureAudioGroupDict   = {};
    __ensureFolderDict       = {}; //N.B. Must not include trailing backslash
    __ensureDatafileDict     = {};
    __ensureResourceDict     = {};
    __ensureTextureGroupDict = {};
    
    __assetToBucketDict    = {};
    __projectDatafileArray = [];
    __projectSpriteArray   = [];
    __projectSoundArray    = [];
    __bucketMetadataDict   = {};
    __datafileMetadataDict = {};
    __projectMetadataDict  = {};
    
    __queueArray        = [];
    __queueBucketAlias  = {};
    __queueProjectAsset = {};
    
    
    
    static __QueueBucketOperation = function(_alias, _deferredFunction)
    {
        if (struct_exists(__queueBucketAlias, _alias))
        {
            _deferredFunction.__Destroy();
            __BucketError($"Operation already exists for bucket content with alias \"{_alias}\"");
        }
        
        __queueBucketAlias[$ _alias] = _deferredFunction;
        array_push(__queueArray, _deferredFunction);
    }
    
    static __QueueProjectOperation = function(_assetName, _deferredFunction)
    {
        if (struct_exists(__queueProjectAsset, _assetName))
        {
            _deferredFunction.__Destroy();
            __BucketError($"Operation already exists for project asset \"{_assetName}\"");
        }
        
        __queueProjectAsset[$ _assetName] = _deferredFunction;
        array_push(__queueArray, _deferredFunction);
    }
    
    static __RegisterBucketDatafile = function(_alias, _bucketName)
    {
        array_push(__projectDatafileArray, _alias);
        __assetToBucketDict[$ _alias] = _bucketName;
    }
    
    static __RegisterProjectDatafile = function(_originalPath, _filename)
    {
        array_push(__projectDatafileArray, _originalPath);
        __ensureDatafileDict[$ _filename] = true;
    }
    
    static __RegisterProjectSprite = function(_originalPath, _spriteName)
    {
        array_push(__projectSpriteArray, _originalPath);
        __ensureResourceDict[$ _spriteName] = "sprites";
    }
    
    static __RegisterProjectSound = function(_originalPath, _audioName)
    {
        array_push(__projectSoundArray, _originalPath);
        __ensureResourceDict[$ _audioName] = "sounds";
    }
    
    static __SetBucketMetadata = function(_alias, _metadata)
    {
        if (_metadata != undefined)
        {
            __bucketMetadataDict[$ _alias] = _metadata;
        }
    }
    
    static __SetDatafileMetadata = function(_alias, _metadata)
    {
        if (_metadata != undefined)
        {
            __datafileMetadataDict[$ _alias] = _metadata;
        }
    }
    
    static __SetProjectMetadata = function(_assetName, _metadata)
    {
        if (_metadata != undefined)
        {
            __projectMetadataDict[$ _alias] = _metadata;
        }
    }
    
    static __EnsureProjectDatafile = function(_filename)
    {
        __ensureDatafileDict[$ _filename] = true;
    }
    
    static __EnsureProjectFolder = function(_projectFolder)
    {
        _projectFolder = __BucketTrimDirectory(_projectFolder);
        if (_projectFolder != "")
        {
            __ensureFolderDict[$ _projectFolder] = true;
        }
    }
    
    static __EnsureProjectTextureGroup = function(_textureGroup)
    {
        __ensureTextureGroupDict[$ _textureGroup] = true;
    }
    
    static __EnsureProjectAudioGroup = function(_audioGroup)
    {
        __ensureAudioGroupDict[$ _audioGroup] = true;
    }
    
    static __Ingest = function()
    {
        var _queueArray = __queueArray;
        var _i = 0;
        repeat(array_length(_queueArray))
        {
            _queueArray[_i].__Execute(self);
            ++_i;
        }
        
        var _bucketExportArray = [];
        var _i = 0;
        repeat(array_length(__bucketArray))
        {
            __bucketArray[_i].__Save(self, __ensureDatafileDict, _bucketExportArray);
            ++_i;
        }
        
        var _json = json_stringify({
            buckets:      _bucketExportArray,
            bucketLookup: __assetToBucketDict,
            datafiles:    __projectDatafileArray,
            sprites:      __projectSpriteArray,
            sounds:       __projectSoundArray,
        });
        
        __BucketSaveString(_json, $"{BUCKET_PROJECT_DIRECTORY}datafiles/{BUCKET_MANIFEST_FILENAME}");
        __ensureDatafileDict[$ BUCKET_MANIFEST_FILENAME] = true;
        
        //Skip .yyp modification if we have nothing to add
        if ((struct_names_count(__ensureAudioGroupDict) <= 0)
        &&  (struct_names_count(__ensureFolderDict) <= 0)
        //&&  (struct_names_count(__ensureDatafileDict) <= 0) //Unnecessary because GameMaker will automatically build its own datafiles index
        &&  (struct_names_count(__ensureResourceDict) <= 0)
        &&  (struct_names_count(__ensureTextureGroupDict) <= 0))
        {
            return;
        }
        
        //Load the base project .yy
        file_copy(GM_project_filename, $"{GM_project_filename}.old");
        var _yypString = __BucketLoadString(GM_project_filename);
        var _oldYYPString = _yypString;
        
        //Extract arrays as strings from the .yyp
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
        
        //Unpack arrays into dictionaries for faster lookups
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
        
        //Expand folder paths
        var _ensureFolderDict = __ensureFolderDict;
        var _ensureFolderArray = struct_get_names(__ensureFolderDict);
        
        var _i = 0;
        repeat(array_length(_ensureFolderArray))
        {
            var _path = _ensureFolderArray[_i];
            while(_path != "")
            {
                _ensureFolderDict[$ _path] = true;
                _path = filename_dir(_path);
            }
            
            ++_i;
        }
        
        //Add new entries to each array-string
        var _newAudioGroupsString   = _audioGroupsContent.__string;
        var _newFoldersString       = _foldersContent.__string;
        var _newDatafilesString     = _datafilesContent.__string;
        var _newResourcesString     = _resourcesContent.__string;
        var _newTextureGroupsString = _textureGroupsContent.__string;
        
        _newAudioGroupsString   = _funcContentBuild(       _newAudioGroupsString,   _audioGroupsContent.__emptyArray,   __ensureAudioGroupDict,   _yypAudioGroupsDict,   _audioGroupTemplate                 );
        _newFoldersString       = _funcContentBuildFolders(_newFoldersString,       _foldersContent.__emptyArray,       __ensureFolderDict,       _yypFoldersDict,       _folderTemplate                     );
        
        //This line is unnecessary because GameMaker will automatically build its own datafiles index
        //_newDatafilesString     = _funcContentBuild(       _newDatafilesString,     _datafilesContent.__emptyArray,     __ensureDatafileDict,     _yypDatafilesDict,     _datafileTemplate                   );
        
        _newResourcesString     = _funcContentBuildExt(    _newResourcesString,     _resourcesContent.__emptyArray,     __ensureResourceDict,     _yypResourcesDict,     _resourceTemplate,    "resourceType");
        _newTextureGroupsString = _funcContentBuild(       _newTextureGroupsString, _textureGroupsContent.__emptyArray, __ensureTextureGroupDict, _yypTextureGroupsDict, _textureGroupTemplate               );
        
        static _funcContentBuild = function(_string, _isEmptyArray, _ensureDict, _existingDict, _templateString)
        {
            var _ensureArray = struct_get_names(_ensureDict);
            var _addedContent = false;
            var _i = 0;
            repeat(array_length(_ensureArray))
            {
                var _newName = _ensureArray[_i];
                if (not struct_exists(_existingDict, _newName))
                {
                    if ((not _addedContent) && _isEmptyArray)
                    {
                        _string += "\n";
                    }
                    
                    _addedContent = true;
                    _string += string_replace_all(_templateString, "%name%", _newName);
                }
                
                ++_i;
            }
            if (_addedContent && _isEmptyArray) _string += "  ";
            
            return _string;
        }
        
        static _funcContentBuildFolders = function(_string, _isEmptyArray, _ensureDict, _existingDict, _templateString, _replaceExt)
        {
            var _ensureArray = struct_get_names(_ensureDict);
            var _addedContent = false;
            var _i = 0;
            repeat(array_length(_ensureArray))
            {
                var _path = _ensureArray[_i];
                if (not struct_exists(_existingDict, _path))
                {
                    if ((not _addedContent) && _isEmptyArray)
                    {
                        _string += "\n";
                    }
                    
                    _addedContent = true;
                    _string += string_replace_all(string_replace_all(_templateString, "%name%", filename_name(_path)), "%path%", _path);
                }
                
                ++_i;
            }
            if (_addedContent && _isEmptyArray) _string += "  ";
            
            return _string;
        }
        
        static _funcContentBuildExt = function(_string, _isEmptyArray, _ensureDict, _existingDict, _templateString, _replaceExt)
        {
            var _replaceExtSubstring = $"%{_replaceExt}%";
            
            var _ensureArray = struct_get_names(_ensureDict);
            var _addedContent = false;
            var _i = 0;
            repeat(array_length(_ensureArray))
            {
                var _newName = _ensureArray[_i];
                var _newExt  = _ensureDict[$ _newName];
                
                if (not struct_exists(_existingDict, _newName))
                {
                    if ((not _addedContent) && _isEmptyArray)
                    {
                        _string += "\n";
                    }
                    
                    _addedContent = true;
                    _string += string_replace_all(string_replace_all(_templateString, "%name%", _newName), _replaceExtSubstring, _newExt);
                }
                
                ++_i;
            }
            if (_addedContent && _isEmptyArray) _string += "  ";
            
            return _string;
        }
        
        //Inject strings back into the .yyp
        // N.B. Order is important here!
        _yypString = __BucketYYPInject(_yypString, _textureGroupsContent, _newTextureGroupsString);
        _yypString = __BucketYYPInject(_yypString, _resourcesContent,     _newResourcesString);
        _yypString = __BucketYYPInject(_yypString, _datafilesContent,     _newDatafilesString);
        _yypString = __BucketYYPInject(_yypString, _foldersContent,       _newFoldersString);
        _yypString = __BucketYYPInject(_yypString, _audioGroupsContent,   _newAudioGroupsString);
        
        if (_yypString != _oldYYPString)
        {
            //Save the .yyp if anything's changed
            __BucketSaveString(_yypString, GM_project_filename);
        }
    }
    
    static _audioGroupTemplate = "    {\"$GMAudioGroup\":\"v1\",\"%Name\":\"%name%\",\"exportDir\":\"\",\"name\":\"%name%\",\"resourceType\":\"GMAudioGroup\",\"resourceVersion\":\"2.0\",\"targets\":-1,},\n";
    
    static _folderTemplate = "    {\"$GMFolder\":\"\",\"%Name\":\"%name%\",\"folderPath\":\"folders/%path%.yy\",\"name\":\"%name%\",\"resourceType\":\"GMFolder\",\"resourceVersion\":\"2.0\",},\n";
    
    static _datafileTemplate = "    {\"$GMIncludedFile\":\"\",\"%Name\":\"%name%\",\"CopyToMask\":-1,\"filePath\":\"datafiles\",\"name\":\"%name%\",\"resourceType\":\"GMIncludedFile\",\"resourceVersion\":\"2.0\",},\n";
    
    static _resourceTemplate = "    {\"id\":{\"name\":\"%name%\",\"path\":\"%resourceType%/%name%/%name%.yy\",},},\n";
    
    static _textureGroupTemplate = "    {\"$GMTextureGroup\":\"\",\"%Name\":\"%name%\",\"autocrop\":true,\"border\":2,\"compressFormat\":\"bz2\",\"customOptions\":\"\",\"directory\":\"\",\"groupParent\":null,\"isScaled\":true,\"loadType\":\"default\",\"mipsToGenerate\":0,\"name\":\"%name%\",\"resourceType\":\"GMTextureGroup\",\"resourceVersion\":\"2.0\",\"targets\":-1,},\n";
}