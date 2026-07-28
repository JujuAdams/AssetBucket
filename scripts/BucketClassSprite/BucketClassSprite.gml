/// @param projectFolder
/// @param spriteName
/// @param width
/// @param height
/// @param [textureGroup="Default"]
/// @param [metadata]

function BucketClassSprite(_projectFolder, _spriteName, _width, _height, _textureGroup = "Default", _metadata = undefined)
{
    __spriteName    = _spriteName;
    __projectFolder = _projectFolder;
    __width         = _width;
    __height        = _height;
    __textureGroup  = _textureGroup;
    __metadata      = _metadata;
    
    __imageArray = [];
    
    static AddImage = function(_struct)
    {
        if (is_array(_struct))
        {
            var _i = 0;
            repeat(array_length(_struct))
            {
                AddImage(_struct[_i]);
                ++_i;
            }
        }
        else
        {
            _struct.parent = self;
            array_push(__imageArray, _struct);
        }
    }
    
    static FreeMemory = function()
    {
        var _i = 0;
        repeat(array_length(__imageArray))
        {
            __imageArray[_i].Discard();
            ++_i;
        }
        
        array_resize(__imageArray, 0);
    }
}