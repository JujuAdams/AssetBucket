function AbClearSpriteCache()
{
    with(__AbSystem())
    {
        var _spriteCacheDict = __spriteCacheDict;
        var _pathArray = struct_get_names(_spriteCacheDict);
        var _i = 0;
        repeat(array_length(_pathArray))
        {
            var _sprite = _spriteCacheDict[$ _pathArray[_i]];
            if (sprite_exists(_sprite)) sprite_delete(_sprite);
            ++_i;
        }
        
        __spriteCacheDict       = {};
        __spriteWidthCacheDict  = {};
        __spriteHeightCacheDict = {};
    }
}