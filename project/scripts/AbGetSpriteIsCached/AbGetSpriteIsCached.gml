function AbGetSpriteIsCached(_source)
{
    static _system = __AbSystem();
    
    if (not is_string(_source)) return false;
    
    return sprite_exists(_system.__spriteCacheDict[$ _source]);
}