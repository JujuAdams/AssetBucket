/// @param localPath
/// @param buffer
/// @param offset
/// @param size
/// @param [metadata]

function BucketIngestProjectBuffer(_localPath, _buffer, _offset, _size, _metadata = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestProjectBuffer()` outside of a worker function");
    }
    
    _ingestStruct.__QueueProjectOperation(_alias, new __BucketClassDeferredFunction(function(_ingestStruct)
    {
        _ingestStruct.__EnsureProjectDatafile(__localPath);
        _ingestStruct.__SetDatafileMetadata(__localPath, __metadata);
        
        //Unnecessary because GameMaker will automatically build its own datafiles index
        //_ingestStruct.__EnsureProjectDatafile(__localPath);
        
        buffer_save_ext(__buffer, $"{BUCKET_PROJECT_DIRECTORY}datafiles/{__localPath}", __offset, __size);
    },
    {
        __localPath: _localPath,
        __buffer:    _buffer,
        __offset:    _offset,
        __size:      _size,
        __metadata:  _metadata,
    }));
}