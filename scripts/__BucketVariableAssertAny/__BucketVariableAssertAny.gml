function __BucketVariableAssertAny(_struct, _variableName)
{
    var _value = _struct[$ _variableName];
    
    if ((_value == undefined) && (not struct_exists(_struct, _variableName)))
    {
        __BucketError($"`.{_variableName}` not found");
    }
    
    return _value;
}