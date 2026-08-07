/// @param parent
/// @param name

function __AbClassBuildTextureGroup(_parent, _name) constructor
{
    static _system = __AbSystem();
    
    __parent = _parent;
    __name   = _name;
    
    __queuedSprites = [];
    
    __texturePagePathArray = [];
    
    __textureFormat = AB_TEXTURE_FORMAT_PNG;
    __textureSize   = 2048;
    __imageBorder   = 2;
    
    
    
    static __AddSprite = function(_bucketSprite)
    {
        array_push(__queuedSprites, _bucketSprite);
    }
    
    static __AddTexturePage = function(_directory, _surface)
    {
        var _filename = __parent.__NewExportFilename();
        var _destinationPath = _directory + _filename;
        
        if ((__textureFormat == AB_TEXTURE_FORMAT_RAW) || (__textureFormat == AB_TEXTURE_FORMAT_ZLIB))
        {
            var _buffer = buffer_create(16 + 4*surface_get_width(_surface)*surface_get_height(_surface), buffer_fixed, 1);
            buffer_write(_buffer, buffer_text, "RAW ");
            buffer_write(_buffer, buffer_s32,  surface_get_width(_surface));
            buffer_write(_buffer, buffer_s32,  surface_get_height(_surface));
            buffer_write(_buffer, buffer_s32,  0x00);
            buffer_get_surface(_buffer, _surface, 16);
            
            if (__textureFormat == AB_TEXTURE_FORMAT_RAW)
            {
                var _compressedBuffer = buffer_compress(_buffer, 0, buffer_get_size(_buffer));
                buffer_delete(_buffer);
                _buffer = _compressedBuffer;
            }
            
            buffer_save(_buffer, _destinationPath);
            buffer_delete(_buffer);
        }
        else if (__textureFormat == AB_TEXTURE_FORMAT_PNG)
        {
            surface_save(_surface, _destinationPath);
            surface_save(_surface, "test.png");
        }
        else
        {
            __AbError($"Texture format \"{__textureFormat}\" unhandled for bucket \"{__name}\"");
        }
        
        array_push(__texturePagePathArray, _filename);
    }
    
    static __PackTextures = function(_directory)
    {
        if (array_length(__queuedSprites) <= 0)
        {
            return {
                format:      __textureFormat,
                tpages:      [],
                description: {},
            };
        }
        
        var _surfaceWidth  = __textureSize;
        var _surfaceHeight = __textureSize;
        var _imageBorder   = __imageBorder;
        
        var _surfaceCount = 0;
        
        var _totalFrameDescArray = [];
        
        var _smallestWidth  = infinity;
        var _smallestHeight = infinity;
        
        var _textureGroupDesc = {
            sprites: {},
        };
        
        var _spritesDict = _textureGroupDesc.sprites;
        
        var _i = 0;
        repeat(array_length(__queuedSprites))
        {
            var _bucketSprite = __queuedSprites[_i];
            
            var _assetName    = _bucketSprite.assetName;
            var _spriteWidth  = _bucketSprite.width;
            var _spriteHeight = _bucketSprite.height;
            var _sourcesArray = _bucketSprite.sourcesArray;
            
            var _boxArray = [];
            
            var _spriteDesc = { frames: [] };
            _spritesDict[$ _assetName] = _spriteDesc;
            
            var _nineslice = _bucketSprite.nineslice;
            if (is_struct(_nineslice))
            {
                _spriteDesc.nineslice = {
                    left:   _nineslice.left,
                    top:    _nineslice.top,
                    right:  _nineslice.right,
                    bottom: _nineslice.bottom,
                    
                    tilemode_left:   _nineslice.tilemodeLeft,
                    tilemode_top:    _nineslice.tilemodeTop,
                    tilemode_right:  _nineslice.tilemodeRight,
                    tilemode_bpttom: _nineslice.tilemodeBottom,
                    tilemode_center: _nineslice.tilemodeCenter,
                };
            }
                        
            var _frameDescArray = _spriteDesc.frames;
            var _j = 0;
            repeat(array_length(_sourcesArray))
            {
                var _source = _sourcesArray[_j];
                var _sprite = __AbAddSprite(_source, _spriteWidth, _spriteHeight);
                
                var _bboxLeft   = sprite_get_bbox_left(_sprite);
                var _bboxTop    = sprite_get_bbox_top(_sprite);
                var _bboxRight  = sprite_get_bbox_right(_sprite);
                var _bboxBottom = sprite_get_bbox_bottom(_sprite);
                var _bboxWidth  = 1 + _bboxRight - _bboxLeft;
                var _bboxHeight = 1 + _bboxBottom - _bboxTop;
                
                if (_j == 0)
                {
                    _spriteDesc.width  = int64(sprite_get_width(_sprite));
                    _spriteDesc.height = int64(sprite_get_height(_sprite));
                }
                
                _smallestWidth  = min(_smallestWidth,  _bboxWidth );
                _smallestHeight = min(_smallestHeight, _bboxHeight);
                
                var _frameDesc = {
                    __sprite: _sprite,
                    
                    w:           int64(_bboxWidth),
                    h:           int64(_bboxHeight),
                    x_offset:    int64(_bboxLeft),
                    y_offset:    int64(_bboxTop),
                    crop_width:  int64(_bboxWidth), //Don't know why we need this as well as w/h above
                    crop_height: int64(_bboxHeight),
                };
                
                array_push(_frameDescArray,      _frameDesc);
                array_push(_totalFrameDescArray, _frameDesc);
                
                ++_j;
            }
            
            ++_i;
        }
        
        //Safety, should never happen
        if (is_infinity(_smallestWidth)) _smallestWidth = 1;
        if (is_infinity(_smallestHeight)) _smallestHeight = 1;
        
        array_sort(_totalFrameDescArray, function(_a, _b)
        {
            //Sort by height first
            var _sign = sign(_b.h - _a.h);
            
            if (_sign == 0)
            {
                //Then width
                _sign = sign(_b.w - _a.w);
            }
            
            return _sign;
        });
        
        var _i = 0;
        repeat(array_length(_totalFrameDescArray))
        {
            var _frameDesc   = _totalFrameDescArray[_i];
            var _imageWidth  = _frameDesc.w;
            var _imageHeight = _frameDesc.h;
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
                    if (_coverage >= _foundCoverage) //Use an equality here to deal with floating point errors
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
                with(_frameDesc)
                {
                    x  = int64(_foundBox.__left);
                    y  = int64(_foundBox.__top);
                    tp = int64(_foundBox.__surfaceIndex);
                }
                
                with(_foundBox)
                {
                    if (__height - (_imageHeight + _imageBorder) > _smallestHeight)
                    {
                        array_insert(_boxArray, _foundIndex+1, {
                            __surfaceIndex: __surfaceIndex,
                            __left:         __left,
                            __top:          __top + _imageHeight + _imageBorder,
                            __width:        __width,
                            __height:       __height - (_imageHeight + _imageBorder),
                            __area:         __width*(__height - (_imageHeight + _imageBorder)),
                        });
                    }
                    
                    if (__width - (_imageWidth + _imageBorder) > _smallestWidth)
                    {
                        __left  += _imageWidth + _imageBorder;
                        __width -= _imageWidth + _imageBorder;
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
                with(_frameDesc)
                {
                    x  = int64(_imageBorder);
                    y  = int64(_imageBorder);
                    tp = int64(_surfaceCount);
                }
                
                array_push(_boxArray, {
                    __surfaceIndex: _surfaceCount,
                    __left:         _imageWidth + 2*_imageBorder,
                    __top:          _imageBorder,
                    __width:        _surfaceWidth - (_imageWidth + 3*_imageBorder),
                    __height:       _imageHeight,
                    __area:         _imageHeight*(_surfaceWidth - (_imageWidth + 3*_imageBorder)),
                });
                
                array_push(_boxArray, {
                    __surfaceIndex: _surfaceCount,
                    __left:         _imageBorder,
                    __top:          _imageHeight + 2*_imageBorder,
                    __width:        _surfaceWidth - 2*_imageBorder,
                    __height:       _surfaceHeight - (_imageHeight + 3*_imageBorder),
                    __area:         (_surfaceWidth - 2*_imageBorder)*(_surfaceHeight - (_imageHeight + 3*_imageBorder)),
                });
                
                ++_surfaceCount;
            }
            
            ++_i;
        }
        
        array_sort(_totalFrameDescArray, function(_a, _b)
        {
            return sign(_a.tp - _b.tp);
        });
        
        var _currentIndex = undefined;
        
        var _surface = surface_create(_surfaceWidth, _surfaceHeight);
        surface_set_target(_surface);
        gpu_set_blendmode_ext(bm_one, bm_zero);
        
        var _i = 0;
        repeat(array_length(_totalFrameDescArray))
        {
            with(_totalFrameDescArray[_i])
            {
                if (tp != _currentIndex)
                {
                    if (_currentIndex != undefined)
                    {
                        other.__AddTexturePage(_directory, _surface);
                    }
                    
                    _currentIndex = tp;
                    
                    draw_clear_alpha(c_black, 0);
                }
                
                draw_sprite(__sprite, 0, x - x_offset, y - y_offset);
                draw_flush();
                
                sprite_delete(__sprite);
                struct_remove(self, "__sprite");
            }
            
            ++_i;
        }
        
        if (_currentIndex != undefined)
        {
            __AddTexturePage(_directory, _surface);
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