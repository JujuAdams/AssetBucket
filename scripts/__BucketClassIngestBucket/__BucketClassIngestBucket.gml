/// @param name
/// @param textureSize
/// @param textureFormat

function __BucketClassIngestBucket(_name, _textureSize, _textureFormat) constructor
{
    static _system = __BucketSystem();
    
    __name          = _name;
    __textureSize   = _textureSize;
    __textureFormat = _textureFormat;
    
    __hash = md5_string_utf8(__name);
    
    __accumulationBuffer = buffer_create(1024*1024, buffer_grow, 1);
    
    __datafilesDict    = {};
    __soundsArray      = [];
    __textureGroupDict = {};
    
    __queuedOGGArray = [];
    __fileCount = 1;
    
    
    
    static __AddBuffer = function(_alias, _buffer, _offset, _size)
    {
        var _accumulationBuffer = __accumulationBuffer;
        
        __datafilesDict[$ _alias] = {
            offset: int64(buffer_tell(_accumulationBuffer)),
            size:   int64(_size),
        };
        
        buffer_copy(_buffer, _offset, _size, _accumulationBuffer, buffer_tell(_accumulationBuffer));
        buffer_seek(_accumulationBuffer, buffer_seek_relative, _size);
        buffer_write(_accumulationBuffer, buffer_u8, 0x00);
    }
    
    static __AddSprite = function(_textureGroupName, _imagePathArray, _alias)
    {
        var _textureGroup = __textureGroupDict[$ _textureGroupName];
        if (not is_struct(_textureGroup))
        {
            _textureGroup = new __BucketClassIngestTextureGroup(self, _textureGroupName);
            __textureGroupDict[$ _textureGroupName] = _textureGroup;
        }
        
        _textureGroup.__AddSprite(_imagePathArray, _alias);
    }
    
    static __AddOGG = function(_sourcePath, _alias)
    {
        array_push(__queuedOGGArray, {
            __path: _sourcePath,
            __alias: _alias,
        });
    }
    
    static __AddWAV = function(_sourcePath, _alias, _buffer, _offset, _compress)
    {
        var _accumulationBuffer = __accumulationBuffer;
        
        var _fileExtension = filename_ext(_sourcePath);
        if (_fileExtension != ".wav")
        {
            __BucketError($"Audio file extension \"{_fileExtension}\" not supported\nPath was \"{_sourcePath}\"");
        }
        
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
            __BucketError($"Audio file is empty\nPath was \"{_sourcePath}\"");
        }
        
        if (_chunkFormat != 0x45564157) //WAVE, or 1163280727 in decimal‬
        {
            __BucketError($"Chunk format not recognised\nPath was \"{_sourcePath}\"");
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
            __BucketError($"{_bitsPerSample} bits per sample is unsupported\nPath was \"{_sourcePath}\"");
        }
        
        if ((_channels != 1) && (_channels != 2))
        {
            __BucketError($"Unsupported number of channels {_channels}\nPath was \"{_sourcePath}\"");
        }
    
        if (_blockAlignment != _channels*buffer_sizeof(_dataFormat))
        {
            __BucketError($"Mismatch between block alignment ({_blockAlignment}) and data format ({buffer_sizeof(_dataFormat)})");
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
            format:      BUCKET_AUDIO_FORMAT_WAV,
            alias:       _alias,
            offset:      int64(buffer_tell(_accumulationBuffer)),
            size:        int64(_bucketSize),
            sample16bit: bool(_bitsPerSample == 16),
            sampleRate:  int64(_sampleRate),
            channels:    int64(_channels),
            compressed:  bool(_compress),
        });
        
        buffer_seek(_accumulationBuffer, buffer_seek_relative, _bucketSize);
    }
    
    static __NewExportFilename = function()
    {
        ++__fileCount;
        return $"ab_{__hash}_{__fileCount-1}.ab";
    }
    
    static __Save = function(_ingestStruct, _ensureDatafileDict, _bucketExportArray)
    {
        var _rootDirectory = $"{BUCKET_PROJECT_DIRECTORY}{_ingestStruct.__configStruct.__rootDirectory}";
        
        //Save OGG files that have been added to the bucket
        var _soundsArray = __soundsArray;
        var _queuedOGGArray = __queuedOGGArray;
        var _i = 0;
        repeat(array_length(_queuedOGGArray))
        {
            var _oggInfo = _queuedOGGArray[_i];
            
            var _filename = __NewExportFilename();
            file_copy($"{_rootDirectory}{_oggInfo.__path}", $"{BUCKET_PROJECT_DIRECTORY}datafiles/{_filename}");
            
            array_push(_soundsArray, {
                format:   BUCKET_AUDIO_FORMAT_OGG,
                alias:    _oggInfo.__alias,
                filename: _filename,
            });
            
            ++__fileCount;
            ++_i;
        }
        
        //Create texture groups for sprites added to the bucket
        var _textureGroupArray = [];
        var _namesArray = struct_get_names(__textureGroupDict);
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            array_push(_textureGroupArray, __textureGroupDict[$ _namesArray[_i]].__PackTextures(_ingestStruct));
            ++_i;
        }
        
        //Create a header and add it to the accumulated data
        var _buffer = buffer_create(1024*1024, buffer_grow, 1);
        buffer_write(_buffer, buffer_string, json_stringify({
            version:   int64(BUCKET_CONTENTS_VERSION),
            datafiles: __datafilesDict,
            sounds:    __soundsArray,
            tgroups:   _textureGroupArray,
            fileCount: __fileCount,
        }));
        buffer_copy(__accumulationBuffer, 0, buffer_tell(__accumulationBuffer), _buffer, buffer_tell(_buffer));
        
        //Save out the buffer and clean up
        var _filename = __BucketGetDatafilesName(__name);
        _ensureDatafileDict[$ _filename] = true;
        
        var _size = buffer_tell(__accumulationBuffer) + buffer_tell(_buffer);
        buffer_save_ext(_buffer, $"{BUCKET_PROJECT_DIRECTORY}datafiles/ab_{__hash}_0.ab", 0, _size);
        
        buffer_delete(_buffer);
        buffer_delete(__accumulationBuffer);
        
        array_push(_bucketExportArray, {
            name: __name,
            size: _size,
        });
    }
}