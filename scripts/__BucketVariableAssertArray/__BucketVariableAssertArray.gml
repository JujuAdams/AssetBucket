function __BucketVariableAssertArray(_struct, _variableName)
{
    var _value = _struct[$ _variableName];
    
    if ((_value == undefined) && (not struct_exists(_struct, _variableName)))
    {
        __BucketError($"`.{_variableName}` not found");
    }
    else if (not is_array(_value))
    {
        __BucketError($"`.{_variableName}` must be an array, was {typeof(_value)}");
    }
    
    return _value;
}