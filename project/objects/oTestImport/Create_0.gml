//Create a project representation for us to work with
var _project = new AbProject(GM_project_filename);
AbPipeBeginForProject(_project);

(new AbFileListDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket/datafiles", false))
.Foreach(function(_fileDesc)
{
    //Add a datafile to the project maintaining the folder structure in the source directory
    AbPipeProjectDatafile(_fileDesc.absolutePath, _fileDesc.localPath);
});

(new AbFileListDirectoryWithFilters($"{AB_PROJECT_DIRECTORY}../asset_bucket/sounds", false, ["*.wav", "*.ogg"]))
.Foreach(function(_fileDesc)
{
    //Spin up a project sprite using the suggested asset name and try to place it in the "Sounds" folder
    AbPipeProjectSound(_fileDesc.absolutePath, _fileDesc.suggestedName, "Sounds");
});

(new AbFileListDirectoryWithFilters($"{AB_PROJECT_DIRECTORY}../asset_bucket/sprites", true, ["*.png", "*.ase", "*.aseprite"]))
.Foreach(function(_fileDesc)
{
    var _extension = filename_ext(_fileDesc.absolutePath);
    if ((_extension != ".ase") && (_extension != ".aseprite"))
    {
        //Not an Aseprite file. We use the `.linkedPaths` variable here to use an array of image paths
        //collected by `.LinkImageFiles()` above
        AbPipeProjectSprite(_fileDesc.linkedPaths, _fileDesc.suggestedName, $"Sprites/{AbFilenameDir(_fileDesc.localPath)}");
    }
    else
    {
        //If this sprite is from Aseprite then try importing each tag and slice separately
        CustomPipeProjectAseprite(_fileDesc.suggestedName, _fileDesc);
    }
});

AbPipeEnd();