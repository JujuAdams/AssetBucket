/// @param alias
/// @param buffer
/// @param offset
/// @param size
/// @param [destinationPath]

function BucketIngestBufferToProject(_alias, _buffer, _offset, _size, _destinationPath = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestBufferToProject()` outside of a worker function");
    }
    
    _destinationPath ??= $"ab_{md5_string_utf8(_alias)}";
    
    _ingestStruct.__RegisterProjectDatafile(_alias);
    _ingestStruct.__EnsureProjectDatafile(_destinationPath);
    
    buffer_save_ext(_buffer, $"{BUCKET_PROJECT_DIRECTORY}datafiles/{_destinationPath}", _offset, _size);
}