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
        //Load the Aseprite file
        var _aseStruct = AsepriteRead(_fileDesc.absolutePath);
        var _width  = _aseStruct.width;
        var _height = _aseStruct.height;
        
        //Remove any layers and tags that we want to ignore
        _aseStruct.HideLayersByMask("*[ignore]").DeleteTagsByMask("*[ignore]");
        
        //Render out the Aseprite frames
        _aseStruct.Render(false);
        
        var _tagArray = _aseStruct.tagArray;
        if (array_length(_tagArray) <= 0) //We have no tags
        {
            //Build an array from each frame's buffer
            var _frameArray = _aseStruct.frameArray;
            var _frameBufferArray = array_create(array_length(_frameArray));
            var _i = 0;
            repeat(array_length(_frameArray))
            {
                _frameBufferArray[@ _i] = _frameArray[_i].buffer;
                ++_i;
            }
            
            project.MakeSprite(_assetName)
                   .SetSource(_frameBufferArray, _width, _height)
                   .SetFolderIfRoot($"Sprites/{AbFilenameDir(_fileDesc.localPath)}")
                   .AddToCommandList(commandList);
        }
        else //We have some tags
        {
            //If we don't have an existing project folder, organise all imported tags into a separate
            //folder in the project
            var _fallbackProjectFolder = $"Sprites/{AbFilenameDir(_fileDesc.localPath)}/{_fileDesc.suggestedName}";
            
            var _i = 0;
            repeat(array_length(_tagArray))
            {
                var _tagName = _tagArray[_i].name;
                var _frameArray = _aseStruct.GetTagFrames(_tagName);
                
                //Build an array from each frame's buffer
                var _frameBufferArray = array_create(array_length(_frameArray));
                var _j = 0;
                repeat(array_length(_frameArray))
                {
                    _frameBufferArray[@ _j] = _frameArray[_j].buffer;
                    ++_j;
                }
                
                project.MakeSprite($"{_assetName}_{_tagName}")
                       .SetSource(_frameBufferArray, _width, _height)
                       .SetFolderIfRoot(_fallbackProjectFolder)
                       .AddToCommandList(commandList);
                
                ++_i;
            }
        }
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