function __AbBufferWriteLine(_buffer, _string)
{
    buffer_write(_buffer, buffer_text, _string);
    buffer_write(_buffer, buffer_u8, 0x0A);
}