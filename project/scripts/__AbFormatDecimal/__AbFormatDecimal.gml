/// @param decimal

function __AbFormatDecimal(_value)
{
    static _trimArray = ["0"];
    
    if (floor(_value) == _value)
    {
        return $"{_value}.0";
    }
    else
    {
        return string_trim_end(string(_value), _trimArray);
    }
}