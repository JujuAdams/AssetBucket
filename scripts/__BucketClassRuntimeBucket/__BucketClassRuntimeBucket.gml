function __BucketClassRuntimeBucket(_bucketName, _blobSize) constructor
{
    static _system = __BucketSystem();
    
    __name     = _bucketName;
    __blobSize = _blobSize;
    
    __mainBuffer = -1;
    
    __datafileDict = {};
    __soundsDict   = {};
    __spriteArray  = [];
    __spriteDict   = {};
    
    __ownedBufferArray  = [];
    __wavArray          = [];
    __oggArray          = [];
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
        
        array_foreach(__wavArray, audio_free_buffer_sound);
        array_foreach(__oggArray, audio_destroy_stream);
        
        if (texturegroup_exists(__name))
        {
            texturegroup_delete(__name);
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
        
        __datafileDict = {};
        __soundsDict   = {};
        __spriteArray  = [];
        __spriteDict   = {};
        
        __ownedBufferArray  = [];
        __wavArray          = [];
        __oggArray          = [];
        __datafileNameArray = [];
        __soundNameArray    = [];
        
        __globalAssetOffset = 0;
        
        __loaded = false;
    }
    
    static __Load = function()
    {
        if (__loaded) return;
        __loaded = true;
        
        var _path = __BucketGetDatafilePath($"ab_{md5_string_utf8(__name)}_0.ab");
        if (not file_exists(_path))
        {
            __BucketError($"Could not find \"{_path}\"");
        }
        
        //Use a fixed buffer for the benefit of `audio_create_buffer_sound()`
        __mainBuffer = buffer_create(__blobSize, buffer_fixed, 1);
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
        
        var _version               = _bucketInfoStruct[$ "version"];
        __datafileDict             = _bucketInfoStruct[$ "datafiles"];
        var _soundsDefinitionArray = _bucketInfoStruct[$ "sounds"];
        var _textureGroupArray     = _bucketInfoStruct[$ "tgroups"];
        
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
        
        if (not is_array(_textureGroupArray))
        {
            __BucketError($"\"{_path}\" `.tpages` not an array, got {typeof(_textureGroupArray)}");
        }
        
        struct_foreach(__datafileDict, function(_name, _value)
        {
            static _runtimeBucketDatafileMap = __BucketSystem().__runtimeBucketDatafileMap;
            _value.buffer = __mainBuffer;
            _value.offset += __globalAssetOffset;
            _runtimeBucketDatafileMap[? _name] = _value;
        });
        
        //Set up sounds
        var _runtimeBucketSoundMap = _system.__runtimeBucketSoundMap;
        var _wavArray = __wavArray;
        var _oggArray = __oggArray;
        var _globalAssetOffset = __globalAssetOffset;
        var _soundsDict = __soundsDict;
        var _i = 0;
        repeat(array_length(_soundsDefinitionArray))
        {
            with(_soundsDefinitionArray[_i])
            {
                if (format == BUCKET_AUDIO_FORMAT_WAV)
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
                    
                    array_push(_wavArray, _sound);
                }
                else if (format == BUCKET_AUDIO_FORMAT_OGG)
                {
                    var _sound = audio_create_stream(__BucketGetDatafilePath(filename));
                    array_push(_oggArray, _sound);
                }
                
                _soundsDict[$ alias] = _sound;
                _runtimeBucketSoundMap[$ alias] = _sound;
            }
            
            ++_i;
        }
        
        //Create sprites as necessary
        if (array_length(_textureGroupArray) > 0)
        {
            var _i = 0;
            repeat(array_length(_textureGroupArray))
            {
                var _tgroupInfo = _textureGroupArray[_i];
                var _tgroupName          = _tgroupInfo.name;
                var _tgroupFormat        = _tgroupInfo.format;
                var _tgroupPagePathArray = _tgroupInfo.tpages;
                var _tgroupDescription   = _tgroupInfo.description;
                
                var _tgroupBufferArray = [];
                
                if (_tgroupFormat == BUCKET_TEXTURE_FORMAT_ZLIB)
                {
                    var _j = 0;
                    repeat(array_length(_tgroupPagePathArray))
                    {
                        var _path = __BucketGetDatafilePath(_tgroupPagePathArray[_j]);
                        if (not file_exists(_path))
                        {
                            __BucketError($"Could not find \"{_path}\"");
                        }
                        
                        var _compressedBuffer = buffer_load(_path);
                        if (not buffer_exists(_compressedBuffer))
                        {
                            __BucketError($"Failed to load \"{_path}\"");
                        }
                        
                        var _textureBuffer = buffer_decompress(_compressedBuffer);
                        if (not buffer_exists(_textureBuffer))
                        {
                            __BucketError($"Failed to decompress \"{_path}\" using Zlib");
                        }
                        
                        buffer_delete(_compressedBuffer);
                        
                        _tgroupBufferArray[@ _j] = _textureBuffer;
                        array_push(__ownedBufferArray, _textureBuffer);
                        
                        ++_j;
                    }
                }
                else
                {
                    var _j = 0;
                    repeat(array_length(_tgroupPagePathArray))
                    {
                        var _path = __BucketGetDatafilePath(_tgroupPagePathArray[_j]);
                        if (not file_exists(_path))
                        {
                            __BucketError($"Could not find \"{_path}\"");
                        }
                        
                        var _textureBuffer = buffer_load(_path);
                        if (not buffer_exists(_textureBuffer))
                        {
                            __BucketError($"Failed to load \"{_path}\"");
                        }
                        
                        _tgroupBufferArray[@ _j] = _textureBuffer;
                        array_push(__ownedBufferArray, _textureBuffer);
                        
                        ++_j;
                    }
                }
                
                texturegroup_add(_tgroupName, _tgroupBufferArray, _tgroupDescription);
                var _tgroupSpriteArray = texturegroup_get_sprites(_tgroupName);
                array_copy(__spriteArray, array_length(__spriteArray), _tgroupSpriteArray, 0, array_length(_tgroupSpriteArray));
                
                ++_i;
            }
            
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