function __AbReplaceNumberInJSON(_yyString, _searchString, _newNumber)
{
    _searchString = $"\"{_searchString}\":";
    
    var _startPos = string_pos(_searchString, _yyString);
    if (_startPos <= 0)
    {
        __AbError($"Failed to find substring \"{_searchString}\"");
    }
    
    _startPos += string_length(_searchString)-1;
    var _endPos = string_pos_ext("\n", _yyString, _startPos);
    
    if (string_char_at(_yyString, _endPos-1) == ",")
    {
        --_endPos;
    }
    
    var _preString = string_copy(_yyString, 1, _startPos);
    var _postString = string_copy(_yyString, _endPos, string_length(_yyString) - _endPos);
    
    return _preString + string(_newNumber) + _postString;
}