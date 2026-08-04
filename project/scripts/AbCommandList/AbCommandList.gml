function AbCommandList() constructor
{
    __hasProjectCommands = false;
    
    __commandArray = [];
    __bucketArray  = [];
    __bucketDict   = {};
    
    __projectDatafileModified = {};
    __projectAssetModified    = {};
    __projectMetadata         = {};
    
    __ensureAudioGroupDict   = {};
    __ensureFolderDict       = {}; //N.B. Must not include trailing backslash
    __ensureDatafileDict     = {};
    __ensureResourceDict     = {};
    __ensureTextureGroupDict = {};
    
    
    
    static __EnsureAb = function(_bucketName)
    {
        var _bucketStruct = __bucketDict[$ _bucketName];
        
        if (not is_struct(_bucketStruct))
        {
            var _bucketStruct = new __AbClassBuildAb(_bucketName);
            __bucketDict[$ _bucketName] = _bucketStruct;
            array_push(__bucketArray, _bucketStruct);
        }
        
        return _bucketStruct;
    }
    
    static SetAbMetadata = function(_value)
    {
        __EnsureAb(_bucketName).__metadata = _value;
    }
    
    static SetAbAliasMetadata = function(_bucketName, _key, _value)
    {
        __EnsureAb(_bucketName).__SetMetadata(_key, _value);
    }
    
    static AddDatafileToBucket = function(_bucketName, _alias, _sourcePath)
    {
        var _bucket = __EnsureAb(_bucketName);
        _bucket.__SetDatafileAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket: _bucket,
            __alias:  _alias,
            __path:   _sourcePath,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            var _buffer = buffer_load(__path);
            __bucket.__AddBuffer(__alias, _buffer, 0, buffer_get_size(_buffer));
            buffer_delete(_buffer);
        }));
    }
    
    static AddSpriteToBucket = function(_bucketName, _alias, _sourcePathOrArray, _textureGroup = _bucketName)
    {
        var _sourcePathArray = __AbEnsureArray(_sourcePathOrArray);
        
        var _bucket = __EnsureAb(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket:       _bucket,
            __alias:        _alias,
            __pathArray:    _sourcePathOrArray,
            __textureGroup: _textureGroup,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            __bucket.__AddSprite(__alias, __pathArray, __textureGroup);
        }));
    }
    
    static AddSoundToBucket = function(_bucketName, _alias, _sourcePath, _forceFormat = undefined)
    {
        var _bucket = __EnsureAb(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket:      _bucket,
            __alias:       _alias,
            __path:        _sourcePath,
            __forceFormat: _forceFormat,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            if (__forceFormat == undefined)
            {
                var _extension = filename_ext(__path);
                if (_extension == ".wav")
                {
                    var _audioFormat = AB_AUDIO_FORMAT_WAV;
                }
                else if (_extension == ".ogg")
                {
                    var _audioFormat = AB_AUDIO_FORMAT_OGG;
                }
                else
                {
                    __AbError($"Audio file extension \"{_extension}\" not supported (must be .wav or .ogg)\nPath was \"{__path}\"");
                }
            }
            else
            {
                var _audioFormat = __forceFormat;
            }
            
            if ((_audioFormat == AB_AUDIO_FORMAT_WAV) || (_audioFormat == AB_AUDIO_FORMAT_WAV_ZLIB))
            {
                var _buffer = buffer_load(__path);
                __bucket.__AddWAV(__alias, __path, _buffer, 0, (_audioFormat == AB_AUDIO_FORMAT_WAV_ZLIB));
                buffer_delete(_buffer);
            }
            else if (_audioFormat == AB_AUDIO_FORMAT_OGG)
            {
                __bucket.__AddOGG(__alias, __path);
            }
            else
            {
                __AbError($"Audio format \"{_audioFormat}\" not supported");
            }
        }));
    }
    
    static AddBufferToBucket = function(_bucketName, _alias, _bufferDescription)
    {
        _bufferDescription = __AbEnsureBufferDescription(_bufferDescription);
        
        var _bucket = __EnsureAb(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket:           _bucket,
            __alias:            _alias,
            __bufferDescription: _bufferDescription,
        },
        function(_projectStruct, _datafilesDirectory)
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
    
    
    
    
    
    static __SetProjectDatafileAsModified = function(_localDatafilePath)
    {
        if (struct_exists(__projectDatafileModified, _localDatafilePath))
        {
            __AbError($"Project datafile \"{_localDatafilePath}\" has already been modified by another command");
        }
        
        __projectDatafileModified[$ _localDatafilePath] = true;
    }
    
    static __SetProjectAssetAsModified = function(_assetName)
    {
        if (struct_exists(__projectAssetModified, _assetName))
        {
            __AbError($"Project datafile \"{_assetName}\" has already been modified by another command");
        }
        
        __projectAssetModified[$ _assetName] = true;
    }
    
    static SetProjectMetadata = function(_key, _value)
    {
        __hasProjectCommands = true;
        if (_value == undefined) return;
        
        __projectMetadata[$ _key] = _value;
    }
    
    static AddDatafileToProject = function(_localDatafilePath, _absoluteSourcePath)
    {
        __hasProjectCommands = true;
        __SetProjectDatafileAsModified(_localDatafilePath);
        
        array_push(__commandArray, method({
            __localDatafilePath:  _localDatafilePath,
            __absoluteSourcePath: _absoluteSourcePath,
            __commandList:        other,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            __commandList.__EnsureProjectDatafile(__localDatafilePath);
            file_copy(__absoluteSourcePath, _datafilesDirectory + __localDatafilePath);
        }));
    }
    
    static AddSpriteToProject = function(_assetName, _pathOrArray, _width, _height, _projectFolder, _textureGroup = "Default")
    {
        _pathOrArray = __AbEnsureArray(_pathOrArray);
        
        __hasProjectCommands = true;
        __SetProjectAssetAsModified(_assetName);
        
        array_push(__commandArray, method({
            __assetName:     _assetName,
            __pathArray:     _pathOrArray,
            __width:         _width,
            __height:        _height,
            __projectFolder: _projectFolder,
            __textureGroup:  _textureGroup,
            __commandList:   other,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            __commandList.__EnsureProjectSprite(__assetName);
            __commandList.__EnsureProjectFolder(__projectFolder);
            __commandList.__EnsureProjectTextureGroup(__textureGroup);
            _projectStruct.__SaveSprite(__pathArray, __assetName, __width, __height, __projectFolder, __textureGroup);
        }));
    }
    
    static AddSoundToProject = function(_assetName, _path, _projectFolder, _compressionSetting = undefined, _audioGroup = undefined)
    {
        __hasProjectCommands = true;
        __SetProjectAssetAsModified(_assetName);
        
        array_push(__commandArray, method({
            __assetName:          _assetName,
            __path:               _path,
            __projectFolder:      _projectFolder,
            __audioGroup:         _audioGroup,
            __compressionSetting: _compressionSetting,
            __commandList:        other,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            __commandList.__EnsureProjectSound(__assetName);
            
            if (__projectFolder != undefined)
            {
                __commandList.__EnsureProjectFolder(__projectFolder);
            }
            
            if (__audioGroup != undefined)
            {
                __commandList.__EnsureProjectAudioGroup(__audioGroup);
            }
            
            _projectStruct.__SaveSound(__path, __assetName, __projectFolder, __compressionSetting, __audioGroup);
        }));
    }
    
    static AddDataBufferToProject = function(_localDatafilePath, _bufferDescription)
    {
        _bufferDescription = __AbEnsureBufferDescription(_bufferDescription);
        
        __hasProjectCommands = true;
        __SetProjectDatafileAsModified(_localDatafilePath);
        
        array_push(__commandArray, method({
            __localDatafilePath: _localDatafilePath,
            __bufferDescription: _bufferDescription,
            __commandList:       other,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            static _system = __AbSystem();
            
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
        _projectFolder = __AbTrimDirectory(_projectFolder);
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
    
    
    
    
    
    static SaveBucketsToDirectory = function(_directory)
    {
        if (__hasProjectCommands)
        {
            __AbWarning("Called `SaveBucketsToDirectory()` but command list has project commands. Project commands will be ignored");
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
        
        var _json = json_stringify({
            type:    "loose manifest v1",
            buckets: _bucketExportArray,
        })
        
        __AbSaveString(_json, _directory + AB_MANIFEST_FILENAME);
    }
    
    static __SaveBuckets = function(_directory)
    {
        var _bucketExportArray = [];
        
        var _i = 0;
        repeat(array_length(__bucketArray))
        {
            var _bucket = __bucketArray[_i];
            _bucket.__SaveToDirectory(_directory);
            __EnsureProjectDatafile(_bucket.__coreFilename);
            
            array_push(_bucketExportArray, {
                bucketName: _bucket.__name,
                filename:   _bucket.__headerFilename,
            });
            
            ++_i;
        }
        
        return _bucketExportArray;
    }
    
    static SaveToProject = function(_projectStruct)
    {
        var _datafilesDirectory = _projectStruct.__datafilesDirectory;
        
        //Execute all commands
        var _commandArray = __commandArray;
        var _i = 0;
        repeat(array_length(_commandArray))
        {
            _commandArray[_i](_projectStruct, _datafilesDirectory);
            ++_i;
        }
        
        //Save buckets into the datafiles directory
        var _bucketExportArray = __SaveBuckets(_datafilesDirectory);
        
        //TODO - Find old manifest and clean up any old bucket files
        file_delete(_datafilesDirectory + AB_MANIFEST_FILENAME);
        
        //If we have any exported buckets or metadata then save that to the manifest
        if ((array_length(_bucketExportArray) > 0) || (struct_names_count(__projectMetadata) > 0))
        {
            var _json = json_stringify({
                type:            "project manifest v1",
                buckets:         _bucketExportArray,
                projectMetadata: __projectMetadata,
            });
            
            __AbSaveString(_json, _datafilesDirectory + AB_MANIFEST_FILENAME);
            __EnsureProjectDatafile(AB_MANIFEST_FILENAME);
        }
        
        //Save new project references
        _projectStruct.__SaveYY(__ensureAudioGroupDict,
                                __ensureFolderDict,
                                __ensureDatafileDict,
                                __ensureResourceDict,
                                __ensureTextureGroupDict);
        _projectStruct.__Destroy();
    }
}