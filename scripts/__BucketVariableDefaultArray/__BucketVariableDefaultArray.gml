function __BucketVariableDefaultArray(_struct, _variableName)
{
    var _value = _struct[$ _variableName];
    return ((_value == undefined) && (not struct_exists(_struct, _variableName)))? [] : _value;
}