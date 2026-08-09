/// @param rootDirectory
/// @param linkImages
/// @param [includePattern]
/// @param [excludePattern]

function AbFileListDirectoryWithFilters(_rootDirectory, _linkImages, _includePattern = undefined, _excludePattern = undefined) : AbFileListCustom(_rootDirectory, undefined) constructor
{
    IncludeLocalPaths(_includePattern);
    ExcludeLocalPaths(_excludePattern);
    
    if (_linkImages)
    {
        LinkImageFiles();
    }
}