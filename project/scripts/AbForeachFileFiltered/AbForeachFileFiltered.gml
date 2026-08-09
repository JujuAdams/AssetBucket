/// @param rootDirectory
/// @param linkImages
/// @param [includePattern]
/// @param [excludePattern]
/// @param function

function AbForeachFileFiltered(_rootDirectory, _linkImages, _includePattern = undefined, _excludePattern = undefined, _function)
{
    var _fileList = new AbFileListCustom(_rootDirectory);
    _fileList.IncludeLocalPaths(_includePattern);
    _fileList.ExcludeLocalPaths(_excludePattern);
    
    if (_linkImages)
    {
        _fileList.LinkImageFiles(_excludePattern);
    }
    
    _fileList.Foreach(_function);
}