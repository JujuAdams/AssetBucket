function BucketSuggestCamelCase(_path, _prefix = "asset")
{
    var _assetName = __BucketSuggestSafe(_path);
    
    var _firstOrd = ord(string_char_at(_assetName, 1));
    if ((_prefix == "") && (_firstOrd >= ord("0")) && (_firstOrd <= ord("9")))
    {
        _prefix = "asset";
    }
    
    var _splitArray = string_split(_assetName, " ");
    
    if (_prefix == "")
    {
        var _start = 1;
        var _count = array_length(_splitArray) - 1;
    }
    else
    {
        var _start = 0;
        var _count = array_length(_splitArray);
    }
    
    var _i = _start;
    repeat(_count)
    {
        var _substring = _splitArray[_i];
        _splitArray[@ _i] = string_upper(string_char_at(_substring, 1)) + string_lower(string_delete(_substring, 1, 1));
        ++_i;
    }
    
    return _prefix + string_concat_ext(_splitArray);
}