/// @param sourcePath
/// @param [destinationPath]

function BucketIngestDatafileToProject(_sourcePath, _destinationPath = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestDatafileToProject()` outside of a worker function");
    }
    
    _destinationPath ??= $"ab_{md5_string_utf8(_sourcePath)}";
    
    _ingestStruct.__RegisterProjectDatafile(_sourcePath);
    _ingestStruct.__EnsureProjectDatafile(_destinationPath);
    
    file_copy($"{BUCKET_PROJECT_DIRECTORY}{_ingestStruct.__configStruct.__rootDirectory}{_sourcePath}", $"{BUCKET_PROJECT_DIRECTORY}datafiles/{_destinationPath}");
}