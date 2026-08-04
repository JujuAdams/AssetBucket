function __AbBufferWritePair(_buffer, _key, _value)
{
    buffer_write(_buffer, buffer_text, "  \"");
    buffer_write(_buffer, buffer_text, _key);
    buffer_write(_buffer, buffer_text, "\":");
    
    if (is_bool(_value))
    {
        buffer_write(_buffer, buffer_text, _value? "true" : "false");
        buffer_write(_buffer, buffer_text, ",\n");
    }
    else if (is_string(_value))
    {
        buffer_write(_buffer, buffer_text, "\"");
        buffer_write(_buffer, buffer_text, _value);
        buffer_write(_buffer, buffer_text, "\",\n");
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
        
        buffer_write(_buffer, buffer_text, ",\n");
    }
    else
    {
        __AbError($"Datatype not supported ({typeof(_value)})");
    }
}