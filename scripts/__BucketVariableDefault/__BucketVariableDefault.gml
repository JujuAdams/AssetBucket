function __BucketVariableDefault(_struct, _variableName, _defaultValue)
{
    var _value = _struct[$ _variableName];
    return ((_value == undefined) && (not struct_exists(_struct, _variableName)))? _defaultValue : _value;
}