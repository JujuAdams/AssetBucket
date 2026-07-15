function __BucketRealSafe(_string)
{
    var _value = undefined;
    
    try
    {
        _value = real(_string);
    }
    catch(_error)
    {
        
    }
    
    return _value;
}