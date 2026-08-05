var _project = new AbProject(GM_project_filename);

//Create a command list. The command list holds operations that modify a project file
var _commandList = new AbCommandList();

//Create a list of files using `./asset_bucket/` as the root directory. File descriptions will
//have their local path relative to this root directory. The local path will be used later to
//create a folder structure inside the GameMaker project
var _baseFileList = (new AbFileList())
                    .ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket")
                    .PopulateFromSubdirectory("");

//Createa a new file list from the base file list. We change the root directory which will
//automatically reject any file not found inside the `datafiles/` directory
var _datafileFileList = _baseFileList.Duplicate()
.ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket/datafiles");

//As above but for sprites. This file list filters out anything that's not a supported image file
var _spriteFileList = _baseFileList.Duplicate()
.ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket/sprites")
.IncludeLocalPaths(["*.png", "*.ase", "*.aseprite"]);

//This special method will collect together image files that have the following pattern:
//    sprite_name_frame0.png
//    sprite_name_frame1.png
//    sprite_name_frame2.png
//    etc.
//Images that fit this pattern are removed from the file list leaving only the first file remaining
//in the file list. You can access an array of subimage paths via the `.linkedPaths` variable in
//the file description
_spriteFileList.CollectImageFrames();

//As above but for sounds. This file list filters out anything that's not a supported audio file
var _soundFileList = _baseFileList.Duplicate()
.ChangeRootDirectory($"{AB_PROJECT_DIRECTORY}../asset_bucket/sounds")
.IncludeLocalPaths(["*.wav", "*.ogg"]);

//Iterate over every datafile and add it to the project
_datafileFileList.Foreach(method({
    project: _project,
    commandList: _commandList,
},
function(_fileDesc)
{
    //Add a datafile to the project maintaining the folder structure in the source directory
    commandList.AddDatafileToProject(_fileDesc.localPath, _fileDesc.absolutePath);
}));

//Iterate over every image file and add it to the project
_spriteFileList.Foreach(method({
    project: _project,
    commandList: _commandList,
},
function(_fileDesc)
{
    //Use the suggested asset name as the asset name
    var _assetName = _fileDesc.suggestedName;
    
    //If this sprite is from Aseprite then try importing each tag as a separate sprite
    var _extension = filename_ext(_fileDesc.absolutePath);
    if ((_extension != ".ase") && (_extension != ".aseprite"))
    {
        //Spin up a project sprite
        var _projectSprite = project.MakeSprite(_assetName);
        
        //Edit the project sprite with our new frame image. We use the `.linkedPaths` variable here
        //to use an array of image paths collected by `.CollectImageFrames()` above
        _projectSprite.SetSource(_fileDesc.linkedPaths);
        
        //Set the folder for this sprite if we don't have one set yet. Using the local path here
        //we keep the folder hierarchy on disk in the IDE
        _projectSprite.SetFolderIfRoot($"Sprites/{AbFilenameDir(_fileDesc.localPath)}");
        
        //Queue up this sprite to be formally added to the project
        _projectSprite.AddToCommandList(commandList);
    }
    else
    {
        ProcessAsepriteFile(_assetName, _fileDesc, project, commandList);
    }
}));

//Iterate over every datafile and add it to the project
_soundFileList.Foreach(method({
    project: _project,
    commandList: _commandList,
},
function(_fileDesc)
{
    //Spin up a project sprite using the suggested asset name
    var _projectSound = project.MakeSound(_fileDesc.suggestedName);
    
    _projectSound.SetSource(_fileDesc.absolutePath);
    
    _projectSound.SetFolderIfRoot("Sounds");
    
    //Queue up this sound to be formally added to the project
    commandList.AddSoundToProject(_projectSound);
}));

//Execute the command list. This is that method call that actually affects the project on disk
_commandList.SaveToProject(_project);