function __BucketClassBucket(_bucketName, _filesize) constructor
{
    __name     = _bucketName;
    __filesize = _filesize;
    
    __buffer = -1;
    
    __datafileDict = {};
    __soundsDict   = {};
    __spritesDict  = {};
    
    __decompressedBufferArray = [];
    
    __datafileNameArray = [];
    __soundNameArray    = [];
    __spriteNameArray   = [];
    
    __globalAssetOffset = 0;
    
    __loaded = false;
    
    
    
    static __Destroy = function()
    {
        __Unload();
    }
    
    static __Unload = function()
    {
        if (not __loaded) return;
        __loaded = false;
        
        struct_foreach(__soundsDict, function(_variable_UNUSED, _value)
        {
            audio_free_buffer_sound(_value);
        });
        
        if (buffer_exists(__buffer))
        {
            buffer_delete(__buffer);
            __buffer = -1;
        }
        
        var _i = 0;
        repeat(array_length(__decompressedBufferArray))
        {
            buffer_delete(__decompressedBufferArray[_i]);
            ++_i;
        }
        
        array_resize(__decompressedBufferArray, 0);
        
        __datafileDict = {};
        __soundsDict   = {};
        __spritesDict  = {};
        
        array_resize(__datafileNameArray, 0);
        array_resize(__soundNameArray,    0);
        array_resize(__spriteNameArray,   0);
    
        __globalAssetOffset = 0;
    }
    
    static __Load = function()
    {
        if (__loaded) return;
        __loaded = true;
        
        var _path = __BucketGetDatafilePath(__BucketGetDatafilesName(__name));
        if (not file_exists(_path))
        {
            __BucketError($"Could not find \"{_path}\"");
        }
        
        //Use a fixed buffer for the benefit of `audio_create_buffer_sound()`
        __buffer = buffer_create(__filesize, buffer_fixed, 1);
        buffer_load_ext(__buffer, _path, 0);
        var _buffer = __buffer;
        
        if (not buffer_exists(_buffer))
        {
            __BucketError($"Failed to load \"{_path}\"");
        }
        
        var _json = buffer_read(_buffer, buffer_string);
        __globalAssetOffset = buffer_tell(_buffer);
        
        var _bucketInfoStruct = undefined;
        try
        {
            _bucketInfoStruct = json_parse(_json);
        }
        catch(_error)
        {
            show_debug_message(_error);
            __BucketError($"Failed to parse JSON\nPath was \"{_path}\"");
            return;
        }
        
        if (not is_struct(_bucketInfoStruct))
        {
            __BucketError($"Parser expecting an object, got {typeof(_bucketInfoStruct)}\nPath was \"{_path}\"");
        }
        
        var _version                = _bucketInfoStruct[$ "version"];
        __datafileDict              = _bucketInfoStruct[$ "datafiles"];
        var _soundsDefinitionArray  = _bucketInfoStruct[$ "sounds"];
        var _spritesDefinitionArray = _bucketInfoStruct[$ "sprites"];
        
        if (_version != BUCKET_CONTENTS_VERSION)
        {
            __BucketError($"\"{_path}\" was expecting version {BUCKET_CONTENTS_VERSION}, got {_version}");
        }
        
        if (not is_struct(__datafileDict))
        {
            __BucketError($"\"{_path}\" `.datafiles` not an object, got {typeof(__datafileDict)}");
        }
        
        if (not is_array(_soundsDefinitionArray))
        {
            __BucketError($"\"{_path}\" `.sounds` not an array, got {typeof(_soundsDefinitionArray)}");
        }
        
        if (not is_array(_spritesDefinitionArray))
        {
            __BucketError($"\"{_path}\" `.sprites` not an array, got {typeof(_spritesDefinitionArray)}");
        }
        
        var _globalAssetOffset = __globalAssetOffset;
        var _soundsDict = __soundsDict;
        var _i = 0;
        repeat(array_length(_soundsDefinitionArray))
        {
            with(_soundsDefinitionArray[_i])
            {
                if (format == "wav")
                {
                    if (compressed)
                    {
                        var _compressedBuffer = buffer_create(size, buffer_fixed, 1);
                        buffer_copy(_buffer, _globalAssetOffset + offset, size, _compressedBuffer, 0);
                        
                        var _decompressedBuffer = buffer_decompress(_compressedBuffer);
                        buffer_delete(_compressedBuffer);
                        
                        array_push(__decompressedBufferArray, _decompressedBuffer);
                        
                        var _sound = audio_create_buffer_sound(_decompressedBuffer, sample16bit? buffer_s16 : buffer_u8, sampleRate, 0, buffer_get_size(_decompressedBuffer), (channels == 2)? audio_stereo : audio_mono);
                    }
                    else
                    {
                        var _sound = audio_create_buffer_sound(_buffer, sample16bit? buffer_s16 : buffer_u8, sampleRate, _globalAssetOffset + offset, size, (channels == 2)? audio_stereo : audio_mono);
                    }
                }
                
                _soundsDict[$ alias] = _sound;
            }
            
            ++_i;
        }
        
        __datafileNameArray = struct_get_names(__datafileDict);
        __soundNameArray    = struct_get_names(__soundsDict);
        __spriteNameArray   = struct_get_names(__spritesDict);
        
        show_debug_message(json_stringify(__datafileNameArray, true));
        show_debug_message(json_stringify(__soundNameArray, true));
        show_debug_message(json_stringify(__spriteNameArray, true));
    }
}