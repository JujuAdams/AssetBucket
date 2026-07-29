function __BucketClassPathDescription(_rootDirectory, _localPath) constructor
{
    rootDirectory = _rootDirectory;
    localPath     = _localPath;
    absolutePath  = _rootDirectory + _localPath;
    extension     = filename_ext(_localPath);
    suggestedName = filename_change_ext(filename_name(_localPath), "");
    
    linkedPaths = [absolutePath];
}