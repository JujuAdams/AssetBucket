/// @param path

function AbGetIncludedFilesPath(_path)
{
    return AB_DEV_MODE? $"{AB_PROJECT_DIRECTORY}datafiles/{_path}" : _path;
}