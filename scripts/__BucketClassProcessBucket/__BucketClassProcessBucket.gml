function __BucketClassProcessBucket(_name, _macroScript) constructor
{
    __name        = _name;
    __macroScript = _macroScript;
    
    __blobBufferArray = [];
    __CreateNewBlob();
    
    __spritePathArray = [];
    
    __wavDescriptorArray = [];
    __oggDescriptorArray = [];
    
    
    
    static __CreateNewBlob = function()
    {
        var _buffer = buffer_create(1024*1024, buffer_grow, 1);
        buffer_write(_buffer, buffer_string, "bucket");
        
        array_push(__blobBufferArray, _buffer);
        return (array_length(__blobBufferArray) - 1);
    }
    
    static __AddDatafile = function(_sourcePath)
    {
        var _accumulationBuffer = __blobBufferArray[0];
        
        var _absolutePath = $"{BUCKET_PROJECT_DIRECTORY}{__configStruct.__rootDirectory}{_sourcePath}";
        if (not file_exists(_absolutePath))
        {
            __BucketError($"Can't find \"{_absolutePath}\"");
        }
        
        var _fileBuffer = buffer_load(_absolutePath);
        if (not buffer_exists(_fileBuffer))
        {
            __BucketError($"Failed to load \"{_absolutePath}\"");
        }
        
        var _fileSize = buffer_get_size(_fileBuffer);
        
        buffer_write(_accumulationBuffer, buffer_string, _sourcePath);
        buffer_write(_accumulationBuffer, buffer_u32, _fileSize);
        buffer_copy(_fileBuffer, 0, _fileSize, _accumulationBuffer, buffer_tell(_accumulationBuffer));
        buffer_seek(_accumulationBuffer, buffer_seek_relative, _fileSize);
        
        buffer_delete(_fileBuffer);
    }
    
    static __AddSprite = function(_sourcePath)
    {
        array_push(__spritePathArray, _sourcePath);
    }
    
    static __AddWAV = function(_sourcePath)
    {
        var _accumulationBuffer = __blobBufferArray[0];
        
        var _absolutePath = $"{BUCKET_PROJECT_DIRECTORY}{__configStruct.__rootDirectory}{_sourcePath}";
        if (not file_exists(_absolutePath))
        {
            __BucketError($"Can't find \"{_absolutePath}\"");
        }
        
        var _fileBuffer = buffer_load(_absolutePath);
        if (not buffer_exists(_fileBuffer))
        {
            __BucketError($"Failed to load \"{_absolutePath}\"");
        }
        
        var _chunkID        = buffer_read(_fileBuffer, buffer_u32);
        var _chunkSize      = buffer_read(_fileBuffer, buffer_u32);
        var _chunkFormat    = buffer_read(_fileBuffer, buffer_u32);
        var _subchunk1ID    = buffer_read(_fileBuffer, buffer_u32);
        var _subchunk1Size  = buffer_read(_fileBuffer, buffer_u32);
        var _audioFormat    = buffer_read(_fileBuffer, buffer_u16);
        var _channels       = buffer_read(_fileBuffer, buffer_u16);
        var _sampleRate     = buffer_read(_fileBuffer, buffer_u32);
        var _byteRate       = buffer_read(_fileBuffer, buffer_u32);
        var _blockAlignment = buffer_read(_fileBuffer, buffer_u16);
        var _bitsPerSample  = buffer_read(_fileBuffer, buffer_u16);
        var _subchunk2ID    = buffer_read(_fileBuffer, buffer_u32);
        var _subchunk2Size  = buffer_read(_fileBuffer, buffer_u32);
    
        if (_chunkFormat != 0x45564157) //WAVE, or 1163280727 in decimal‬
        {
            __BucketError("Chunk format not recognised");
        }
        
        if ((_bitsPerSample != 8) && (_bitsPerSample != 8))
        {
            __BucketError($"{_bitsPerSample} bits per sample is unsupported");
        }
        
        if (_blockAlignment != _channels*_bitsPerSample/8)
        {
            __BucketError($"Mismatch between block alignment ({_blockAlignment}) and bits-per-sample ({_bitsPerSample})");
        }
        
        buffer_write(_accumulationBuffer, buffer_string, _sourcePath);
        buffer_write(_accumulationBuffer, buffer_u32, _subchunk2Size);
        
        array_push(__wavDescriptorArray, new __BucketClassWAVDescriptor(_sourcePath, _bitsPerSample, _sampleRate, buffer_tell(_accumulationBuffer), _subchunk2Size, _channels));
        
        buffer_copy(_fileBuffer, buffer_tell(_fileBuffer), _subchunk2Size, _accumulationBuffer, buffer_tell(_accumulationBuffer));
        buffer_seek(_accumulationBuffer, buffer_seek_relative, _subchunk2Size);
        
        buffer_delete(_fileBuffer);
    }
    
    static __AddOGG = function(_sourcePath)
    {
        var _destPath = $"{BUCKET_PROJECT_DIRECTORY}datafiles/ab_{md5_string_utf8(_sourcePath)}";
        file_copy(_sourcePath, _destPath);
        
        array_push(__oggDescriptorArray, new __BucketClassOGGDescriptor(_sourcePath, _destPath));
    }
    
    static __CopyToDatafiles = function(_sourcePath, _folderOrigin, _destDirectory, _destFilename)
    {
        if (is_string(_folderOrigin))
        {
            var _length = string_length(_folderOrigin);
            if (string_copy(_sourcePath, 1, _length) == _folderOrigin)
            {
                _destDirectory += string_delete(filename_dir(_sourcePath), 1, _length) + "/" + _destFilename;
            }
            else
            {
                __BucketWarning($"Could not find folder origin \"{_folderOrigin}\" in source file path \"{_sourcePath}\"");
                _destDirectory += _destFilename;
            }
        }
        else
        {
            _destDirectory += _destFilename;
        }
        
        var _destPath = $"{BUCKET_PROJECT_DIRECTORY}datafiles/{_destDirectory}";
        
        file_copy(_sourcePath, _destPath);
    }
    
    static __Compile = function(_processStruct)
    {
        var _datafilesDirectory = $"{BUCKET_PROJECT_DIRECTORY}datafiles/";
        var _sourceDirectory = $"{BUCKET_PROJECT_DIRECTORY}{_processStruct.__configStruct.__rootDirectory}";
        
        var _surface = surface_create(2048, 2048);
        surface_set_target(_surface);
        draw_clear_alpha(c_black, 0);
        
        var _spritePathArray = __spritePathArray;
        var _prevTpageIndex = undefined;
        var _i = 0;
        repeat(array_length(_spritePathArray))
        {
            var _spritePath = _spritePathArray[_i];
            
            var _absolutePath = $"{_sourceDirectory}{_spritePath}";
            
            var _sprite = sprite_add(_absolutePath, 0, false, false, 0, 0);
            sprite_delete(_sprite);
            
            ++_i;
        }
        
        surface_reset_target();
        
        var _i = 0;
        repeat(array_length(__blobBufferArray))
        {
            var _buffer = __blobBufferArray[_i];
            
            var _chunkKey = $"{__name}_chunk{_i}";
            var _chunkFilename = $"ab_{md5_string_utf8(_chunkKey)}";
            
            buffer_save(_buffer, $"{_datafilesDirectory}{_chunkFilename}");
            buffer_delete(_buffer);
            
            ++_i;
        }
    }
}