/// @param value

function __AbEnsureArray(_value)
{
    return is_array(_value)? _value : [_value];
}