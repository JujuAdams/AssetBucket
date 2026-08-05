function __AbBufferWritePair(_buffer, _spacing, _key, _value)
{
    repeat(_spacing) buffer_write(_buffer, buffer_text, " ");
    buffer_write(_buffer, buffer_text, "\"");
    buffer_write(_buffer, buffer_text, _key);
    buffer_write(_buffer, buffer_text, "\":");
    __AbBufferWriteValue(_buffer, _value);
    buffer_write(_buffer, buffer_text, ",\n");
}

function __AbBufferWriteValue(_buffer, _value)
{
    if (is_bool(_value))
    {
        buffer_write(_buffer, buffer_text, _value? "true" : "false");
    }
    else if (is_string(_value))
    {
        buffer_write(_buffer, buffer_text, "\"");
        buffer_write(_buffer, buffer_text, _value);
        buffer_write(_buffer, buffer_text, "\"");
    }
    else if (is_numeric(_value))
    {
        if (floor(_value) == _value)
        {
            buffer_write(_buffer, buffer_text, int64(_value));
        }
        else
        {
            buffer_write(_buffer, buffer_text, _value);
        }
    }
    else if (is_array(_value))
    {
        buffer_write(_buffer, buffer_text, "[");
        
        var _i = 0;
        repeat(array_length(_value))
        {
            __AbBufferWriteValue(_buffer, _value[_i]);
            buffer_write(_buffer, buffer_text, ",");
            ++_i;
        }
        
        buffer_write(_buffer, buffer_text, "]");
    }
    else if (is_undefined(_value))
    {
        buffer_write(_buffer, buffer_text, "null");
    }
    else
    {
        __AbError($"Datatype not supported ({typeof(_value)})");
    }
}