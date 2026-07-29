function __BucketEnsureBufferDescription(_bufferDescription)
{
    if (is_handle(_bufferDescription) && buffer_exists(_bufferDescription))
    {
        _bufferDescription = new BucketBufferDescription(_bufferDescription, 0, buffer_get_size(_bufferDescription));
    }
    else if (not is_struct(_bufferDescription)) || (not is_instanceof(_bufferDescription, BucketBufferDescription))
    {
        __BucketError($"Buffer description must be a struct instance of `BucketBufferDescription` (typeof={typeof(_bufferDescription)})");
    }
    else if (not is_instanceof(_bufferDescription, BucketBufferDescription))
    {
        __BucketError($"Buffer description must be a struct instance of `BucketBufferDescription` (instanceof={instanceof(_bufferDescription)})");
    }
    
    return _bufferDescription;
}