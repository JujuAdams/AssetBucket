/// @param alias
/// @param buffer
/// @param offset
/// @param size
/// @param [destinationPath]
/// @param [metadata]

function BucketIngestProjectBuffer(_alias, _buffer, _offset, _size, _destinationPath = undefined, _metadata = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestProjectBuffer()` outside of a worker function");
    }
    
    _destinationPath ??= $"ab_{md5_string_utf8(_alias)}";
    
    _ingestStruct.__QueueProjectOperation(_alias, new __BucketClassDeferredFunction(function()
    {
        __ingestStruct.__RegisterProjectDatafile(__alias);
        __ingestStruct.__EnsureProjectDatafile(__destinationPath);
        
        buffer_save_ext(__buffer, $"{BUCKET_PROJECT_DIRECTORY}datafiles/{__destinationPath}", __offset, __size);
    },
    {
        __ingestStruct:    _ingestStruct,
        __alias:           _alias,
        __buffer:          _buffer,
        __offset:          _offset,
        __size:            _size,
        __destinationPath: _destinationPath,
        __metadata:        _metadata,
    }));
}