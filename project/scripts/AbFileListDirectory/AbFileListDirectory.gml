/// @param rootDirectory
/// @param linkImages

function AbFileListDirectory(_rootDirectory, _linkImages) : AbFileListCustom(_rootDirectory, undefined) constructor
{
    if (_linkImages)
    {
        LinkImageFiles();
    }
}