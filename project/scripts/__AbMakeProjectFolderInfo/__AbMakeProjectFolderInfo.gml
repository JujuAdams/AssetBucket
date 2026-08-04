/// @param projectFolder
/// @param projectStruct
/// @param [folderInfo]

function __AbMakeProjectFolderInfo(_folderInProject, _projectStruct, _folderInfo = {})
{
    with(_folderInfo)
    {
        if (_folderInProject == "")
        {
            __name = _projectStruct.__projectName;
            __path = _projectStruct.__projectFilename;
        }
        else
        {
            _folderInProject = __AbTrimDirectory(_folderInProject);
            __name = $"{filename_name(_folderInProject)}.yy";
            __path = $"folders/{_folderInProject}.yy";
        }
    }
    
    return _folderInfo;
}