/// @param sourcePath
/// @param [destinationPath]
/// @param [metadata]

function BucketIngestProjectDatafile(_sourcePath, _destinationPath = undefined, _metadata = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestProjectDatafile()` outside of a worker function");
    }
    
    var _absolutePath = $"{_system.__currentYYPDirectory}{_system.__currentIngestStruct.__configStruct.__rootDirectory}{_sourcePath}";
    if (not file_exists(_absolutePath))
    {
        __BucketError($"Can't find \"{_absolutePath}\"");
    }
    
    _destinationPath ??= filename_name(__sourcePath);
    
    _ingestStruct.__QueueProjectOperation(_sourcePath, new __BucketClassDeferredFunction(function(_ingestStruct)
    {
        static _system = __BucketSystem();
        
        _ingestStruct.__EnsureProjectDatafile(__sourcePath);
        _ingestStruct.__SetDatafileMetadata(__alias, __metadata);
        
        //Unnecessary because GameMaker will automatically build its own datafiles index
        //_ingestStruct.__EnsureProjectDatafile(__destinationPath);
        
        file_copy($"{_system.__currentYYPDirectory}{_ingestStruct.__configStruct.__rootDirectory}{__sourcePath}", $"{_system.__currentYYPDirectory}datafiles/{__destinationPath}");
    },
    {
        __sourcePath:      _sourcePath,
        __destinationPath: _destinationPath,
        __metadata:        _metadata,
    }));
}