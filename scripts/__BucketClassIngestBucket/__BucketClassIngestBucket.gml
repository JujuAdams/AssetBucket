function __BucketClassIngestBucket(_name) constructor
{
    static _system = __BucketSystem();
    
    __name = _name;
    
    __accumulationBuffer = buffer_create(1024*1024, buffer_grow, 1);
    
    __queuedSprites = [];
    
    __datafilesDict = {};
    __soundsArray   = [];
    __spritesArray  = [];
    
    
    
    static __AddBuffer = function(_alias, _buffer, _offset, _size)
    {
        var _accumulationBuffer = __accumulationBuffer;
        
        __datafilesDict[$ _alias] = {
            offset: buffer_tell(_accumulationBuffer),
            size: _size,
        };
        
        buffer_copy(_buffer, _offset, _size, _accumulationBuffer, buffer_tell(_accumulationBuffer));
        buffer_seek(_accumulationBuffer, buffer_seek_relative, _size);
        buffer_write(_accumulationBuffer, buffer_u8, 0x00);
    }
    
    static __AddSprite = function(_sourcePath, _alias)
    {
        array_push(__queuedSprites, {
            __sourcePath: _sourcePath,
            __alias:      _alias,
        });
    }
    
    static __AddWAV = function(_sourcePath, _alias, _buffer, _offset)
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
        
        array_push(__soundsArray, {
            alias:       _alias,
            offset:      buffer_tell(_accumulationBuffer),
            size:        _subchunk2Size,
            sample16bit: (_bitsPerSample == 16),
            sampleRate:  _sampleRate,
            channels:    _channels,
        });
        
        buffer_copy(_buffer, buffer_tell(_buffer), _subchunk2Size, _accumulationBuffer, buffer_tell(_accumulationBuffer));
        buffer_seek(_accumulationBuffer, buffer_seek_relative, _subchunk2Size);
        buffer_write(_accumulationBuffer, buffer_u8, 0x00);
    }
    
    static __Save = function(_ensureDatafileDict, _bucketExportArray)
    {
        var _filename = __BucketGetDatafilesName(__name);
        _ensureDatafileDict[$ _filename] = true;
        
        var _buffer = buffer_create(1024*1024, buffer_grow, 1);
        buffer_write(_buffer, buffer_string, json_stringify({
            version:   int64(BUCKET_CONTENTS_VERSION),
            datafiles: __datafilesDict,
            sounds:    __soundsArray,
            sprites:   __spritesArray,
        }));
        buffer_copy(__accumulationBuffer, 0, buffer_tell(__accumulationBuffer), _buffer, buffer_tell(_buffer));
        
        var _size = buffer_tell(__accumulationBuffer) + buffer_tell(_buffer);
        buffer_save_ext(_buffer, $"{BUCKET_PROJECT_DIRECTORY}datafiles/{_filename}", 0, _size);
        
        buffer_delete(_buffer);
        buffer_delete(__accumulationBuffer);
        
        array_push(_bucketExportArray, {
            name: __name,
            size: _size,
        });
    }
}