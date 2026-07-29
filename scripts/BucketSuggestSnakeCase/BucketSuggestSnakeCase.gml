function BucketSuggestSnakeCase(_path, _prefix = "asset_")
{
    var _assetName = __BucketSuggestSafe(_path);
    
    var _firstOrd = ord(string_char_at(_assetName, 1));
    if ((_prefix == "") && (_firstOrd >= ord("0")) && (_firstOrd <= ord("9")))
    {
        _prefix = "asset_";
    }
    
    return _prefix + _assetName;
}

function __BucketSuggestSafe(_path)
{
    var _assetName = string_replace_all(filename_name(filename_change_ext(_path, "")), " ", "_");
    var _assetName = string_replace_all(_assetName, ".", "_");
    return _assetName;
}