/// @param localPath

function __BucketGetDatafilePath(_localPath)
{
    return BUCKET_RUNNING_FROM_IDE? $"{BUCKET_PROJECT_DIRECTORY}datafiles/{_localPath}" : _localPath;
}