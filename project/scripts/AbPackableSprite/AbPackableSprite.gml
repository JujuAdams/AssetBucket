/// Constructor that creates a packable sprite for use with `AbPackSprites()`. The asset name is
/// the name of the sprite downstream when `texturegroup_add()` is eventually called. If you know
/// the size of the sprite beforehand, you should try to specify a width and height when calling
/// this constructor to avoid performance problems. However, the `width` and `height` are optional
/// and the sprite's size will be automatically determined either is unspecified.
/// 
/// The `sourceOrArray` parameter may be any of the following sources. If an array of sources is
/// provided then each source will be treated as an individual image in the sprite animation. A
/// source may be either:
/// - File path as a string (absolute path)
/// - Buffer. The entire buffer will be saved
/// - Surface. The entire surface will be saved
/// - Struct constructed by `AbFileDescription()`
/// - Struct constructed by `AbBufferDescription()`
/// - Struct constructed by `AbSurfaceDescription()`
/// - Sprite. Only the images of the sprite will be used and other information (frame speed etc.)
///   will be ignored in favour of the values set in the packable sprite struct
/// 
/// @param assetName
/// @param sourceOrArray
/// @param [width]
/// @param [height]

function AbPackableSprite(_assetName, _sourceOrArray, _width = undefined, _height = undefined) constructor
{
    assetName = _assetName;
    
    sourcesArray = [];
    textureGroupName = undefined;
    
    width  = undefined;
    height = undefined;
    
    xOffset = 0;
    yOffset = 0;
    
    bboxLeft   = 0;
    bboxTop    = 0;
    bboxRight  = 0;
    bboxBottom = 0;
    
    bboxKind = bboxmode_automatic;
    
    frameSpeed = 15;
    frameType  = spritespeed_framespersecond;
    
    rotatedBounds = true;
    nineslice = undefined;
    
    SetSource(_sourceOrArray, _width, _height);
    
    //Not included:
    // mask
    // masks
    // messages
    // frame_info
    
    
    
    
    
    static SetSource = function(_sourceOrArray, _width = undefined, _height = undefined)
    {
        sourcesArray = variable_clone(__AbSourceIngest(_sourceOrArray));
        
        if ((_width == undefined) || (_height == undefined))
        {
            var _sprite = __AbGetSourceImageAsSprite(sourcesArray[0]);
            _width  ??= sprite_get_width(_sprite);
            _height ??= sprite_get_height(_sprite);
            if (not AbGetSpriteIsCached(_sprite)) sprite_delete(_sprite);
        }
        
        width  = _width;
        height = _height;
    }
    
    static SetNineslice = function(_left, _top, _right, _bottom)
    {
        if (not is_struct(nineslice))
        {
            nineslice = {
                left:   _left,
                top:    _top,
                right:  _right,
                bottom: _bottom,
                
                tilemodeLeft:   nineslice_stretch,
                tilemodeTop:    nineslice_stretch,
                tilemodeRight:  nineslice_stretch,
                tilemodeBottom: nineslice_stretch,
                tilemodeCenter: nineslice_stretch,
            };
        }
        else
        {
            with(nineslice)
            {
                left   = _left;
                top    = _top;
                right  = _right;
                bottom = _bottom;
            }
        }
    }
    
    static SetNinesliceExt = function(_left, _top, _right, _bottom, _tilemodeLeft, _tilemodeTop, _tilemodeRight, _tilemodeBottom, _tilemodeCenter)
    {
        if (not is_struct(nineslice))
        {
            nineslice = {
                left:   _left,
                top:    _top,
                right:  _right,
                bottom: _bottom,
                
                tilemodeLeft:   _tilemodeLeft,
                tilemodeTop:    _tilemodeTop,
                tilemodeRight:  _tilemodeRight,
                tilemodeBottom: _tilemodeBottom,
                tilemodeCenter: _tilemodeCenter,
            };
        }
        else
        {
            with(nineslice)
            {
                left   = _left;
                top    = _top;
                right  = _right;
                bottom = _bottom;
                
                tilemodeLeft   = _tilemodeLeft;
                tilemodeTop    = _tilemodeTop;
                tilemodeRight  = _tilemodeRight;
                tilemodeBottom = _tilemodeBottom;
                tilemodeCenter = _tilemodeCenter;
            }
        }
    }
}