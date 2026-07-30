function AbSuggestSnakeCase(_path, _prefix = "asset_")
{
    var _assetName = __AbSuggestSafe(_path);
        _assetName = string_replace_all(_assetName, " ", "_");
    
    var _firstOrd = ord(string_char_at(_assetName, 1));
    if ((_prefix == "") && (_firstOrd >= ord("0")) && (_firstOrd <= ord("9")))
    {
        _prefix = "asset_";
    }
    
    return _prefix + _assetName;
}