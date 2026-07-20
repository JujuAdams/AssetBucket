/// @param originalPath
/// @param width
/// @param height
/// @param [spriteName]

function BucketDatafileGetSprite(_originalPath, _width, _height, _spriteName = _originalPath)
{
    var _textureGroupName = $"assetBucket_{_spriteName}";
    
    var _description = { sprites: {} };
    _description.sprites[$ _spriteName] = {
        width:  _width,
        height: _height,
        frames: [
            { x: 0, y: 0 },
        ],
    }
    
    var _buffer = BucketDatafileGetCopy(_originalPath);
    texturegroup_add(_textureGroupName, _buffer, _description);
    var _spriteArray = texturegroup_get_sprites(_textureGroupName);
    
    return _spriteArray[0];
}