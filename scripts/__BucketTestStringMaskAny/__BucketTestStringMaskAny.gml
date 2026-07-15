// Feather disable all

/// @param string
/// @param maskArray

function __BucketTestStringMaskAny(_string, _maskArray)
{
    if (not is_array(_maskArray))
    {
        return __BucketTestStringMask(_string, _maskArray);
    }
    
    var _i = 0;
    repeat(array_length(_maskArray))
    {
        if (__BucketTestStringMask(_string, _maskArray[_i]))
        {
            return true;
        }
        
        ++_i;
    }
    
    return false;
}