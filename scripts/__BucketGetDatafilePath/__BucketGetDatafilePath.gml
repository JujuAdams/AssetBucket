/// @param localPath

function __AbGetDatafilePath(_localPath)
{
    return AB_RUNNING_FROM_IDE? $"{AB_PROJECT_DIRECTORY}datafiles/{_localPath}" : _localPath;
}