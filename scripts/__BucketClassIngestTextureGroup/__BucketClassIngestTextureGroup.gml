/// @param parent
/// @param name

function __BucketClassIngestTextureGroup(_parent, _name) constructor
{
    __parent = _parent;
    __name   = _name;
    
    __queuedSprites = [];
    
    __texturePagePathArray = [];
    
    __textureFormat = BUCKET_TEXTURE_FORMAT_PNG;
    __textureSize   = 2048;
    
    
    
    static __AddSprite = function(_imagePathArray, _alias)
    {
        array_push(__queuedSprites, {
            __imagePathArray: _imagePathArray,
            __alias:          _alias,
        });
    }
    
    static __AddTexturePage = function(_index, _surface)
    {
        var _filename = __BucketGetDatafilesName($"{__name}_{_index}");
        var _destinationPath = $"{BUCKET_PROJECT_DIRECTORY}datafiles/{_filename}";
        
        if ((__textureFormat == BUCKET_TEXTURE_FORMAT_RAW) || (__textureFormat == BUCKET_TEXTURE_FORMAT_ZLIB))
        {
            var _buffer = buffer_create(16 + 4*surface_get_width(_surface)*surface_get_height(_surface), buffer_fixed, 1);
            buffer_write(_buffer, buffer_text, "RAW ");
            buffer_write(_buffer, buffer_s32,  surface_get_width(_surface));
            buffer_write(_buffer, buffer_s32,  surface_get_height(_surface));
            buffer_write(_buffer, buffer_s32,  0x00);
            buffer_get_surface(_buffer, _surface, 16);
            
            if (__textureFormat == BUCKET_TEXTURE_FORMAT_RAW)
            {
                var _compressedBuffer = buffer_compress(_buffer, 0, buffer_get_size(_buffer));
                buffer_delete(_buffer);
                _buffer = _compressedBuffer;
            }
            
            buffer_save(_buffer, _destinationPath);
            buffer_delete(_buffer);
        }
        else if (__textureFormat == BUCKET_TEXTURE_FORMAT_PNG)
        {
            surface_save(_surface, _destinationPath);
        }
        //else if (__textureFormat == BUCKET_TEXTURE_FORMAT_QOI)
        //{
        //    if (BUCKET_IMAGEMAGICK_PATH == undefined)
        //    {
        //        __BucketError($"`BUCKET_IMAGEMAGICK_PATH` must be defined before exporting QOI files");
        //    }
        //    
        //    if (not file_exists(BUCKET_IMAGEMAGICK_PATH))
        //    {
        //        __BucketError($"ImageMagick binary could not be found. Please check `BUCKET_IMAGEMAGICK_PATH`\nPath was {BUCKET_IMAGEMAGICK_PATH}");
        //    }
        //    
        //    surface_save(_surface, "asset_bucket_temp.png");
        //    
        //    var _sourcePath = $"{game_save_id}asset_bucket_temp.png";
        //    var _batchPath  = $"{game_save_id}convert_png_to_qoi.bat";
        //    
        //    file_delete(_batchPath);
        //    
        //    var _batchFileString = string_join("\n",
        //    "@echo off",
        //    $"echo Converting {_sourcePath} from PNG to QOI",
        //    $"\"{BUCKET_IMAGEMAGICK_PATH}\" \"{_sourcePath}\" \"{_destinationPath}\"");
        //    
        //    __BucketSaveString(_batchFileString, _batchPath);
        //    __BucketExecuteShell(_batchPath, "");
        //    
        //    var _finished = false;
        //    var _overallTimer = current_time;
        //    while((current_time - _overallTimer) < 10_000)
        //    {
        //        if (file_exists(_destinationPath))
        //        {
        //            _finished = true;
        //            break;
        //        }
        //    }
        //    
        //    if (not _finished)
        //    {
        //        __BucketError($"ImageMagick conversion of \"{_sourcePath}\" failed");
        //    }
        //    
        //    file_delete(_sourcePath);
        //}
        else
        {
            __BucketError($"Texture format \"{_textureFormat}\" unhandled for bucket \"{__name}\"");
        }
        
        array_push(__texturePagePathArray, _filename);
    }
    
    static __PackTextures = function(_ingestStruct)
    {
        if (array_length(__queuedSprites) <= 0)
        {
            return {
                format:      __textureFormat,
                tpages:      [],
                description: {},
            };
        }
        
        var _parent = __parent;
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
        
        var _currentIndex = undefined;
        
        var _surface = surface_create(_surfaceWidth, _surfaceHeight);
        surface_set_target(_surface);
        gpu_set_blendmode_ext(bm_one, bm_zero);
        
        var _textureGroupDesc = {
            sprites: {},
        };
        
        var _spritesDict = _textureGroupDesc.sprites;
        var _i = 0;
        repeat(array_length(_imagesArray))
        {
            with(_imagesArray[_i])
            {
                if (__packIndex != _currentIndex)
                {
                    if (_currentIndex != undefined)
                    {
                        __AddTexturePage(_currentIndex, _surface);
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
            __AddTexturePage(_currentIndex, _surface);
        }
        
        surface_reset_target();
        gpu_set_blendmode(bm_normal);
        surface_free(_surface);
        
        return {
            name:        __name,
            format:      __textureFormat,
            tpages:      __texturePagePathArray,
            description: _textureGroupDesc,
        };
    }
}