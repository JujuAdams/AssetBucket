/// @param path

function AbFilenameDir(_path)
{
    _path = string_replace_all(_path, "\\", "/");
    return (string_pos("/", _path) > 0)? filename_dir(_path) : "";
}