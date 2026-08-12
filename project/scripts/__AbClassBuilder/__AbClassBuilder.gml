/// @param projectStruct
/// @param bucketDirectory

function __AbClassBuilder(_projectStruct, _bucketDirectory) constructor
{
    __projectStruct   = _projectStruct;
    __bucketDirectory = _bucketDirectory;
    
    __hasProjectCommands = false;
    
    __commandArray = [];
    __bucketArray  = [];
    __bucketDict   = {};
    
    __callbackOnEndArray = [];
    __destroySourceOnEndArray = [];
    
    __projectDatafileModified = {};
    __projectAssetModified    = {};
    __projectMetadata         = {};
    
    __ensureAudioGroupDict   = {};
    __ensureFolderDict       = {}; //N.B. Must not include trailing backslash
    __ensureDatafileDict     = {};
    __ensureResourceDict     = {};
    __ensureTextureGroupDict = {};
    
    
    
    static __AddCallbackOnEnd = function(_callback, _callbackMetadata)
    {
        array_push(__callbackOnEndArray, {
            __callback: _callback,
            __callbackMetadata: _callbackMetadata,
        });
    }
    
    static __DestroySourceOnEnd = function(_source)
    {
        array_push(__destroySourceOnEndArray, _source);
    }
    
    static __EnsureBucket = function(_bucketName)
    {
        var _bucketStruct = __bucketDict[$ _bucketName];
        
        if (not is_struct(_bucketStruct))
        {
            var _bucketStruct = new __AbClassBuilderBucket(_bucketName);
            __bucketDict[$ _bucketName] = _bucketStruct;
            array_push(__bucketArray, _bucketStruct);
        }
        
        return _bucketStruct;
    }
    
    static __SetBucketMetadata = function(_bucketName, _key, _value)
    {
        __EnsureBucket(_bucketName).__SetMetadata(_key, _value);
    }
    
    static __AddDatafileToBucket = function(_bucketName, _alias, _source)
    {
        var _bucket = __EnsureBucket(_bucketName);
        _bucket.__SetDatafileAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket: _bucket,
            __alias:  _alias,
            __source: _source,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            if (is_string(__source))
            {
                var _buffer = buffer_load(__source);
                __bucket.__AddBuffer(__alias, _buffer, 0, buffer_get_size(_buffer));
                buffer_delete(_buffer);
            }
            else if (is_handle(__source))
            {
                if (buffer_exists(__source))
                {
                    __bucket.__AddBuffer(__alias, __source, 0, buffer_get_size(__source));
                }
                else if (surface_exists(__source))
                {
                    var _buffer = __AbSurfaceGetBuffer(__surface);
                    __bucket.__AddBuffer(__alias, _buffer, 0, buffer_get_size(_buffer));
                    buffer_delete(_buffer);
                }
                else if (sprite_exists(__source))
                {
                    if (sprite_get_number(__source) == 1)
                    {
                        var _buffer = __AbSpriteGetBuffer(__source, 0);
                        __bucket.__AddBuffer(__alias, _buffer, 0, buffer_get_size(_buffer));
                        buffer_delete(_buffer);
                    }
                    else
                    {
                        var _i = 0;
                        repeat(sprite_get_number(__source))
                        {
                            var _buffer = __AbSpriteGetBuffer(__source, _i);
                            __bucket.__AddBuffer($"{__alias}_image{_i}", _buffer, 0, buffer_get_size(_buffer));
                            buffer_delete(_buffer);
                            ++_i;
                        }
                    }
                }
                else
                {
                    __AbError($"Source type not supported ({typeof(__source)})");
                }
            }
            else if (is_struct(__source))
            {
                if (is_instanceof(__source, AbFileDescription))
                {
                    var _buffer = buffer_load(__source.absolutePath);
                    __bucket.__AddBuffer(__alias, _buffer, 0, buffer_get_size(_buffer));
                    buffer_delete(_buffer);
                }
                else if (is_instanceof(__source, AbBufferDescription))
                {
                    __bucket.__AddBuffer(__alias, __source.buffer, __source.offset, __source.size);
                }
                else if (is_instanceof(__source, AbSurfaceDescription))
                {
                    var _buffer = __AbSurfacePartGetBuffer(__source.surface, __source.left, __source.top, __source.width, __source.height);
                    __bucket.__AddBuffer(__alias, _buffer, 0, buffer_get_size(_buffer));
                    buffer_delete(_buffer);
                }
                else
                {
                    __AbError($"Source struct not supported ({instanceof(__source)})");
                }
            }
            else
            {
                __AbError($"Source type not supported ({typeof(__source)})");
            }
        }));
    }
    
    static __AddSpriteToBucket = function(_bucketName, _spriteDesc, _textureGroup = _bucketName)
    {
        var _bucket = __EnsureBucket(_bucketName);
        _bucket.__SetAliasAsModified(_spriteDesc.assetName);
        
        array_push(__commandArray, method({
            __bucket:     _bucket,
            __spriteDesc: _spriteDesc,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            __bucket.__AddSprite(__spriteDesc);
        }));
    }
    
    static __AddSoundToBucket = function(_bucketName, _alias, _source, _forceFormat = undefined)
    {
        var _bucket = __EnsureBucket(_bucketName);
        _bucket.__SetAliasAsModified(_alias);
        
        array_push(__commandArray, method({
            __bucket:      _bucket,
            __alias:       _alias,
            __source:      _source,
            __forceFormat: _forceFormat,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            if (__forceFormat != undefined)
            {
                var _audioFormat = __forceFormat;
            }
            else
            {
                if (not is_string(__source))
                {
                    __AbError($"Must specify sound format if source is not an audio\nSource type was \"{typeof(__source)}\"");
                }
                
                var _extension = filename_ext(__source);
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
                    __AbError($"Audio file extension \"{_extension}\" not supported (must be .wav or .ogg)\nPath was \"{__source}\"");
                }
            }
            
            if ((_audioFormat == AB_AUDIO_FORMAT_WAV) || (_audioFormat == AB_AUDIO_FORMAT_WAV_ZLIB))
            {
                __bucket.__AddWAV(__alias, __source, (_audioFormat == AB_AUDIO_FORMAT_WAV_ZLIB));
            }
            else if (_audioFormat == AB_AUDIO_FORMAT_OGG)
            {
                __bucket.__AddOGG(__alias, __source);
            }
            else
            {
                __AbError($"Audio format \"{_audioFormat}\" not supported");
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
    
    static __SetProjectMetadata = function(_key, _value)
    {
        __hasProjectCommands = true;
        if (_value == undefined)
        {
            struct_remove(__projectMetadata, _value);
        }
        else
        {
            __projectMetadata[$ _key] = _value;
        }
    }
    
    static __AddDatafileToProject = function(_datafilesPath, _source)
    {
        __hasProjectCommands = true;
        __SetProjectDatafileAsModified(_datafilesPath);
        
        __EnsureProjectDatafile(_datafilesPath);
        
        array_push(__commandArray, method({
            __datafilesPath: _datafilesPath,
            __source: _source,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            var _absolutePath = _datafilesDirectory + __datafilesPath;
            
            if (is_string(__source))
            {
                file_copy(__source, _absolutePath);
            }
            else if (is_handle(__source))
            {
                if (buffer_exists(__source))
                {
                    buffer_save(__source, _absolutePath);
                }
                else if (surface_exists(__source))
                {
                    surface_save(__source, _absolutePath);
                }
                else if (sprite_exists(__source))
                {
                    if (sprite_get_number(__source) == 1)
                    {
                        sprite_save(__source, 0, _absolutePath);
                    }
                    else
                    {
                        var _extension = filename_ext(_absolutePath);
                        var _basePath = filename_change_ext(_absolutePath, "");
                        
                        var _i = 0;
                        repeat(sprite_get_number(__source))
                        {
                            sprite_save(__source, 0, $"{_basePath}_image{_i}{_extension}");
                            ++_i;
                        }
                    }
                }
                else
                {
                    __AbError($"Source type not supported ({typeof(__source)})");
                }
            }
            else if (is_struct(__source))
            {
                if (is_instanceof(__source, AbFileDescription))
                {
                    file_copy(__source, __source.absolutePath);
                }
                else if (is_instanceof(__source, AbBufferDescription))
                {
                    buffer_save_ext(__source.buffer, _absolutePath, __source.offset, __source.size);
                }
                else if (is_instanceof(__source, AbSurfaceDescription))
                {
                    surface_save_part(__source.surface, _absolutePath, __source.left, __source.top, __source.width, __source.height);
                }
                else
                {
                    __AbError($"Source struct not supported ({instanceof(__source)})");
                }
            }
            else
            {
                __AbError($"Source type not supported ({typeof(__source)})");
            }
        }));
    }
    
    static __AddSpriteToProject = function(_projectSprite)
    {
        __hasProjectCommands = true;
        __SetProjectAssetAsModified(_projectSprite.assetName);
        
        __EnsureProjectSprite(_projectSprite.assetName);
        __EnsureProjectFolder(_projectSprite.folder);
        __EnsureProjectTextureGroup(_projectSprite.textureGroupName);
        
        array_push(__commandArray, method({
            __projectSprite: _projectSprite,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            __projectSprite.__Save();
        }));
    }
    
    static __AddSoundToProject = function(_projectSound)
    {
        __hasProjectCommands = true;
        __SetProjectAssetAsModified(_projectSound.assetName);
        
        __EnsureProjectSound(_projectSound.assetName);
        __EnsureProjectFolder(_projectSound.folder);
        __EnsureProjectAudioGroup(_projectSound.audioGroupName);
        
        array_push(__commandArray, method({
            __projectSound: _projectSound,
        },
        function(_projectStruct, _datafilesDirectory)
        {
            __projectSound.__Save();
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
    
    static __End = function()
    {
        var _projectStruct = __projectStruct;
        if (_projectStruct == undefined)
        {
            if (__hasProjectCommands)
            {
                __AbWarning("Called `SaveBucketsToDirectory()` but command list has project commands. Project commands will be ignored");
            }
            
            var _bucketDirectory = __bucketDirectory;
            
            var _commandArray = __commandArray;
            var _i = 0;
            repeat(array_length(_commandArray))
            {
                var _command = _commandArray[_i];
                
                if (struct_exists(method_get_self(_command), "bucket"))
                {
                    _command(undefined, _bucketDirectory);
                }
            
                ++_i;
            }
            
            var _bucketExportArray = __SaveBuckets(_bucketDirectory);
            
            var _json = json_stringify({
                type:    "loose manifest v1",
                buckets: _bucketExportArray,
            })
            
            __AbSaveString(_json, _bucketDirectory + AB_MANIFEST_FILENAME);
        }
        else
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
            _projectStruct.__Save(__ensureAudioGroupDict,
                                  __ensureFolderDict,
                                  __ensureDatafileDict,
                                  __ensureResourceDict,
                                  __ensureTextureGroupDict);
            _projectStruct.__Destroy();
        }
        
        var _callbackOnEndArray = __callbackOnEndArray;
        var _i = 0;
        repeat(array_length(_callbackOnEndArray))
        {
            var _callbackInfo = _callbackOnEndArray[_i];
            _callbackInfo.__callback(_callbackInfo.__callbackMetadata);
            ++_i;
        }
        
        var _ownedSourceArray = __destroySourceOnEndArray;
        var _i = 0;
        repeat(array_length(_ownedSourceArray))
        {
            var _source = _ownedSourceArray[_i];
            
            if (is_string(_source))
            {
                //Do nothing
            }
            else if (is_handle(_source))
            {
                if (buffer_exists(_source))
                {
                    buffer_delete(_source);
                }
                else if (surface_exists(_source))
                {
                    surface_free(_source);
                }
                else if (sprite_exists(_source))
                {
                    sprite_delete(_source);
                }
                else
                {
                    __AbWarning($"Source type cannot be destroyed ({typeof(_source)})");
                }
            }
            else if (is_struct(_source))
            {
                if (is_instanceof(_source, AbFileDescription))
                {
                    //Do nothing
                }
                else if (is_instanceof(_source, AbBufferDescription))
                {
                    buffer_delete(_source.buffer);
                }
                else if (is_instanceof(_source, AbSurfaceDescription))
                {
                    surface_free(_source.surface);
                }
                else
                {
                    __AbWarning($"Source struct type cannot be destroyed ({instanceof(_source)})");
                }
            }
            else
            {
                __AbWarning($"Source type cannot be destroyed ({typeof(_source)})");
            }
            
            ++_i;
        }
    }
}