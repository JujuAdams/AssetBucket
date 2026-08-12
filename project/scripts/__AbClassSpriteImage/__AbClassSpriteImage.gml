/// @param sprite
/// @param image

function __AbClassSpriteImage(_sprite, _image) constructor
{
    __sprite = _sprite;
    __image  = _image;
    
    __width  = sprite_get_width(_sprite);
    __height = sprite_get_height(_sprite);
    
    
    
    
    
    //Source implementation
    
    static __GetWidth = function()
    {
        return __width;
    }
    
    static __GetHeight = function()
    {
        return __height;
    }
    
    static __GetModifiedPath = function(_path)
    {
        var _extension = filename_ext(_path);
        var _basePath = filename_change_ext(_path, "");
        return $"{_basePath}_image{__image}{_extension}";
    }
    
    static __Save = function(_path, _allowModification)
    {
        if (_allowModification)
        {
            _path = __GetModifiedPath(_path);
        }
        
        sprite_save(__sprite, __image, _path);
    }
    
    static __SaveImage = function(_path, _allowModification)
    {
        __Save(_path, _allowModification);
    }
    
    static __GetBucketAlias = function(_alias)
    {
        return $"{_alias}_image{__image}";
    }
    
    static __GetBuffer = function()
    {
        return __AbSpriteGetBuffer(__sprite, __image);
    }
    
    static __GetSprite = function()
    {
        return __sprite;
    }
}