/// @param value

function __BucketEnsureArray(_value)
{
    return is_array(_value)? _value : [_value];
}