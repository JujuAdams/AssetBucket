// Feather disable all

/// @param string
/// @param maskArray

function __BucketTestStringMaskAll(_string, _maskArray)
{
    if (not is_array(_maskArray))
    {
        return __BucketTestStringMask(_string, _maskArray);
    }
    
    var _i = 0;
    repeat(array_length(_maskArray))
    {
        if (not __BucketTestStringMask(_string, _maskArray[_i]))
        {
            return false;
        }
        
        ++_i;
    }
    
    return true;
}