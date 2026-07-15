function __BucketVariableAssertStringOrArray(_struct, _variableName)
{
    var _value = __BucketVariableDefaultArray(_struct, _variableName);
    
    if (is_string(_value))
    {
        _value = [_value];
    }
    else if (not __BucketIsArrayOfStrings(_value))
    {
        __BucketError($"`.{_variableName}` must be a string or an array of strings");
    }
    
    return _value;
}