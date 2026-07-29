function __AbEnsureBufferDescription(_bufferDescription)
{
    if (is_handle(_bufferDescription) && buffer_exists(_bufferDescription))
    {
        _bufferDescription = new AbBufferDescription(_bufferDescription, 0, buffer_get_size(_bufferDescription));
    }
    else if (not is_struct(_bufferDescription)) || (not is_instanceof(_bufferDescription, AbBufferDescription))
    {
        __AbError($"Buffer description must be a struct instance of `AbBufferDescription` (typeof={typeof(_bufferDescription)})");
    }
    else if (not is_instanceof(_bufferDescription, AbBufferDescription))
    {
        __AbError($"Buffer description must be a struct instance of `AbBufferDescription` (instanceof={instanceof(_bufferDescription)})");
    }
    
    return _bufferDescription;
}