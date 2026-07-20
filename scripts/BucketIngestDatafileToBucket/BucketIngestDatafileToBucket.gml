/// @param localPath
/// @param bucketName

function BucketIngestDatafileToBucket(_path, _bucketName)
{
    static _system = __BucketSystem();
    
    var _absolutePath = $"{BUCKET_PROJECT_DIRECTORY}{_system.__currentIngestStruct.__configStruct.__rootDirectory}{_path}";
    if (not file_exists(_absolutePath))
    {
        __BucketError($"Can't find \"{_absolutePath}\"");
    }
    
    var _buffer = buffer_load(_absolutePath);
    if (not buffer_exists(_buffer))
    {
        __BucketError($"Failed to load \"{_absolutePath}\"");
    }
    
    BucketIngestBufferToBucket(_path, _buffer, 0, buffer_get_size(_buffer), _bucketName);
    buffer_delete(_buffer);
}