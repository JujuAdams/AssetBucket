function __AbBufferWriteLine(_buffer, _string)
{
    buffer_write(_buffer, buffer_text, _string);
    buffer_write(_buffer, buffer_text, "\n"); //TODO - Optimize
}