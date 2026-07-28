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
    static _inBufferStatic  = buffer_create(128, buffer_grow, 1);
    static _outBufferStatic = buffer_create(128, buffer_grow, 1);
    
    var _inBuffer  = _inBufferStatic;
    var _outBuffer = _outBufferStatic;
    
    var _assetName = string_replace_all(filename_name(filename_change_ext(_path, "")), " ", "_");
    
    buffer_poke(_inBuffer, 0, buffer_string, _assetName);
    buffer_seek(_inBuffer, buffer_seek_start, 0);
    buffer_seek(_outBuffer, buffer_seek_start, 0);
    
    while(true)
    {
        var _byte = buffer_read(_inBuffer, buffer_u8);
        if (_byte == 0x00) break;
        
        if (_byte
    }
    
    return buffer_read(_outBuffer, buffer_string);
}