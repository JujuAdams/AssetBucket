/// @param headerPath

function __AbClassRuntimeBucket(_headerPath) constructor
{
    static _system             = __AbSystem();
    static _projectBucketArray = _system.__projectBucketArray;
    static _projectBucketMap   = _system.__projectBucketMap;
    
    __headerPath = _headerPath;
    __directory = $"{AbFilenameDir(__headerPath)}/";
    
    var _json = __AbLoadString(_headerPath);
    try
    {
        __header = json_parse(_json);
    }
    catch(_error)
    {
        show_debug_message(_error);
        __header = undefined;
    }
    
    if (not is_struct(__header))
    {
        __AbError($"Header is not a JSON object");
    }
    
    if (__header[$ "type"] != "bucket header v1")
    {
        __AbError($"Header JSON object type is not \"bucket header v1\" (was \"{__header[$ "type"]}\")");
    }
    
    var _textureGroupArray = __header.textureGroups;
    __textureGroupNameArray = array_create(array_length(_textureGroupArray), undefined);
    var _i = 0;
    repeat(array_length(_textureGroupArray))
    {
        __textureGroupNameArray[@ _i] = _textureGroupArray[_i].name;
        ++_i;
    }
    
    __name = __header.name;
    
    __coreBuffer = -1;
    
    __datafileDict = {};
    __soundsDict   = {};
    __spriteArray  = [];
    __spriteDict   = {};
    
    __ownedBufferArray  = [];
    __wavArray          = [];
    __oggArray          = [];
    __datafileNameArray = [];
    __soundNameArray    = [];
    
    __fetched = false;
    
    
    
    
    
    static __Destroy = function()
    {
        __Flush();
        
        ds_map_delete(_projectBucketMap, __name);
        var _index = array_get_index(_projectBucketArray, self);
        if (_index >= 0) array_delete(_projectBucketArray, _index, 1);
    }
    
    static __Flush = function()
    {
        if (not __fetched) return;
        __fetched = false;
        
        array_foreach(__wavArray, audio_free_buffer_sound);
        array_foreach(__oggArray, audio_destroy_stream);
        
        if (texturegroup_exists(__name))
        {
            texturegroup_delete(__name);
        }
        
        if (buffer_exists(__coreBuffer))
        {
            buffer_delete(__coreBuffer);
            __coreBuffer = -1;
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
        
        __fetched = false;
    }
    
    static __Fetch = function()
    {
        if (__fetched) return;
        __fetched = true;
        
        __datafileDict             = __header[$ "datafiles"];
        var _soundsDefinitionArray = __header[$ "sounds"];
        var _textureGroupArray     = __header[$ "textureGroups"];
        
        if (not is_struct(__datafileDict))
        {
            __AbError($"\"{_path}\" `.datafiles` not an object, got {typeof(__datafileDict)}");
        }
        
        if (not is_array(_soundsDefinitionArray))
        {
            __AbError($"\"{_path}\" `.sounds` not an array, got {typeof(_soundsDefinitionArray)}");
        }
        
        if (not is_array(_textureGroupArray))
        {
            __AbError($"\"{_path}\" `.tpages` not an array, got {typeof(_textureGroupArray)}");
        }
        
        //Use a fixed buffer for the benefit of `audio_create_buffer_sound()`
        __coreBuffer = buffer_create(__header.coreSize, buffer_fixed, 1);
        buffer_load_ext(__coreBuffer, __directory + __header.coreFilename, 0);
        var _buffer = __coreBuffer;
        
        if (not buffer_exists(_buffer))
        {
            __AbError($"Failed to load core \"{_path}\"");
        }
        
        struct_foreach(__datafileDict, function(_name, _value)
        {
            static _runtimeBucketDatafileMap = __AbSystem().__runtimeBucketDatafileMap;
            _value.buffer = __coreBuffer;
            _runtimeBucketDatafileMap[? _name] = _value;
        });
        
        //Set up sounds
        var _runtimeBucketSoundMap = _system.__runtimeBucketSoundMap;
        var _wavArray = __wavArray;
        var _oggArray = __oggArray;
        var _soundsDict = __soundsDict;
        var _i = 0;
        repeat(array_length(_soundsDefinitionArray))
        {
            with(_soundsDefinitionArray[_i])
            {
                if ((format == AB_AUDIO_FORMAT_WAV) || (format == AB_AUDIO_FORMAT_WAV_ZLIB))
                {
                    if (format == AB_AUDIO_FORMAT_WAV_ZLIB)
                    {
                        var _compressedBuffer = buffer_create(size, buffer_fixed, 1);
                        buffer_copy(_buffer, offset, size, _compressedBuffer, 0);
                        
                        var _decompressedBuffer = buffer_decompress(_compressedBuffer);
                        buffer_delete(_compressedBuffer);
                        
                        array_push(__ownedBufferArray, _decompressedBuffer);
                    }
                    
                    var _sound = audio_create_buffer_sound(_buffer, sample16bit? buffer_s16 : buffer_u8, sampleRate, offset, size, (channels == 2)? audio_stereo : audio_mono);
                    array_push(_wavArray, _sound);
                }
                else if (format == AB_AUDIO_FORMAT_OGG)
                {
                    var _sound = audio_create_stream(other.__directory + filename);
                    array_push(_oggArray, _sound);
                }
                
                _soundsDict[$ alias] = _sound;
                _runtimeBucketSoundMap[? alias] = _sound;
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
                
                if (_tgroupFormat == AB_TEXTURE_FORMAT_ZLIB)
                {
                    var _j = 0;
                    repeat(array_length(_tgroupPagePathArray))
                    {
                        var _path = __directory + _tgroupPagePathArray[_j];
                        if (not file_exists(_path))
                        {
                            __AbError($"Could not find \"{_path}\"");
                        }
                        
                        var _compressedBuffer = buffer_load(_path);
                        if (not buffer_exists(_compressedBuffer))
                        {
                            __AbError($"Failed to load \"{_path}\"");
                        }
                        
                        var _textureBuffer = buffer_decompress(_compressedBuffer);
                        if (not buffer_exists(_textureBuffer))
                        {
                            __AbError($"Failed to decompress \"{_path}\" using Zlib");
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
                        var _path = __directory + _tgroupPagePathArray[_j];
                        if (not file_exists(_path))
                        {
                            __AbError($"Could not find \"{_path}\"");
                        }
                        
                        var _textureBuffer = buffer_load(_path);
                        if (not buffer_exists(_textureBuffer))
                        {
                            __AbError($"Failed to load \"{_path}\"");
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