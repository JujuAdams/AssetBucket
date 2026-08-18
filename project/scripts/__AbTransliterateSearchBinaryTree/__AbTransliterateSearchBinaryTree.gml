function __AbTransliterateSearchBinaryTree(_buffer, _mask, _value)
{
    if (_mask == 0)
    {
        return buffer_read(_buffer, buffer_string);
    }
    else
    {
        var _data = buffer_read(_buffer, buffer_u32);
        if (_mask & _value)
        {
            if (_data & 0b10)
            {
                buffer_seek(_buffer, buffer_seek_relative, _data >> 2);
                return __AbTransliterateSearchBinaryTree(_buffer, _mask >> 1, _value);
            }
            else
            {
                return undefined;
            }
        }
        else
        {
            if (_data & 0b01)
            {
                return __AbTransliterateSearchBinaryTree(_buffer, _mask >> 1, _value);
            }
            else
            {
                return undefined;
            }
        }
    }
}

show_debug_message("Welcome to ASCII Transliterate by Juju Adams! This is version 1.0.0, 2026-07-28");