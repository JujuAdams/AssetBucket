/// @param path

function BucketIngestDatafileToProject(_path)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestDatafileToProject()` outside of a worker function");
    }
    
    _ingestStruct.__RegisterProjectDatafile(_path);
    
    file_copy($"{BUCKET_PROJECT_DIRECTORY}{_ingestStruct.__configStruct.__rootDirectory}{_path}",
              $"{BUCKET_PROJECT_DIRECTORY}datafiles/ab_{md5_string_utf8(_path)}");
}