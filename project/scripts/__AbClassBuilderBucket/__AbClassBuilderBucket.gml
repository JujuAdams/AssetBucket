/// @param name

function __AbClassBuilderBucket(_name) constructor
{
    static _system = __AbSystem();
    
    __name = _name;
    
    __hash          = md5_string_utf8(__name);
    __headerFilename = $"ab_{string_lower(string_replace_all(AbTransliterateNoSymbols(__name), " ", "_"))}.json";
    __coreFilename   = $"ab_{__hash}_0.bin";
    
    __coreBuffer = buffer_create(1024*1024, buffer_grow, 1);
    
    __metadata          = undefined;
    __datafilesDict     = {};
    __soundsArray       = [];
    __textureGroupDict  = {};
    __aliasMetadataDict = {};
    
    __modifiedDatafileDict = {};
    __modifiedAliasDict = {};
    
    __queuedOGGArray = [];
    __fileCount = 1;
    
    
    
    
    
    static __SetDatafileAsModified = function(_alias)
    {
        if (struct_exists(__modifiedDatafileDict, _alias))
        {
            __AbError($"Datafile alias \"{_alias}\" has already been modified by another command");
        }
        
        __modifiedDatafileDict[$ _alias] = true;
    }
    
    static __SetAliasAsModified = function(_alias)
    {
        if (struct_exists(__modifiedAliasDict, _alias))
        {
            __AbError($"Asset alias \"{_alias}\" has already been modified by another command");
        }
        
        __modifiedAliasDict[$ _alias] = true;
    }
    
    static __SetMetadata = function(_key, _value)
    {
        if (_value != undefined)
        {
            __aliasMetadataDict[$ _key] = _value;
        }
        else
        {
            struct_remove(__aliasMetadataDict, _key);
        }
    }
    
    static __AddBuffer = function(_alias, _buffer, _offset, _size)
    {
        var _accumulationBuffer = __coreBuffer;
        
        __datafilesDict[$ _alias] = {
            offset: int64(buffer_tell(_accumulationBuffer)),
            size:   int64(_size),
        };
        
        buffer_copy(_buffer, _offset, _size, _accumulationBuffer, buffer_tell(_accumulationBuffer));
        buffer_seek(_accumulationBuffer, buffer_seek_relative, _size);
        buffer_write(_accumulationBuffer, buffer_u8, 0x00);
    }
    
    static __AddSprite = function(_spriteDesc)
    {
        var _textureGroupName = _spriteDesc[$ "textureGroupName"] ?? __name;
        
        var _textureGroup = __textureGroupDict[$ _textureGroupName];
        if (not is_struct(_textureGroup))
        {
            _textureGroup = new __AbClassBuilderTextureGroup(self, _textureGroupName);
            __textureGroupDict[$ _textureGroupName] = _textureGroup;
        }
        
        _textureGroup.__AddSprite(_spriteDesc);
    }
    
    static __AddOGG = function(_alias, _source)
    {
        array_push(__queuedOGGArray, {
            __alias: _alias,
            __source: _source,
        });
    }
    
    static __AddWAV = function(_alias, _source, _compress)
    {
        var _accumulationBuffer = __coreBuffer;
        
        if (is_string(_source))
        {
            var _buffer = buffer_load(_source);
            var _offset = 0;
            var _cleanUpBuffer = true;
        }
        else if (is_handle(_source))
        {
            if (buffer_exists(_source))
            {
                var _buffer = _source;
                var _offset = 0;
                var _cleanUpBuffer = false;
            }
            else
            {
                __AbError($"Source type not supported as a .wav file (expecting buffer, was \"{typeof(_source)}\")");
            }
        }
        else if (is_struct(_source))
        {
            if (is_instanceof(_source, AbFileDescription))
            {
                var _buffer = buffer_load(_source.absolutePath);
                var _offset = 0;
                var _cleanUpBuffer = true;
            }
            else if (is_instanceof(_source, AbBufferDescription))
            {
                var _buffer = _source.buffer;
                var _offset = _source.offset;
                var _cleanUpBuffer = false;
            }
            else
            {
                __AbError($"Source struct not supported ({instanceof(_source)})");
            }
        }
        else
        {
            __AbError($"Source type not supported ({typeof(_source)})");
        }
        
        var _oldTell = buffer_tell(_buffer);
        buffer_seek(_buffer, buffer_seek_start, _offset);
        
        var _chunkID        = buffer_read(_buffer, buffer_u32);
        var _chunkSize      = buffer_read(_buffer, buffer_u32);
        var _chunkFormat    = buffer_read(_buffer, buffer_u32);
        var _subchunk1ID    = buffer_read(_buffer, buffer_u32);
        var _subchunk1Size  = buffer_read(_buffer, buffer_u32);
        var _audioFormat    = buffer_read(_buffer, buffer_u16);
        var _channels       = buffer_read(_buffer, buffer_u16);
        var _sampleRate     = buffer_read(_buffer, buffer_u32);
        var _byteRate       = buffer_read(_buffer, buffer_u32);
        var _blockAlignment = buffer_read(_buffer, buffer_u16);
        var _bitsPerSample  = buffer_read(_buffer, buffer_u16);
        var _subchunk2ID    = buffer_read(_buffer, buffer_u32);
        var _subchunk2Size  = buffer_read(_buffer, buffer_u32);
        
        if (_subchunk2Size == 0)
        {
            __AbError($"Audio file is empty\nSource was \"{_source}\"");
        }
        
        if (_chunkFormat != 0x45564157) //WAVE, or 1163280727 in decimal‬
        {
            __AbError($"Chunk format not recognised\nSource was \"{_source}\"");
        }
    
        if (_bitsPerSample == 8)
        {
            var _dataFormat = buffer_u8;
        }
        else if (_bitsPerSample == 16)
        {
            var _dataFormat = buffer_s16;
        }
        else
        {
            __AbError($"{_bitsPerSample} bits per sample is unsupported\nSource was \"{_source}\"");
        }
        
        if ((_channels != 1) && (_channels != 2))
        {
            __AbError($"Unsupported number of channels {_channels}\nSource was \"{_source}\"");
        }
    
        if (_blockAlignment != _channels*buffer_sizeof(_dataFormat))
        {
            __AbError($"Mismatch between block alignment ({_blockAlignment}) and data format ({buffer_sizeof(_dataFormat)})");
        }
        
        if (_compress)
        {
            var _compressedBuffer = buffer_compress(_buffer, buffer_tell(_buffer), _subchunk2Size);
            var _bucketSize = buffer_get_size(_compressedBuffer);
            buffer_copy(_compressedBuffer, 0, _bucketSize, _accumulationBuffer, buffer_tell(_accumulationBuffer));
            buffer_delete(_compressedBuffer);
        }
        else
        {
            var _bucketSize = _subchunk2Size;
            buffer_copy(_buffer, buffer_tell(_buffer), _subchunk2Size, _accumulationBuffer, buffer_tell(_accumulationBuffer));
        }
        
        array_push(__soundsArray, {
            type:        "sound v1",
            format:      _compress? AB_AUDIO_FORMAT_WAV_ZLIB : AB_AUDIO_FORMAT_WAV,
            alias:       _alias,
            offset:      int64(buffer_tell(_accumulationBuffer)),
            size:        int64(_bucketSize),
            sample16bit: bool(_bitsPerSample == 16),
            sampleRate:  int64(_sampleRate),
            channels:    int64(_channels),
        });
        
        buffer_seek(_accumulationBuffer, buffer_seek_relative, _bucketSize);
        
        if (_cleanUpBuffer)
        {
            buffer_delete(_buffer);
        }
        else
        {
            buffer_seek(_buffer, buffer_seek_start, _oldTell);
        }
    }
    
    
    
    
    
    static __NewExportFilename = function()
    {
        ++__fileCount;
        return $"ab_{__hash}_{__fileCount-1}.bin";
    }
    
    static __SaveToDirectory = function(_directory)
    {
        //Save OGG files that have been added to the bucket
        var _soundsArray = __soundsArray;
        var _queuedOGGArray = __queuedOGGArray;
        var _i = 0;
        repeat(array_length(_queuedOGGArray))
        {
            var _oggInfo = _queuedOGGArray[_i];
            var _oggSource = _oggInfo.__source;
            
            var _oggFilename = __NewExportFilename();
            var _oggPath = _directory + _oggFilename;
            
            if (is_string(_oggSource))
            {
                file_copy(_oggSource, _oggPath);
            }
            else if (is_handle(_oggSource))
            {
                if (buffer_exists(_oggSource))
                {
                    buffer_save(_oggSource, _oggPath);
                }
                else
                {
                    __AbError($"Source type not supported as a .wav file (expecting buffer, was \"{typeof(_oggSource)}\")");
                }
            }
            else if (is_struct(_oggSource))
            {
                if (is_instanceof(_oggSource, AbFileDescription))
                {
                    file_copy(_oggSource.absolutePath, _oggPath);
                }
                else if (is_instanceof(_oggSource, AbBufferDescription))
                {
                    buffer_save_ext(_oggSource.buffer, _oggPath, _oggSource.offset, _oggSource.size);
                }
                else
                {
                    __AbError($"Source struct not supported ({instanceof(_oggSource)})");
                }
            }
            else
            {
                __AbError($"Source type not supported ({typeof(_oggSource)})");
            }
            
            array_push(_soundsArray, {
                type:     "sound v1",
                format:   AB_AUDIO_FORMAT_OGG,
                alias:    _oggInfo.__alias,
                filename: _oggFilename,
            });
            
            ++_i;
        }
        
        //Create texture groups for sprites added to the bucket
        var _textureGroupArray = [];
        var _namesArray = struct_get_names(__textureGroupDict);
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            array_push(_textureGroupArray, __textureGroupDict[$ _namesArray[_i]].__PackTextures(_directory));
            ++_i;
        }
        
        //Save out the buffer and clean up
        buffer_save_ext(__coreBuffer, _directory + __coreFilename, 0, buffer_tell(__coreBuffer));
        
        //Create a header and add it to the accumulated data
        var _json = json_stringify({
            type:          "bucket header v1",
            name:          __name,
            datafiles:     __datafilesDict,
            sounds:        __soundsArray,
            textureGroups: _textureGroupArray,
            coreFilename:  __coreFilename,
            coreSize:      int64(buffer_tell(__coreBuffer)),
            metadata:      __metadata,
            aliasMetadata: __aliasMetadataDict,
        });
        
        __AbSaveString(_json, _directory + __headerFilename);
        
        //TODO - Move to `.Destroy()` method
        buffer_delete(__coreBuffer);
        __coreBuffer = undefined;
    }
}