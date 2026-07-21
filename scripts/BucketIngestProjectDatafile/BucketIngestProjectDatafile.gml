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
    
    var _absolutePath = $"{BUCKET_PROJECT_DIRECTORY}{_system.__currentIngestStruct.__configStruct.__rootDirectory}{_sourcePath}";
    if (not file_exists(_absolutePath))
    {
        __BucketError($"Can't find \"{_absolutePath}\"");
    }
    
    _ingestStruct.__QueueProjectOperation(_sourcePath, new __BucketClassDeferredFunction(function()
    {
        var _destinationPath = __destinationPath ?? __BucketGetDatafilesName(__sourcePath);
        
        __ingestStruct.__RegisterProjectDatafile(__sourcePath);
        __ingestStruct.__EnsureProjectDatafile(_destinationPath);
        
        file_copy($"{BUCKET_PROJECT_DIRECTORY}{_ingestStruct.__configStruct.__rootDirectory}{__sourcePath}", $"{BUCKET_PROJECT_DIRECTORY}datafiles/{_destinationPath}");
    },
    {
        __ingestStruct:    _ingestStruct,
        __sourcePath:      _sourcePath,
        __destinationPath: _destinationPath,
        __metadata:        _metadata,
    }));
}