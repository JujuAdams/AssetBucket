function BucketCommandList() constructor
{
    __hasBucketCommands  = false;
    __hasProjectCommands = false;
    
    __commandArray         = [];
    __importedDatafileDict = {};
    __importedAssetDict    = {};
    __bucketDict           = {};
    __projectMetadata      = {};
    
    
    
    static DefineBucket = function(_bucketNameOrArray)
    {
        _bucketNameOrArray = __BucketEnsureArray(_bucketNameOrArray);
        
        var _i = 0;
        repeat(array_length(_bucketNameOrArray))
        {
            var _bucketName = _bucketNameOrArray[_i];
            __bucketDict[$ _bucketNameOrArray[_i]] = _bucketName;
            
            ++_i;
        }
    }
    
    static DefineBucketExt = function(_inputName, _outputName)
    {
        __bucketDict[$ _inputName] = _outputName;
    }
    
    static Execute = function(_projectPath)
    {
        var _i = 0;
        repeat(array_length(__commandArray))
        {
            ++_i;
        }
    }
    
    static ExecuteBucketsOnly = function(_exportDirectory)
    {
        var _i = 0;
        repeat(array_length(__commandArray))
        {
            ++_i;
        }
    }
    
    
    
    
    
    static __SetBucketMetadata = function(_bucketName, _alias, _metadata)
    {
        __hasBucketCommands = true;
        
        var _bucket = __GetBucket(_bucketName);
        _bucket.__SetMetadata(_alias, _metadata);
    }
    
    static __AddDatafileToBucket = function(_bucketName, _alias, _sourcePath)
    {
        __hasBucketCommands = true;
        
        var _bucket = __GetBucket(_bucketName);
        _bucket.__AssertAliasUnmodified(_alias);
        
        array_push(__commandArray, method({
            __bucket:     _bucket,
            __alias:      _alias,
            __sourcePath: _sourcePath,
        },
        function()
        {
            var _buffer = buffer_load(__sourcePath);
            __bucket.__AddBuffer(__alias, _buffer, 0, buffer_get_size(_buffer));
            buffer_delete(_buffer);
        }));
    }
    
    static __AddSpriteToBucket = function(_bucketName, _alias, _pathOrArray, _textureGroup)
    {
        __hasBucketCommands = true;
        
        var _bucket = __GetBucket(_bucketName);
        _bucket.__AssertAliasUnmodified(_alias);
        
        array_push(__commandArray, method({
            __bucket:       _bucket,
            __alias:        _alias,
            __pathOrArray:  _pathOrArray,
            __textureGroup: _textureGroup,
        },
        function()
        {
            __bucket.__AddSprite(__textureGroup, __imageArray, __alias);
        }));
    }
    
    static __AddWAVToBucket = function(_bucketName, _alias, _path, _compress)
    {
        __hasBucketCommands = true;
        
        var _bucket = __GetBucket(_bucketName);
        _bucket.__AssertAliasUnmodified(_alias);
        
        array_push(__commandArray, method({
            __bucket:   _bucket,
            __alias:    _alias,
            __path:     _path,
            __compress: _compress,
        },
        function()
        {
            var _buffer = buffer_load(__path);
            __bucket.__AddWAV(__path, __alias, _buffer, 0, __compress);
            buffer_delete(_buffer);
        }));
    }
    
    static __AddOGGToBucket = function(_bucketName, _alias, _path)
    {
        __hasBucketCommands = true;
        
        var _bucket = __GetBucket(_bucketName);
        _bucket.__AssertAliasUnmodified(_alias);
        
        array_push(__commandArray, method({
            __bucket: _bucket,
            __alias:  _alias,
            __path:   _path,
        },
        function()
        {
            __bucket.__AddOGG(__path, __alias);
        }));
    }
    
    static __AddDataBufferToBucket = function(_bucketName, _alias, _bufferDescriptor)
    {
        __hasBucketCommands = true;
        
        var _bucket = __GetBucket(_bucketName);
        _bucket.__AssertAliasUnmodified(_alias);
        
        array_push(__commandArray, method({
            __bucket:           _bucket,
            __alias:            _alias,
            __bufferDescriptor: _bufferDescriptor,
        },
        function()
        {
            with(__bufferDescriptor)
            {
                other.__bucket.__AddBuffer(other.__alias, buffer, offset, size);
                
                if (ownsBuffer)
                {
                    buffer_delete(buffer);
                    buffer = undefined;
                }
            }
        }));
    }
    
    
    
    
    
    static __AssertProjectDatafileUnmodified = function(_localDatafilePath)
    {
        //TODO
    }
    
    static __AssertProjectAssetUnmodified = function(_assetName)
    {
        //TODO
    }
    
    static __SetProjectMetadata = function(_name, _metadata)
    {
        __hasProjectCommands = true;
        __projectMetadata[$ _name] = _metadata;
    }
    
    static __AddDatafileToProject = function(_localDatafilePath, _absoluteSourcePath)
    {
        __hasProjectCommands = true;
        __AssertProjectDatafileUnmodified(_localDatafilePath);
        
        array_push(__commandArray, method({
            __localDatafilePath:  _localDatafilePath,
            __absoluteSourcePath: _absoluteSourcePath,
        },
        function()
        {
            //Unnecessary because GameMaker will automatically build its own datafiles index
            //static _system = __BucketSystem();
            //var _ingestStruct = _system.__currentIngestStruct;
            //_ingestStruct.__EnsureProjectDatafile(__localDatafilePath);
            
            file_copy(__absoluteSourcePath, $"{_system.__currentYYPDirectory}datafiles/{__localDatafilePath}");
        }));
    }
    
    static __AddSpriteToProject = function(_assetName, _pathArray, _projectFolder, _textureGroup)
    {
        __hasProjectCommands = true;
        __AssertProjectAssetUnmodified(_assetName);
        
        array_push(__commandArray, method({
            __assetName:     _assetName,
            __pathArray:     _pathArray,
            __projectFolder: _projectFolder,
            __textureGroup:  _textureGroup,
        },
        function()
        {
            static _system = __BucketSystem();
            var _ingestStruct = _system.__currentIngestStruct;
            
            _ingestStruct.__EnsureProjectSprite(__spriteName);
            _ingestStruct.__EnsureProjectFolder(__projectFolder);
            _ingestStruct.__EnsureProjectTextureGroup(__textureGroup);
            
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
        __AssertProjectAssetUnmodified(_assetName);
        
        array_push(__commandArray, method({
            __assetName:     _assetName,
            __path:          _path,
            __projectFolder: _projectFolder,
            __audioGroup:    _audioGroup,
        },
        function()
        {
            static _system = __BucketSystem();
            var _ingestStruct = _system.__currentIngestStruct;
            
            _ingestStruct.__EnsureProjectSound(__soundName);
            _ingestStruct.__EnsureProjectFolder(__projectFolder);
            _ingestStruct.__EnsureProjectAudioGroup(__audioGroup);
            
            __BucketYYWriteSoundFile(_system.__currentYYPDirectory, BUCKET_PROJECT_NAME,
                                     _rootDirectory + __path,
                                     __assetName, __projectFolder,
                                     __audioGroup);
        }));
    }
    
    static __AddDataBufferToProject = function(_localDatafilePath, _bufferDescriptor)
    {
        __hasProjectCommands = true;
        __AssertProjectDatafileUnmodified(_localDatafilePath);
        
        array_push(__commandArray, method({
            __localDatafilePath: _localDatafilePath,
            __bufferDescriptor:  _bufferDescriptor,
        },
        function()
        {
            static _system = __BucketSystem();
            
            with(__bufferDescriptor)
            {
                buffer_save_ext(buffer, $"{_system.__currentYYPDirectory}datafiles/{other.__localDatafilePath}", offset, size);
                
                if (ownsBuffer)
                {
                    buffer_delete(buffer);
                    buffer = undefined;
                }
            }
        }));
    }
}