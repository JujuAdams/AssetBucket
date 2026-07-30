//Create a command list. The command list holds operations that modify a project file
var _commandList = new AbCommandList();

//Create a list of files using `./asset_bucket/` as the root directory. File descriptions will
//have their local path relative to this root directory. The local path will be used later to
//create a folder structure inside the GameMaker project
var _baseFileList = (new AbFileList())
                    .ChangeRootDirectory(AB_PROJECT_DIRECTORY + "asset_bucket")
                    .PopulateFromSubdirectory("");

//Createa a new file list from the base file list. We change the root directory which will
//automatically reject any file not found inside the `datafiles/` directory
var _datafileFileList = _baseFileList.Duplicate()
.ChangeRootDirectory(AB_PROJECT_DIRECTORY + "asset_bucket/datafiles");

//As above but for sprites. This file list filters out anything that's not a supported image file
var _spriteFileList = _baseFileList.Duplicate()
.ChangeRootDirectory(AB_PROJECT_DIRECTORY + "asset_bucket/sprites")
.IncludeLocalPaths(["*.png", "*.psd", "*.ase", "*.aseprite"]);

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
.ChangeRootDirectory(AB_PROJECT_DIRECTORY + "asset_bucket/sounds")
.IncludeLocalPaths(["*.wav", "*.ogg"]);

//Iterate over every datafile and add it to the project
_datafileFileList.Foreach(method({
    commandLine: _commandList,
    bucketName: "bufferDefault",
},
function(_fileDesc)
{
    //Add a datafile to the project maintaining the folder structure in the source directory
    commandLine.AddDatafileToProject(_fileDesc.localPath, _fileDesc.absolutePath);
}));

//Iterate over every image file and add it to the project
_spriteFileList.Foreach(method({
    commandLine: _commandList,
    bucketName: "bufferDefault",
},
function(_fileDesc)
{
    //Create a project folder path using the folder structure found in the source directory
    var _projectFolder = $"Sprites/{filename_dir(_fileDesc.localPath)}";
    
    //If this sprite is from Aseprite then try importing each tag as a separate sprite
    var _extension = filename_ext(_fileDesc.absolutePath);
    if ((_extension == ".ase") || (_extension == ".aseprite"))
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
        if (array_length(_tagArray) >= 1) //We have some tags
        {
            //Organise all imported tags into a folder in the project
            _projectFolder += "/" + _fileDesc.suggestedName;
            
            var _i = 0;
            repeat(array_length(_tagArray))
            {
                var _tagName = _tagArray[_i].name;
                var _frameArray = _aseStruct.GetTagFrames(_tagName);
                
                //Make a buffer from each tag frame's buffer
                var _frameBufferArray = array_create(array_length(_frameArray));
                var _j = 0;
                repeat(array_length(_frameArray))
                {
                    _frameBufferArray[@ _j] = _frameArray[_j].buffer;
                    ++_j;
                }
                
                //Add the sprite to the project using a modified asset name using the tag name
                commandLine.AddSpriteToProject($"{_fileDesc.suggestedName}_{_tagName}", _frameBufferArray, _width, _height, _projectFolder);
                
                ++_i;
            }
        }
        else //We have no tags
        {
            //Make a buffer from each frame's buffer
            var _frameArray = _aseStruct.frameArray;
            var _frameBufferArray = array_create(array_length(_frameArray));
            var _i = 0;
            repeat(array_length(_frameArray))
            {
                _frameBufferArray[@ _i] = _frameArray[_i].buffer;
                ++_i;
            }
            
            //Add the sprite to the project
            commandLine.AddSpriteToProject(_fileDesc.suggestedName, _frameBufferArray, _width, _height, _projectFolder);
        }
    }
    else //Not an Aseprite file
    {
        //This is some ugly legacy code. This is necessary for now but will get removed later
        var _fileInfo = __AbEnsureIngestFileInfo(_fileDesc.absolutePath);
        var _width  = _fileInfo.__GetWidth();
        var _height = _fileInfo.__GetHeight();
        
        //Add a sprite to the project using the suggested asset name. We also use the linked path
        //array to automatically create sprites that contain subimages that we found when we
        //called `.CollectImageFrames()` above
        commandLine.AddSpriteToProject(_fileDesc.suggestedName, _fileDesc.linkedPaths, _width, _height, _projectFolder);
    }
}));

//Iterate over every datafile and add it to the project
_soundFileList.Foreach(method({
    commandLine: _commandList,
    bucketName: "bufferDefault",
},
function(_fileDesc)
{
    //Add a sound to the project using the suggested asset name
    commandLine.AddSoundToProject(_fileDesc.suggestedName, _fileDesc.absolutePath, "Sounds");
}));

//Execute the command list. This is that method call that actually affects the project on disk
_commandList.SaveToProject(GM_project_filename);