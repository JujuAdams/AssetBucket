/// @param assetName
/// @param sourcesArray
/// @param [width]
/// @param [height]

function __AbClassBuilderSprite(_assetName, _sourcesArray, _width = undefined, _height = undefined) constructor
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
    
    frameSpeed = 1;
    frameType  = spritespeed_framespergameframe;
    
    rotatedBounds = true;
    nineslice = undefined;
    
    SetSource(_sourcesArray, _width, _height);
    
    //Not included:
    // mask
    // masks
    // messages
    // frame_info
    
    
    
    
    
    static SetSource = function(_sourcesArray, _width = undefined, _height = undefined)
    {
        _sourcesArray = __AbEnsureArray(_sourcesArray);
        array_copy(sourcesArray, 0, _sourcesArray, 0, array_length(_sourcesArray));
        
        if ((_width == undefined) || (_height == undefined))
        {
            _width  ??= __AbGetSourceWidth(_sourcesArray[0]);
            _height ??= __AbGetSourceHeight(_sourcesArray[0]);
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