function __AbLoadJSON(_path)
{
    var _json = __AbLoadString(_path);
    var _data = undefined;
    
    try
    {
        _data = json_parse(_json);
    }
    catch(_error)
    {
        show_debug_message(_error);
        __AbError($"Failed to parse JSON from \"{_path}\"");
    }
    
    return _data;
}