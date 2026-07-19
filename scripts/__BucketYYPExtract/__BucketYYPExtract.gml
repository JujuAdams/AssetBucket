function __BucketYYPExtract(_yypString, _propertyName)
{
    var _substring = $"  \"{_propertyName}\":[\r\n";
    var _startPos = string_pos(_substring, _yypString);
    if (_startPos > 0)
    {
        _startPos += string_length(_substring);
    }
    else
    {
        _substring = $"  \"{_propertyName}\":[\n";
        _startPos = string_pos(_substring, _yypString);
        
        if (_startPos > 0)
        {
            _startPos += string_length(_substring);
        }
        else
        {
            _substring = $"  \"{_propertyName}\":[],";
            _startPos = string_pos(_substring, _yypString);
            if (_startPos > 0)
            {
                _startPos += string_length(_substring) - 2;
                
                return {
                    __array:      [],
                    __string:     "",
                    __startPos:   _startPos,
                    __endPos:     _startPos,
                    __emptyArray: true,
                    __error:      false,
                };
            }
        }
    }
    
    if (_startPos > 0)
    {
        var _endPos = string_pos_ext("   ],\r\n", _yypString, _startPos);
        if (_endPos <= 0)
        {
            _endPos = string_pos_ext("  ],\n", _yypString, _startPos);
        }
        
        if (_endPos > 0)
        {
            with({})
            {
                __string     = string_copy(_yypString, _startPos, _endPos - _startPos);
                __startPos   = _startPos;
                __endPos     = _endPos;
                __emptyArray = false;
                
                try
                {
                    __array = json_parse($"[{__string}]");
                    __error = false;
                }
                catch(_error)
                {
                    show_debug_message(_error);
                    __array = [];
                    __error = true;
                }
                
                return self;
            }
        }
    }
    
    return {
        __array:      [],
        __string:     "",
        __startPos:   _startPos,
        __endPos:     _startPos,
        __emptyArray: false,
        __error:      true,
    };
}