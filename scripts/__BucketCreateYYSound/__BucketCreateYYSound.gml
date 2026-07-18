/// @param sourcePath
/// @param soundName
/// @param folderInProject
/// @param audioGroupName
/// @param projectName
/// @param projectDirectory

function __BucketCreateYYSound(_sourcePath, _soundName, _folderInProject, _audioGroupName, _projectName, _projectDirectory)
{
    var _directory = $"{_projectDirectory}sounds/{_soundName}/";
    
    //Grab the template and do some basic replacements
    var _yyString = _templateYY;
    _yyString = string_replace_all(_yyString, "%resourceName%", _soundName);
    _yyString = string_replace_all(_yyString, "%audioGroupName%", _audioGroupName);
    _yyString = string_replace_all(_yyString, "%soundFilename%", $"{filename_name(_sourcePath)}");
    
    //Set the in-project folder path
    if (_folderInProject == "")
    {
        var _parentName = _projectName;
        var _parentPath = $"{_projectName}.yyp";
    }
    else
    {
        var _parentName = $"folders/{_folderInProject}/";
        var _parentPath = $"{filename_name(_folderInProject)}.yy";
    }
    
    _yyString = string_replace_all(_yyString, "%folderName%", _parentName);
    _yyString = string_replace_all(_yyString, "%folderPath%", _parentPath);
    
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