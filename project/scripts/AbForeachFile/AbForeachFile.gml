/// @param rootDirectory
/// @param linkImages
/// @param function

function AbForeachFile(_rootDirectory, _linkImages, _function)
{
    var _fileList = new AbFileListCustom(_rootDirectory);
    
    if (_linkImages)
    {
        _fileList.LinkImageFiles(_excludePattern);
    }
    
    _fileList.Foreach(_function);
}