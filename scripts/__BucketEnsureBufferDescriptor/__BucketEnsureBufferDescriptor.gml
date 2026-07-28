function __BucketEnsureBufferDescriptor(_bufferDescriptor)
{
    if (is_handle(_bufferDescriptor) && buffer_exists(_bufferDescriptor))
    {
        _bufferDescriptor = new BucketBufferDescriptor(_bufferDescriptor, 0, buffer_get_size(_bufferDescriptor));
    }
    else if (not is_struct(_bufferDescriptor)) || (not is_instanceof(_bufferDescriptor, BucketBufferDescriptor))
    {
        __BucketError($"Buffer descriptor must be a struct instance of `BucketBufferDescriptor` (typeof={typeof(_bufferDescriptor)})");
    }
    else if (not is_instanceof(_bufferDescriptor, BucketBufferDescriptor))
    {
        __BucketError($"Buffer descriptor must be a struct instance of `BucketBufferDescriptor` (instanceof={instanceof(_bufferDescriptor)})");
    }
    
    return _bufferDescriptor;
}