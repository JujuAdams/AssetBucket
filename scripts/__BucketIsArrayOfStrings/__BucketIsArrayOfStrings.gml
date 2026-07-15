function __BucketIsArrayOfStrings(_array)
{
    if (not is_array(_array))
    {
        return false;
    }
    
    var _i = 0;
    repeat(array_length(_array))
    {
        if (not is_string(_array[_i]))
        {
            return false;
        }
        
        ++_i;
    }
    
    return true;
}