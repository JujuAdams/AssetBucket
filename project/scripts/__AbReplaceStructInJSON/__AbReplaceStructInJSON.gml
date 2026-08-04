function __AbReplaceStructInJSON(_yyString, _searchString, _newString)
{
    _searchString = $"\"{_searchString}\":";
    
    var _searchLength = string_length(_searchString);
    var _pos = string_pos(_searchString, _yyString);
    
    if (_pos <= 0)
    {
        __AbError($"Failed to find substring \"{_searchString}\"");
    }
    
    var _startPos = string_pos_ext("{\n", _yyString, _pos + _searchLength) + 1;
    var _endPos = string_pos_ext("},", _yyString, _startPos);
    
    var _preString = string_copy(_yyString, 1, _startPos);
    var _postString = string_copy(_yyString, _endPos, string_length(_yyString) - _endPos);
    
    return _preString + _newString + _postString;
}