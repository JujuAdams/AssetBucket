function __BucketClassBucket(_bucketName, _filesize) constructor
{
    __name     = _bucketName;
    __filesize = _filesize;
    
    __mainBuffer = -1;
    
    __datafileDict = {};
    __soundsDict   = {};
    __spriteArray  = [];
    __spriteDict   = {};
    
    __textureGroup = undefined;
    __ownedBufferArray = [];
    
    __datafileNameArray = [];
    __soundNameArray    = [];
    
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
        
        if (__textureGroup != undefined)
        {
            texturegroup_delete(__textureGroup);
        }
        
        if (buffer_exists(__mainBuffer))
        {
            buffer_delete(__mainBuffer);
            __mainBuffer = -1;
        }
        
        var _i = 0;
        repeat(array_length(__ownedBufferArray))
        {
            buffer_delete(__ownedBufferArray[_i]);
            ++_i;
        }
        
        array_resize(__ownedBufferArray, 0);
        
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
        __mainBuffer = buffer_create(__filesize, buffer_fixed, 1);
        buffer_load_ext(__mainBuffer, _path, 0);
        var _buffer = __mainBuffer;
        
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
        var _texturePageArray       = _bucketInfoStruct[$ "tpages"];
        var _textureGroupDesc       = _bucketInfoStruct[$ "tgroup"];
        
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
        
        if (not is_array(_texturePageArray))
        {
            __BucketError($"\"{_path}\" `.tpages` not an array, got {typeof(_texturePageArray)}");
        }
        
        if (not is_struct(_textureGroupDesc))
        {
            __BucketError($"\"{_path}\" `.tgroup` not an object, got {typeof(_textureGroupDesc)}");
        }
        
        //Set up sounds
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
                        
                        array_push(__ownedBufferArray, _decompressedBuffer);
                        
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
        
        //Create sprites as necessary
        if (array_length(_texturePageArray) > 0)
        {
            var _textureBufferArray = array_create(array_length(_texturePageArray), undefined);
            var _i = 0;
            repeat(array_length(_texturePageArray))
            {
                var _texturePageInfo = _texturePageArray[_i];
                
                var _textureBuffer = buffer_create(_texturePageInfo.size, buffer_fixed, 1);
                buffer_copy(_buffer, _texturePageInfo.offset + __globalAssetOffset, _texturePageInfo.size, _textureBuffer, 0);
                _textureBufferArray[@ _i] = _textureBuffer;
                array_push(__ownedBufferArray, _textureBuffer);
                
                ++_i;
            }
            
            __textureGroup = texturegroup_add(__name, _textureBufferArray, _textureGroupDesc);
            __spriteArray = texturegroup_get_sprites(__name);
            
            var _spriteArray = __spriteArray;
            var _spriteDict  = __spriteDict;
            var _i = 0;
            repeat(array_length(_spriteArray))
            {
                var _sprite = _spriteArray[_i];
                _spriteDict[$ sprite_get_name(_spriteArray[_i])] = _sprite;
                ++_i;
            }
        }
        
        __datafileNameArray = struct_get_names(__datafileDict);
        __soundNameArray    = struct_get_names(__soundsDict);
    }
}