/// @param noteName
/// @param string

function __BucketYYCreateNote(_noteName, _string)
{
    var _directory = $"{BUCKET_PROJECT_DIRECTORY}notes/{_noteName}/";
    
    var _yyString = _templateYY;
    _yyString = string_replace_all(_yyString, "%resourceName%", _noteName);
    _yyString = string_replace_all(_yyString, "%folderName%", BUCKET_PROJECT_NAME);
    _yyString = string_replace_all(_yyString, "%folderPath%", $"{BUCKET_PROJECT_NAME}.yyp");
    
    __BucketSaveString(_string, $"{_directory}{_noteName}.txt")
    __BucketSaveString(_yyString, $"{_directory}{_noteName}.yy");
    
    var _yypString = __BucketLoadString(GM_project_filename);
    var _oldYYPString = _yypString;
    
    var _resourcesContent = __BucketYYPExtract(_yypString, "resources");
    var _isEmptyArray = _resourcesContent.__emptyArray;
    if (_resourcesContent.__error)
    {
        __BucketError($"Failed to extract resources from \"{GM_project_filename}\"");
    }
    
    var _yypResourcesDict = {};
    var _yypResourcesArray = _resourcesContent.__array;
    var _i = 0;
    repeat(array_length(_yypResourcesArray))
    {
        _yypResourcesDict[$ _yypResourcesArray[_i].id.name] = true;
        ++_i;
    }
    
    var _resourcesString = _resourcesContent.__string;
    if (not struct_exists(_yypResourcesDict, _noteName))
    {
        if (_isEmptyArray) _resourcesString += "\n";
        _resourcesString += string_replace_all(_resourceTemplate, "%name%", _noteName);
        if (_isEmptyArray) _resourcesString += "  ";
    }
    
    _yypString = __BucketYYPInject(_yypString, _resourcesContent, _resourcesString);
    
    if (_yypString != _oldYYPString)
    {
        //Save the .yyp if anything's changed
        __BucketSaveString(_yypString, GM_project_filename);
    }
    
    static _templateYY = @'{
  "$GMNotes":"v1",
  "%Name":"%resourceName%",
  "name":"%resourceName%",
  "parent":{
    "name":"%folderName%",
    "path":"%folderPath%",
  },
  "resourceType":"GMNotes",
  "resourceVersion":"2.0",
}';
    
    static _resourceTemplate = "    {\"id\":{\"name\":\"%name%\",\"path\":\"notes/%name%/%name%.yy\",},},\n";
}