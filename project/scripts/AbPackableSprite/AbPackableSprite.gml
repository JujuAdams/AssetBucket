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
/// - Buffer that contains raw ABGR data. You must provide the image width & height if using a buffer
/// - Surface. The entire surface will be saved
/// - Struct constructed by `AbFileDescription()`
/// - Struct constructed by `AbBufferDescription()`
/// - Struct constructed by `AbSurfaceDescription()`
/// - Sprite. Only the images of the sprite will be used and other information (frame speed etc.)
///   will be ignored in favour of the values set in the packable sprite struct,` see below
/// 
/// The packable sprite struct that is created contains the following variables:
/// 
/// `.assetName`
///   Name of the asset once packed. This is set when creating the packable sprite.
/// 
/// `.sourcesArray`
///   The array of sources that have been tied to the packable sprite, see above for permitted
///   datatypes for this array. You can replace this array by calling the `.SetSource()` method.
/// 
/// `.width` `.height`
///   The width and height of the sprite. These will be set when the packable sprite is created or
///   the source(s) is set by `.SetSource()`. You will probably not need to change these values
///   manually
/// 
/// `.xOffset` `.yOffset`
///   The position of the "origin" of the sprite, as you would set in the IDE sprite editor. This
///   defaults to `0, 0` which is the top left of the sprite.
/// 
/// `.bboxKind`
///   The kind of bounding box as a native GameMaker `bboxmode_*` constant. This defaults to
///   `bboxmode_automatic`.
/// 
/// `.rotatedBounds`
///   Whether the bounding box is allowed to rotate. This defaults to `true`.
/// 
/// `.bboxLeft` `.bboxTop` `.bboxRight` `.bboxBottom`
///   The bounding box for the sprite. These values will be ignored unless `.bboxKind` is set to
///   `bboxmode_manual` (this means these values will be ignored by default).
/// 
/// `.frameType`
///   What animation timing type to use. This is one of the native `spritespeed_*` constants. This
///   defaults to `spritespeed_framespersecond` in keeping with the GameMaker IDE.
/// 
/// `.frameSpeed`
///   The animation speed, mindful of the setting above. This defaults to `15` (and thus 15 FPS).
/// 
/// `.nineslice`
///   An optional struct that contains nineslice information for the sprite. To apply no nineslice
///   settings this variable should be set to `undefined`. This is also the default. If you would
///   like to define nineslicing for a sprite then the struct used for this variable must contain
///   the following variables:
///   
///     `.left`
///     `.top`
///     `.right`
///     `.bottom`
///     `.tilemodeLeft`
///     `.tilemodeTop`
///     `.tilemodeRight`
///     `.tilemodeBottom`
///     `.tilemodeCenter`
///   
///   You can set this struct manually or by calling `.SetNineslice()` or `.SetNinesliceExt()`.
/// 
/// 
/// 
/// @param assetName
/// @param sourceOrArray
/// @param [width]
/// @param [height]

function AbPackableSprite(_assetName, _sourceOrArray, _width = undefined, _height = undefined) constructor
{
    assetName = _assetName;
    
    sourcesArray = [];
    
    width  = undefined;
    height = undefined;
    
    xOffset = 0;
    yOffset = 0;
    
    bboxKind = bboxmode_automatic;
    rotatedBounds = true;
    
    frameSpeed = 15;
    frameType  = spritespeed_framespersecond;
    
    nineslice = undefined;
    
    SetSource(_sourceOrArray, _width, _height);
    
    bboxLeft   = 0;
    bboxTop    = 0;
    bboxRight  = width-1;
    bboxBottom = height-1;
    
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