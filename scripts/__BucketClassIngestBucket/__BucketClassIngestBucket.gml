/// @param name
/// @param textureSize
/// @param textureFormat

function __BucketClassIngestBucket(_name, _textureSize, _textureFormat) constructor
{
    static _system = __BucketSystem();
    
    __name          = _name;
    __textureSize   = _textureSize;
    __textureFormat = _textureFormat;
    
    __accumulationBuffer = buffer_create(1024*1024, buffer_grow, 1);
    
    __queuedSprites = [];
    
    __datafilesDict    = {};
    __soundsArray      = [];
    __texturePageArray = [];
    __textureGroupDesc = {};
    
    
    
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
    
    static __AddSprite = function(_imagePathArray, _alias)
    {
        array_push(__queuedSprites, {
            __imagePathArray: _imagePathArray,
            __alias:          _alias,
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
            format:      "wav",
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
    
    static __PackTextures = function(_ingestStruct)
    {
        if (array_length(__queuedSprites) <= 0) return;
        
        var _rootDirectory = $"{BUCKET_PROJECT_DIRECTORY}{_ingestStruct.__configStruct.__rootDirectory}";
        var _textureFormat = __textureFormat;
        var _surfaceWidth  = __textureSize;
        var _surfaceHeight = __textureSize;
        
        var _imagesArray = [];
        var _surfaceCount = 0;
        
        var _smallestWidth  = infinity;
        var _smallestHeight = infinity;
        
        var _i = 0;
        repeat(array_length(__queuedSprites))
        {
            var _spriteInfo = __queuedSprites[_i];
            
            var _alias          = _spriteInfo.__alias;
            var _imagePathArray = _spriteInfo.__imagePathArray;
            
            var _boxArray = [];
            
            var _j = 0;
            repeat(array_length(_imagePathArray))
            {
                var _path = _rootDirectory + _imagePathArray[_j];
                var _sprite = __BucketAddSprite(_path);
                
                var _width  = sprite_get_width(_sprite);
                var _height = sprite_get_height(_sprite);
                
                _smallestWidth  = min(_smallestWidth,  _width );
                _smallestHeight = min(_smallestHeight, _height);
                
                array_push(_imagesArray, {
                    __alias:      _alias,
                    __path:       _path,
                    __sprite:     _sprite,
                    __width:      _width,
                    __height:     _height,
                    //__bboxLeft:   sprite_get_bbox_left(_sprite),
                    //__bboxTop:    sprite_get_bbox_top(_sprite),
                    //__bboxRight:  sprite_get_bbox_right(_sprite),
                    //__bboxBottom: sprite_get_bbox_bottom(_sprite),
                    //__bboxWidth:  sprite_get_bbox_right(_sprite) - sprite_get_bbox_left(_sprite),
                    //__bboxHeight: sprite_get_bbox_bottom(_sprite) - sprite_get_bbox_top(_sprite),
                    
                    __packIndex: undefined,
                    __packX:     undefined,
                    __packY:     undefined,
                });
                
                ++_j;
            }
            
            ++_i;
        }
        
        //Safety, should never happen
        if (is_infinity(_smallestWidth)) _smallestWidth = 1;
        if (is_infinity(_smallestHeight)) _smallestHeight = 1;
        
        array_sort(_imagesArray, function(_a, _b)
        {
            var _sign = sign(_b.__height - _a.__height);
            
            if (_sign == 0)
            {
                _sign = sign(_b.__width - _a.__width);
            }
            
            return _sign;
        });
        
        var _i = 0;
        repeat(array_length(_imagesArray))
        {
            var _imageInfo   = _imagesArray[_i];
            var _imageWidth  = _imageInfo.__width;
            var _imageHeight = _imageInfo.__height;
            var _imageArea   = _imageWidth*_imageHeight;
            
            var _foundBox      = undefined;;
            var _foundIndex    = undefined;
            var _foundCoverage = 0;
            
            var _j = 0;
            repeat(array_length(_boxArray))
            {
                var _box = _boxArray[_j];
                if ((_imageWidth <= _box.__width) && (_imageHeight <= _box.__height))
                {
                    var _coverage = _imageArea / _box.__area;
                    if (_coverage > _foundCoverage)
                    {
                        _foundBox      = _box;
                        _foundIndex    = _j;
                        _foundCoverage = _coverage;
                    }
                }
                
                ++_j;
            }
            
            if (_foundBox != undefined)
            {
                with(_imageInfo)
                {
                    __packIndex = _foundBox.__surfaceIndex;
                    __packX     = _foundBox.__left;
                    __packY     = _foundBox.__top;
                }
                
                with(_foundBox)
                {
                    if (__height - _imageHeight > _smallestHeight)
                    {
                        array_insert(_boxArray, _foundIndex+1, {
                            __surfaceIndex: __surfaceIndex,
                            __left:         __left,
                            __top:          __top + _imageHeight,
                            __width:        __width,
                            __height:       __height - _imageHeight,
                            __area:         __width*(__height - _imageHeight),
                        });
                    }
                    
                    if (__width - _imageWidth > _smallestWidth)
                    {
                        __left  += _imageWidth;
                        __width -= _imageWidth;
                        __height = _imageHeight;
                        __area   = __width*_imageHeight;
                    }
                    else
                    {
                        array_delete(_boxArray, _foundIndex, 1);
                    }
                }
            }
            else
            {
                with(_imageInfo)
                {
                    __packIndex = _surfaceCount;
                    __packX     = 0;
                    __packY     = 0;
                }
                
                array_push(_boxArray, {
                    __surfaceIndex: _surfaceCount,
                    __left:         _imageWidth,
                    __top:          0,
                    __width:        _surfaceWidth - _imageWidth,
                    __height:       _imageHeight,
                    __area:         _imageHeight*(_surfaceWidth - _imageWidth),
                });
                
                array_push(_boxArray, {
                    __surfaceIndex: _surfaceCount,
                    __left:         0,
                    __top:          _imageHeight,
                    __width:        _surfaceWidth,
                    __height:       _surfaceHeight - _imageHeight,
                    __area:         _surfaceWidth*(_surfaceHeight - _imageHeight),
                });
                
                ++_surfaceCount;
            }
            
            ++_i;
        }
        
        array_sort(_imagesArray, function(_a, _b)
        {
            return sign(_a.__packIndex - _b.__packIndex);
        });
        
        var _funcMakeBuffer = function(_surface, _textureFormat)
        {
            if (_textureFormat == "raw")
            {
                var _buffer = buffer_create(16 + 4*surface_get_width(_surface)*surface_get_height(_surface), buffer_fixed, 1);
                buffer_write(_buffer, buffer_text, "RAW ");
                buffer_write(_buffer, buffer_s32,  surface_get_width(_surface));
                buffer_write(_buffer, buffer_s32,  surface_get_height(_surface));
                buffer_write(_buffer, buffer_s32,  0x00);
                buffer_get_surface(_buffer, _surface, 16);
            }
            else if (_textureFormat == "png")
            {
                surface_save(_surface, "asset_bucket_temp.png");
                var _buffer = buffer_load("asset_bucket_temp.png");
                file_delete("asset_bucket_temp.png");
            }
            else
            {
                __BucketError($"Texture format \"{_textureFormat}\" unhandled for bucket \"{__name}\"");
            }
            
            return _buffer;
        }
        
        var _currentIndex = undefined;
        
        var _surface = surface_create(_surfaceWidth, _surfaceHeight);
        surface_set_target(_surface);
        gpu_set_blendmode_ext(bm_one, bm_zero);
        
        var _spritesDict = {};
        __textureGroupDesc = {
            sprites: _spritesDict,
        };
        
        var _i = 0;
        repeat(array_length(_imagesArray))
        {
            with(_imagesArray[_i])
            {
                if (__packIndex != _currentIndex)
                {
                    if (_currentIndex != undefined)
                    {
                        var _buffer = _funcMakeBuffer(_surface, _textureFormat);
                        other.__AddTexturePage(_currentIndex, _buffer);
                        buffer_delete(_buffer);
                    }
                    
                    _currentIndex = __packIndex;
                    
                    draw_clear_alpha(c_black, 0);
                }
                
                draw_sprite(__sprite, 0, __packX, __packY);
                
                _spritesDict[$ __alias] = {
                    width: __width,
                    height: __height,
                    frames: [
                        {
                            x: __packX,
                            y: __packY,
                            tp: _currentIndex,
                        },
                    ],
                };
            }
            
            ++_i;
        }
        
        if (_currentIndex != undefined)
        {
            var _buffer = _funcMakeBuffer(_surface, _textureFormat);
            __AddTexturePage(_currentIndex, _buffer);
            buffer_delete(_buffer);
        }
        
        surface_reset_target();
        surface_free(_surface);
    }
    
    static __AddTexturePage = function(_index, _buffer)
    {
        var _accumulationBuffer = __accumulationBuffer;
        var _size = buffer_get_size(_buffer);
        
        __texturePageArray[@ _index] = {
            offset: int64(buffer_tell(_accumulationBuffer)),
            size:   int64(_size),
        };
        
        buffer_copy(_buffer, 0, _size, _accumulationBuffer, buffer_tell(_accumulationBuffer));
        buffer_seek(_accumulationBuffer, buffer_seek_relative, _size);
    }
    
    static __Save = function(_ingestStruct, _ensureDatafileDict, _bucketExportArray)
    {
        __PackTextures(_ingestStruct);
        
        var _filename = __BucketGetDatafilesName(__name);
        _ensureDatafileDict[$ _filename] = true;
        
        var _buffer = buffer_create(1024*1024, buffer_grow, 1);
        buffer_write(_buffer, buffer_string, json_stringify({
            version:    int64(BUCKET_CONTENTS_VERSION),
            datafiles:  __datafilesDict,
            sounds:     __soundsArray,
            tpages:     __texturePageArray,
            tgroup:     __textureGroupDesc,
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