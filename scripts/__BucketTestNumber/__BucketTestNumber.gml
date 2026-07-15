function __BucketTestNumber(_value, _test)
{
    if (is_numeric(_test) && (_value >= _test))
    {
        return true;
    }
    else if (is_string(_test))
    {
        _test = string_trim(_test);
        
        if (string_copy(_test, 1, 2) == ">=")
        {
            var _comparison = __BucketRealSafe(string_trim(string_delete(_test, 1, 1)));
            if (_comparison == undefined)
            {
                __BucketError($"Could not parse comparison \"{_test}\"");
            }
            
            return (_value >= _comparison);
        }
        else if (string_copy(_test, 1, 2) == "<=")
        {
            _comparison = __BucketRealSafe(string_trim(string_delete(_test, 1, 1)));
            if (_comparison == undefined)
            {
                __BucketError($"Could not parse comparison \"{_test}\"");
            }
            
            return (_value <= _comparison);
        }
        else if (string_copy(_test, 1, 2) == "==")
        {
            _comparison = __BucketRealSafe(string_trim(string_delete(_test, 1, 1)));
            if (_comparison == undefined)
            {
                __BucketError($"Could not parse comparison \"{_test}\"");
            }
            
            return (_value == _comparison);
        }
        else if (string_char_at(_test, 1) == ">")
        {
            var _comparison = __BucketRealSafe(string_trim(string_delete(_test, 1, 1)));
            if (_comparison == undefined)
            {
                __BucketError($"Could not parse comparison \"{_test}\"");
            }
            
            return (_value > _comparison);
        }
        else if (string_char_at(_test, 1) == "<")
        {
            _comparison = __BucketRealSafe(string_trim(string_delete(_test, 1, 1)));
            if (_comparison == undefined)
            {
                __BucketError($"Could not parse comparison \"{_test}\"");
            }
            
            return (_value < _comparison);
        }
        else if (string_char_at(_test, 1) == "=")
        {
            _comparison = __BucketRealSafe(string_trim(string_delete(_test, 1, 1)));
            if (_comparison == undefined)
            {
                __BucketError($"Could not parse comparison \"{_test}\"");
            }
            
            return (_value == _comparison);
        }
        else
        {
            __BucketError($"Could not parse comparison \"{_test}\"");
        }
        
        return false;
    }
    else if (is_array(_test))
    {
        if (array_length(_test) <= 0)
        {
            return false;
        }
        
        var _firstElement = _test[0];
        if (is_string(_firstElement))
        {
            if ((_firstElement == "&") || (_firstElement == "&&") || (_firstElement == "all"))
            {
                var _i = 0;
                repeat(array_length(_test))
                {
                    if (not __BucketTestNumber(_value, _test[_i]))
                    {
                        return false;
                    }
                    
                    ++_i;
                }
            }
            else if ((_firstElement == "|") || (_firstElement == "||") || (_firstElement == "any"))
            {
                var _i = 0;
                repeat(array_length(_test))
                {
                    if (__BucketTestNumber(_value, _test[_i]))
                    {
                        return true;
                    }
                    
                    ++_i;
                }
            }
            else //TODO - Add more operations
            {
                __BucketError($"Unsupported operation \"{_firstElement}\"");
            }
        }
        else
        {
            __BucketError($"Incorrect datatype in comparison array first element. Expecting \"string\", found \"{typeof(_firstElement)}\"");
        }
    }
    else
    {
        __BucketError($"Incorrect datatype in comparison {typeof(_test)}");
    }
    
    return false;
}