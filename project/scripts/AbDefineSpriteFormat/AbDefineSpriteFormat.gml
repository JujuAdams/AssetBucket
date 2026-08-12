/// @param extensionOrArray
/// @param loadFunction

function AbDefineSpriteFormat(_extensionOrArray, _loadFunction)
{
    static _spriteFormatDict = __AbSystem().__spriteFormatDict;
    
    _extensionOrArray = __AbEnsureArray(_extensionOrArray);
    
    var _i = 0;
    repeat(array_length(_extensionOrArray))
    {
        _spriteFormatDict[$ _extensionOrArray[_i]] = _loadFunction;
        ++_i;
    }
}