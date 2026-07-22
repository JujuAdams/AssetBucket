/// @param rootDirectory
/// @param sourcePath
/// @param soundName
/// @param folderInProject
/// @param audioGroupName

function __BucketYYWriteSoundFile(_rootDirectory, _sourcePath, _soundName, _folderInProject, _audioGroupName)
{
    var _directory = $"{BUCKET_PROJECT_DIRECTORY}sounds/{_soundName}/";
    var _soundFilename = filename_name(_sourcePath);
    
    //Grab the template and do some basic replacements
    var _yyString = _templateYY;
    _yyString = string_replace_all(_yyString, "%resourceName%", _soundName);
    _yyString = string_replace_all(_yyString, "%audioGroupName%", _audioGroupName);
    _yyString = string_replace_all(_yyString, "%soundFilename%", _soundFilename);
    
    //Set the in-project folder path
    if (_folderInProject == "")
    {
        var _parentName = BUCKET_PROJECT_NAME;
        var _parentPath = $"{BUCKET_PROJECT_NAME}.yyp";
    }
    else
    {
        _folderInProject = __BucketTrimDirectory(_folderInProject);
        var _parentPath = $"folders/{_folderInProject}.yy";
        var _parentName = $"{filename_name(_folderInProject)}.yy";
    }
    
    _yyString = string_replace_all(_yyString, "%folderName%", _parentName);
    _yyString = string_replace_all(_yyString, "%folderPath%", _parentPath);
    
    file_copy(_rootDirectory + _sourcePath, $"{_directory}{_soundFilename}");
    
    __BucketSaveString(_yyString, $"{_directory}{_soundName}.yy");
    
    
    
    static _templateYY = @'{
  "$GMSound":"v2",
  "%Name":"%resourceName%",
  "audioGroupId":{
    "name":"%audioGroupName%",
    "path":"audiogroups/%audioGroupName%",
  },
  "bitDepth":1,
  "channelFormat":0,
  "compression":0,
  "compressionQuality":4,
  "conversionMode":0,
  "duration":0.0,
  "exportDir":"",
  "name":"%resourceName%",
  "parent":{
    "name":"%folderName%",
    "path":"%folderPath%",
  },
  "preload":false,
  "resourceType":"GMSound",
  "resourceVersion":"2.0",
  "sampleRate":44100,
  "soundFile":"%soundFilename%",
  "volume":1.0,
}';
}