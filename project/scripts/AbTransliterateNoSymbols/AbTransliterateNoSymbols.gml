/// Returns a string that contains only the following characters:
/// - Letters A to Z
/// - Letters a to z
/// - Underscores
/// - Spaces
/// Control characters such as newlines and tabs will be converted into spaces.
/// 
/// The conversion is performed by guessing an appropriate ASCII / English equivalent
/// representation. Symbols will be replaced with approximate ASCII symbols and non-Latin
/// characters will be replaced with a romanization. Latin letters with accents have their accents
/// stripped off. Emojis are turned into descriptions.
/// 
/// This function returns very, very approximate results and is often wrong. Japanese kanji are
/// usually returned using a Chinese romanization. Arabic and Hebrew, being abjads that don't write
/// specific vowel sounds in most cases, are challenging to read from the transliteration. This
/// function should be considered a last resort.
/// 
/// The dataset for this script is obtained from AnyAscii:
///     https://github.com/anyascii/anyascii/
/// 
/// @param string

function AbTransliterateNoSymbols(_string)
{
    static _inBufferStatic  = buffer_create(1024, buffer_grow, 1);
    static _outBufferStatic = buffer_create(1024, buffer_grow, 1);
    static _transliterateBufferStatic = __AbTransliterateBinaryNoSymbols();
    
    var _inBuffer            = _inBufferStatic;
    var _outBuffer           = _outBufferStatic;
    var _transliterateBuffer = _transliterateBufferStatic;
    
    buffer_poke(_inBuffer, 0, buffer_string, _string);
    
    buffer_seek(_inBuffer,  buffer_seek_start, 0);
    buffer_seek(_outBuffer, buffer_seek_start, 0);
    
    while(true)
    {
        var _value = buffer_read(_inBuffer, buffer_u8); //Assume 0xxxxxxx
        if (_value == 0) break;
        
        if ((_value & $E0) == $C0) //110xxxxx 10xxxxxx
        {
            _value  = (                           _value & $1F) <<  6;
            _value += (buffer_read(_inBuffer, buffer_u8) & $3F);
        }
        else if ((_value & $F0) == $E0) //1110xxxx 10xxxxxx 10xxxxxx
        {
            _value  = (                           _value & $0F) << 12;
            _value += (buffer_read(_inBuffer, buffer_u8) & $3F) <<  6;
            _value +=  buffer_read(_inBuffer, buffer_u8) & $3F;
        }
        else if ((_value & $F8) == $F0) //11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
        {
            _value  = (                           _value & $07) << 18;
            _value += (buffer_read(_inBuffer, buffer_u8) & $3F) << 12;
            _value += (buffer_read(_inBuffer, buffer_u8) & $3F) <<  6;
            _value +=  buffer_read(_inBuffer, buffer_u8) & $3F;
        }
        
        buffer_seek(_transliterateBuffer, buffer_seek_start, 0);
        buffer_write(_outBuffer, buffer_text, __AbTransliterateSearchBinaryTree(_transliterateBuffer, 0x80000, _value) ?? ""); //Hardcoded to a depth of 20
    }
    
    buffer_write(_outBuffer, buffer_u8, 0x00);
    
    return buffer_peek(_outBuffer, 0, buffer_string);
}