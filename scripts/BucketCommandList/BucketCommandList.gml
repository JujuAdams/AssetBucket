function BucketCommandList() constructor
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
    
    
    
    static __EnsureBucket = function(_bucketName)
    {
        var _bucketStruct = __bucketDict[$ _bucketName];
        
        if (not is_struct(_bucketStruct))
        {
            var _bucketStruct = new __BucketClassBuildBucket(_bucketName);
            __bucketDict[$ _bucketName] = _bucketStruct;
            array_push(__bucketArray, _bucketStruct);
        }
        
        return _bucketStruct;
    }
    
    static SetBucketMetadata = function(_value)
    {
        __EnsureBucket(_bucketName).__metadata = _value;
    }
    
    static SetBucketAliasMetadata = function(_bucketName, _key, _value)
    {
        __EnsureBucket(_bucketName).__SetMetadata(_key, _value);
    }
    
    static AddDatafileToBucket = function(_bucketName, _alias, _path)
    {
        var _bucket = __EnsureBucket(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket: _bucket,
            __alias:  _alias,
            __path:   _path,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            var _buffer = buffer_load(__path);
            __bucket.__AddBuffer(__alias, _buffer, 0, buffer_get_size(_buffer));
            buffer_delete(_buffer);
        }));
    }
    
    static AddSpriteToBucket = function(_bucketName, _alias, _pathOrArray, _textureGroup = "Default")
    {
        _pathOrArray = __BucketEnsureArray(_pathOrArray);
        
        var _bucket = __EnsureBucket(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket:       _bucket,
            __alias:        _alias,
            __pathOrArray:  _pathOrArray,
            __textureGroup: _textureGroup,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            __bucket.__AddSprite(__alias, __pathOrArray, __textureGroup);
        }));
    }
    
    static AddWAVToBucket = function(_bucketName, _alias, _path, _compress = false)
    {
        var _bucket = __EnsureBucket(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket:   _bucket,
            __alias:    _alias,
            __path:     _path,
            __compress: _compress,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            var _buffer = buffer_load(__path);
            __bucket.__AddWAV(__alias, __path, _buffer, 0, __compress);
            buffer_delete(_buffer);
        }));
    }
    
    static AddOGGToBucket = function(_bucketName, _alias, _path)
    {
        var _bucket = __EnsureBucket(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket: _bucket,
            __alias:  _alias,
            __path:   _path,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            __bucket.__AddOGG(__alias, __path);
        }));
    }
    
    static AddBufferToBucket = function(_bucketName, _alias, _bufferDescription)
    {
        _bufferDescription = __BucketEnsureBufferDescription(_bufferDescription);
        
        var _bucket = __EnsureBucket(_bucketName);
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
            __BucketError($"Project datafile \"{_localDatafilePath}\" has already been modified by another command");
        }
        
        __projectDatafileModified[$ _localDatafilePath] = true;
    }
    
    static __SetProjectAssetAsModified = function(_assetName)
    {
        if (struct_exists(__projectAssetModified, _assetName))
        {
            __BucketError($"Project datafile \"{_assetName}\" has already been modified by another command");
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
    
    static AddSpriteToProject = function(_assetName, _pathOrArray, _projectFolder, _textureGroup = "Default")
    {
        _pathOrArray = __BucketEnsureArray(_pathOrArray);
        
        __hasProjectCommands = true;
        __SetProjectAssetAsModified(_assetName);
        
        array_push(__commandArray, method({
            __assetName:     _assetName,
            __pathArray:     _pathOrArray,
            __projectFolder: _projectFolder,
            __textureGroup:  _textureGroup,
            __commandList:   other,
        },
        function(_projectStruct, _datafilesDirectory)
        {
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
            
            __commandList.__EnsureProjectSprite(__assetName);
            __commandList.__EnsureProjectFolder(__projectFolder);
            __commandList.__EnsureProjectTextureGroup(__textureGroup);
            _projectStruct.__SaveSprite(__pathArray, __assetName, _width, _height, __projectFolder, __textureGroup);
        }));
    }
    
    static AddSoundToProject = function(_assetName, _path, _projectFolder, _audioGroup = "audiogroup_default")
    {
        __hasProjectCommands = true;
        __SetProjectAssetAsModified(_assetName);
        
        array_push(__commandArray, method({
            __assetName:     _assetName,
            __path:          _path,
            __projectFolder: _projectFolder,
            __audioGroup:    _audioGroup,
            __commandList:   other,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            __commandList.__EnsureProjectSound(__assetName);
            __commandList.__EnsureProjectFolder(__projectFolder);
            __commandList.__EnsureProjectAudioGroup(__audioGroup);
            _projectStruct.__SaveSound(__path, __assetName, __projectFolder, __audioGroup);
        }));
    }
    
    static AddDataBufferToProject = function(_localDatafilePath, _bufferDescription)
    {
        _bufferDescription = __BucketEnsureBufferDescription(_bufferDescription);
        
        __hasProjectCommands = true;
        __SetProjectDatafileAsModified(_localDatafilePath);
        
        array_push(__commandArray, method({
            __localDatafilePath: _localDatafilePath,
            __bufferDescription: _bufferDescription,
            __commandList:       other,
        },
        function(_projectStruct, _datafilesDirectory)
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
    
    
    
    
    
    static SaveBucketsToDirectory = function(_directory)
    {
        if (__hasProjectCommands)
        {
            __BucketWarning("Called `SaveBucketsToDirectory()` but command list has project commands. Project commands will be ignored");
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
                name:          _bucket.__name,
                blobSize:      int64(_bucket.__GetCoreSize()),
                metadata:      _bucket.__metadata,
                aliasMetadata: _bucket.__aliasMetadataDict,
            });
            
            ++_i;
        }
        
        return _bucketExportArray;
    }
    
    static SaveToProject = function(_projectPath)
    {
        var _projectStruct = new __BucketClassProject(_projectPath);
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
        
        //Save new project references
        _projectStruct.__SaveYY(__ensureAudioGroupDict,
                                __ensureFolderDict,
                                __ensureDatafileDict,
                                __ensureResourceDict,
                                __ensureTextureGroupDict);
        _projectStruct.__Destroy();
    }
}