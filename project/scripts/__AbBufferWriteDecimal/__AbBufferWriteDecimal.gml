function __AbBufferWriteDecimal(_buffer, _spacing, _key, _value)
{
    repeat(_spacing) buffer_write(_buffer, buffer_text, " ");
    buffer_write(_buffer, buffer_text, "\"");
    buffer_write(_buffer, buffer_text, _key);
    buffer_write(_buffer, buffer_text, "\":");
    buffer_write(_buffer, buffer_text, __AbFormatDecimal(_value));
    buffer_write(_buffer, buffer_text, ",\n");
}