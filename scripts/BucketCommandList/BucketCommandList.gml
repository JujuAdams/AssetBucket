function BucketCommandList() constructor
{
    __hasProjectCommands = false;
    
    __commandArray = [];
    __bucketDict   = {};
    
    __projectDatafileModified = {};
    __projectAssetModified    = {};
    __projectMetadata         = {};
    
    __ensureAudioGroupDict   = {};
    __ensureFolderDict       = {}; //N.B. Must not include trailing backslash
    __ensureDatafileDict     = {};
    __ensureResourceDict     = {};
    __ensureTextureGroupDict = {};
    
    
    
    static DefineBucket = function(_bucketNameOrArray)
    {
        _bucketNameOrArray = __BucketEnsureArray(_bucketNameOrArray);
        
        var _i = 0;
        repeat(array_length(_bucketNameOrArray))
        {
            var _bucketName = _bucketNameOrArray[_i];
            __bucketDict[$ _bucketName] = new __BucketClassBuildBucket(_bucketName);
            ++_i;
        }
    }
    
    static __GetBucket = function(_bucketName)
    {
        var _bucket = __bucketDict[$ _bucketName];
        
        if (not is_struct(_bucket))
        {
            __BucketError($"Bucket name \"{_bucketName}\" not recognised");
        }
        
        return _bucket;
    }
    
    
    
    
    
    static __SetBucketMetadata = function(_bucketName, _key, _value)
    {
        if (_value == undefined) return;
        __GetBucket(_bucketName).__SetMetadata(_key, _value);
    }
    
    static __AddDatafileToBucket = function(_bucketName, _alias, _path)
    {
        var _bucket = __GetBucket(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket: _bucket,
            __alias:  _alias,
            __path:   _path,
        },
        function(_projectPath, _datafilesDirectory)
        {
            var _buffer = buffer_load(__path);
            __bucket.__AddBuffer(__alias, _buffer, 0, buffer_get_size(_buffer));
            buffer_delete(_buffer);
        }));
    }
    
    static __AddSpriteToBucket = function(_bucketName, _alias, _pathOrArray, _textureGroup)
    {
        var _bucket = __GetBucket(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket:       _bucket,
            __alias:        _alias,
            __pathOrArray:  _pathOrArray,
            __textureGroup: _textureGroup,
        },
        function(_projectPath, _datafilesDirectory)
        {
            __bucket.__AddSprite(__alias, __pathOrArray, __textureGroup);
        }));
    }
    
    static __AddWAVToBucket = function(_bucketName, _alias, _path, _compress)
    {
        var _bucket = __GetBucket(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket:   _bucket,
            __alias:    _alias,
            __path:     _path,
            __compress: _compress,
        },
        function(_projectPath, _datafilesDirectory)
        {
            var _buffer = buffer_load(__path);
            __bucket.__AddWAV(__alias, __path, _buffer, 0, __compress);
            buffer_delete(_buffer);
        }));
    }
    
    static __AddOGGToBucket = function(_bucketName, _alias, _path)
    {
        var _bucket = __GetBucket(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket: _bucket,
            __alias:  _alias,
            __path:   _path,
        },
        function(_projectPath, _datafilesDirectory)
        {
            __bucket.__AddOGG(__alias, __path);
        }));
    }
    
    static __AddBufferToBucket = function(_bucketName, _alias, _bufferDescription)
    {
        var _bucket = __GetBucket(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket:           _bucket,
            __alias:            _alias,
            __bufferDescription: _bufferDescription,
        },
        function(_projectPath, _datafilesDirectory)
        {
            with(__bufferDescription)
            {
                other.__bucket.__AddBuffer(other.__alias, buffer, offset, size);
                
                //TODO - Move to `.Destroy()` method
                if (ownsBuffer)
                {
                    buffer_delete(buffer);
                    buffer = undefined;
                }
            }
        }));
    }
    
    
    
    
    
    static __SetProjectDatafileAsMmodified = function(_localDatafilePath)
    {
        if (struct_exists(__projectDatafileModified, _localDatafilePath))
        {
            __BucketError($"Project datafile \"{_localDatafilePath}\" has already been modified by another command");
        }
        
        __projectDatafileModified[$ _localDatafilePath] = true;
    }
    
    static __SetProjectAssetAsMmodified = function(_assetName)
    {
        if (struct_exists(__projectAssetModified, _assetName))
        {
            __BucketError($"Project datafile \"{_assetName}\" has already been modified by another command");
        }
        
        __projectAssetModified[$ _assetName] = true;
    }
    
    static __SetProjectMetadata = function(_key, _value)
    {
        __hasProjectCommands = true;
        if (_value == undefined) return;
        
        __projectMetadata[$ _key] = _value;
    }
    
    static __AddDatafileToProject = function(_localDatafilePath, _absoluteSourcePath)
    {
        __hasProjectCommands = true;
        __SetProjectDatafileAsMmodified(_localDatafilePath);
        
        array_push(__commandArray, method({
            __localDatafilePath:  _localDatafilePath,
            __absoluteSourcePath: _absoluteSourcePath,
        },
        function(_projectPath, _datafilesDirectory)
        {
            __EnsureProjectDatafile(__localDatafilePath);
            file_copy(__absoluteSourcePath, _datafilesDirectory + __localDatafilePath);
        }));
    }
    
    static __AddSpriteToProject = function(_assetName, _pathArray, _projectFolder, _textureGroup)
    {
        __hasProjectCommands = true;
        __SetProjectAssetAsMmodified(_assetName);
        
        array_push(__commandArray, method({
            __assetName:     _assetName,
            __pathArray:     _pathArray,
            __projectFolder: _projectFolder,
            __textureGroup:  _textureGroup,
        },
        function(_projectPath, _datafilesDirectory)
        {
            __EnsureProjectSprite(__spriteName);
            __EnsureProjectFolder(__projectFolder);
            __EnsureProjectTextureGroup(__textureGroup);
            
            if (is_struct(__pathArray[0]))
            {
                var _width  = __pathArray[0].width;
                var _height = __pathArray[0].height;
            }
            else
            {
                var _fileInfo = __BucketEnsureIngestFileInfo(__pathArray[0]);
                var _width  = _fileInfo.__GetWidth();
                var _height = _fileInfo.__GetHeight();
            }
            
            __BucketYYWriteSpriteFile(_system.__currentYYPDirectory, BUCKET_PROJECT_NAME,
                                      _rootDirectory, __pathArray,
                                      __spriteName, _width, _height,
                                      __projectFolder, __textureGroup);
        }));
    }
    
    static __AddSoundToProject = function(_assetName, _path, _projectFolder, _audioGroup)
    {
        __hasProjectCommands = true;
        __SetProjectAssetAsMmodified(_assetName);
        
        array_push(__commandArray, method({
            __assetName:     _assetName,
            __path:          _path,
            __projectFolder: _projectFolder,
            __audioGroup:    _audioGroup,
        },
        function(_projectPath, _datafilesDirectory)
        {
            __EnsureProjectSound(__soundName);
            __EnsureProjectFolder(__projectFolder);
            __EnsureProjectAudioGroup(__audioGroup);
            
            __BucketYYWriteSoundFile(_system.__currentYYPDirectory, BUCKET_PROJECT_NAME,
                                     _rootDirectory + __path,
                                     __assetName, __projectFolder,
                                     __audioGroup);
        }));
    }
    
    static __AddDataBufferToProject = function(_localDatafilePath, _bufferDescription)
    {
        __hasProjectCommands = true;
        __SetProjectDatafileAsMmodified(_localDatafilePath);
        
        array_push(__commandArray, method({
            __localDatafilePath: _localDatafilePath,
            __bufferDescription:  _bufferDescription,
        },
        function(_projectPath, _datafilesDirectory)
        {
            static _system = __BucketSystem();
            
            with(__bufferDescription)
            {
                buffer_save_ext(buffer, _datafilesDirectory + other.__localDatafilePath, offset, size);
                
                //TODO - Move to `.Destroy()` method
                if (ownsBuffer)
                {
                    buffer_delete(buffer);
                    buffer = undefined;
                }
            }
        }));
    }
    
    
    
    
    
    static __EnsureProjectDatafile = function(_filename)
    {
        //Unnecessary because GameMaker will automatically build its own datafiles index
        //__ensureDatafileDict[$ _filename] = true;
    }
    
    static __EnsureProjectSprite = function(_spriteName)
    {
        __ensureResourceDict[$ _spriteName] = "sprites";
    }
    
    static __EnsureProjectSound = function(_audioName)
    {
        __ensureResourceDict[$ _audioName] = "sounds";
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
    
    
    
    
    
    static ExecuteBucketsOnly = function(_directory)
    {
        if (__hasProjectCommands)
        {
            __BucketWarning("Called `ExecuteBucketsOnly()` but command list has project commands. Project commands will be ignored");
        }
        
        var _commandArray = __commandArray;
        var _i = 0;
        repeat(array_length(_commandArray))
        {
            var _command = _commandArray[_i];
            
            if (struct_exists(method_get_self(_command), "bucket"))
            {
                _command(undefined, _directory);
            }
            
            ++_i;
        }
        
        var _bucketExportArray = __SaveBuckets(_directory);
        __BucketSaveString(json_stringify(_bucketExportArray), _directory + BUCKET_MANIFEST_FILENAME);
    }
    
    static __SaveBuckets = function(_directory)
    {
        var _bucketExportArray = [];
        
        var _i = 0;
        repeat(array_length(__bucketArray))
        {
            var _bucket = __bucketArray[_i];
            _bucket.__SaveToDirectory(_directory);
            __EnsureProjectDatafile(_bucket.__GetCoreFilename());
            
            array_push(_bucketExportArray, {
                name:     _bucket.__name,
                blobSize: int64(_bucket.__GetCoreSize()),
                metadata: _bucket.__metadata,
            });
            
            ++_i;
        }
        
        return _bucketExportArray;
    }
    
    static Execute = function(_projectPath)
    {
        if (file_exists(_projectPath))
        {
            __BucketError($"Could not find \"{_projectPath}\"");
        }
        
        var _datafilesDirectory = $"{filename_dir(_projectPath)}/datafiles/";
        
        //Execute all commands
        var _commandArray = __commandArray;
        var _i = 0;
        repeat(array_length(_commandArray))
        {
            _commandArray[_i](_projectPath, _datafilesDirectory);
            ++_i;
        }
        
        //Save buckets into the datafiles directory
        var _bucketExportArray = __SaveBuckets(_datafilesDirectory);
        
        //TODO - Find old manifest and clean up any old bucket files
        file_delete(_datafilesDirectory + BUCKET_MANIFEST_FILENAME);
        
        //If we have any exported buckets or metadata then save that to the manifest
        if ((array_length(_bucketExportArray) > 0) || (struct_names_count(__projectMetadata) > 0))
        {
            var _json = json_stringify({
                buckets:  _bucketExportArray,
                metadata: __projectMetadata,
            });
            
            __BucketSaveString(_json, _datafilesDirectory + BUCKET_MANIFEST_FILENAME);
            __EnsureProjectDatafile(BUCKET_MANIFEST_FILENAME);
        }
        
        //Skip .yyp modification if we have nothing to add
        if ((struct_names_count(__ensureAudioGroupDict) <= 0)
        &&  (struct_names_count(__ensureFolderDict) <= 0)
        &&  (struct_names_count(__ensureDatafileDict) <= 0)
        &&  (struct_names_count(__ensureResourceDict) <= 0)
        &&  (struct_names_count(__ensureTextureGroupDict) <= 0))
        {
            return;
        }
        
        //Load the base project .yy
        file_copy(_projectPath, $"{_projectPath}.old");
        var _yypString = __BucketLoadString(_projectPath);
        var _oldYYPString = _yypString;
        
        //Extract arrays as strings from the .yyp
        var _audioGroupsContent   = __BucketYYPExtract(_yypString, "AudioGroups");
        var _foldersContent       = __BucketYYPExtract(_yypString, "Folders");
        var _datafilesContent     = __BucketYYPExtract(_yypString, "IncludedFiles");
        var _resourcesContent     = __BucketYYPExtract(_yypString, "resources");
        var _textureGroupsContent = __BucketYYPExtract(_yypString, "TextureGroups");
        
        if (_audioGroupsContent.__error)
        {
            __BucketError($"Failed to extract audio groups from \"{_projectPath}\"");
        }
        
        if (_foldersContent.__error)
        {
            __BucketError($"Failed to extract IDE folders from \"{_projectPath}\"");
        }
        
        if (_datafilesContent.__error)
        {
            __BucketError($"Failed to extract datafiles from \"{_projectPath}\"");
        }
        
        if (_resourcesContent.__error)
        {
            __BucketError($"Failed to extract resources from \"{_projectPath}\"");
        }
        
        if (_textureGroupsContent.__error)
        {
            __BucketError($"Failed to extract texture groups from \"{_projectPath}\"");
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
        _newDatafilesString     = _funcContentBuild(       _newDatafilesString,     _datafilesContent.__emptyArray,     __ensureDatafileDict,     _yypDatafilesDict,     _datafileTemplate                   );
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
            __BucketSaveString(_yypString, _projectPath);
        }
    }
    
    static _audioGroupTemplate = "    {\"$GMAudioGroup\":\"v1\",\"%Name\":\"%name%\",\"exportDir\":\"\",\"name\":\"%name%\",\"resourceType\":\"GMAudioGroup\",\"resourceVersion\":\"2.0\",\"targets\":-1,},\n";
    
    static _folderTemplate = "    {\"$GMFolder\":\"\",\"%Name\":\"%name%\",\"folderPath\":\"folders/%path%.yy\",\"name\":\"%name%\",\"resourceType\":\"GMFolder\",\"resourceVersion\":\"2.0\",},\n";
    
    static _datafileTemplate = "    {\"$GMIncludedFile\":\"\",\"%Name\":\"%name%\",\"CopyToMask\":-1,\"filePath\":\"datafiles\",\"name\":\"%name%\",\"resourceType\":\"GMIncludedFile\",\"resourceVersion\":\"2.0\",},\n";
    
    static _resourceTemplate = "    {\"id\":{\"name\":\"%name%\",\"path\":\"%resourceType%/%name%/%name%.yy\",},},\n";
    
    static _textureGroupTemplate = "    {\"$GMTextureGroup\":\"\",\"%Name\":\"%name%\",\"autocrop\":true,\"border\":2,\"compressFormat\":\"bz2\",\"customOptions\":\"\",\"directory\":\"\",\"groupParent\":null,\"isScaled\":true,\"loadType\":\"default\",\"mipsToGenerate\":0,\"name\":\"%name%\",\"resourceType\":\"GMTextureGroup\",\"resourceVersion\":\"2.0\",\"targets\":-1,},\n";
}