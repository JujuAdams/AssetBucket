/// @param packableSpriteArray
/// @param [textureSize=2048]
/// @param [imageBorder=2]

function __AbPackSpritesInner(_packableSpriteArray, _textureSize = 2048, _imageBorder = 2)
{
    static _system = __AbSystem();
    
    if (array_length(_packableSpriteArray) <= 0)
    {
        return {
            surfaceArray: [],
            description: {},
        };
    }
    
    var _surfaceWidth  = _textureSize;
    var _surfaceHeight = _textureSize;
    
    var _surfaceCount = 0;
    
    var _surfaceArray = [];
    var _totalFrameDescArray = [];
    
    var _smallestWidth  = infinity;
    var _smallestHeight = infinity;
    
    var _textureGroupDesc = {
        sprites: {},
    };
    
    var _spritesDict = _textureGroupDesc.sprites;
    
    var _i = 0;
    repeat(array_length(_packableSpriteArray))
    {
        var _packableSprite = _packableSpriteArray[_i];
        var _assetName    = _packableSprite.assetName;
        var _spriteWidth  = _packableSprite.width;
        var _spriteHeight = _packableSprite.height;
        var _sourcesArray = _packableSprite.sourcesArray;
        var _nineslice    = _packableSprite.nineslice;
        
        var _boxArray = [];
        
        with(_packableSprite)
        {
            var _spriteDesc = {
                frames:         [],
                width:          width,
                height:         height,
                xoffset:        xOffset,
                yoffset:        yOffset,
                bbox_kind:      bboxKind,
                frame_speed:    frameSpeed,
                frame_type:     frameType,
                rotated_bounds: rotatedBounds,
            };
            
            if (bboxKind == bboxmode_manual)
            {
                _spriteDesc.bbox_left   = bboxLeft;
                _spriteDesc.bbox_top    = bboxTop;
                _spriteDesc.bbox_right  = bboxRight;
                _spriteDesc.bbox_bottom = bboxBottom;
            }
            
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
                    tilemode_bottom: _nineslice.tilemodeBottom,
                    tilemode_centre: _nineslice.tilemodeCenter,
                };
            }
            
            _spritesDict[$ _assetName] = _spriteDesc;
        }
             
        var _frameDescArray = _spriteDesc.frames;
        var _j = 0;
        repeat(array_length(_sourcesArray))
        {
            var _source = _sourcesArray[_j];
            var _sprite = __AbGetSourceImageAsSprite(_source, _spriteWidth, _spriteHeight, false);
            
            //TODO - Unpack sprite handles
            
            var _bboxLeft   = sprite_get_bbox_left(_sprite);
            var _bboxTop    = sprite_get_bbox_top(_sprite);
            var _bboxRight  = sprite_get_bbox_right(_sprite);
            var _bboxBottom = sprite_get_bbox_bottom(_sprite);
            var _bboxWidth  = 1 + _bboxRight - _bboxLeft;
            var _bboxHeight = 1 + _bboxBottom - _bboxTop;
            
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
    
    gpu_set_blendmode_ext(bm_one, bm_zero);
    
    var _currentIndex = undefined;
    var _surface = undefined;
    
    var _i = 0;
    repeat(array_length(_totalFrameDescArray))
    {
        with(_totalFrameDescArray[_i])
        {
            if (tp != _currentIndex)
            {
                if (_surface != undefined)
                {
                    surface_reset_target();
                }
                
                _surface = surface_create(_surfaceWidth, _surfaceHeight);
                surface_set_target(_surface);
                
                array_push(_surfaceArray, _surface);
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
    
    if (_surface != undefined)
    {
        surface_reset_target();
    }
    
    gpu_set_blendmode(bm_normal);
    
    return {
        surfaceArray: _surfaceArray,
        description: _textureGroupDesc,
    };
}