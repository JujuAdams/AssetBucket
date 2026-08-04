/// @param path

function AbProject(_path) constructor
{
    if (not file_exists(_path))
    {
        __AbError($"Could not find \"{_path}\"");
    }
    
    __path               = _path;
    __directory          = filename_dir(_path) + "/";
    __datafilesDirectory = $"{filename_dir(_path)}/datafiles/";
    
    __projectFilename = filename_name(_path);
    __projectName     = filename_change_ext(__projectFilename, "");
    
    __yypAudioGroupsDict   = {};
    __yypFoldersDict       = {};
    __yypDatafilesDict     = {};
    __yypResourcesDict     = {};
    __yypTextureGroupsDict = {};
    __assetFolderDict      = {};
    
    __yypString = __AbLoadString(_path);
    
    //Extract arrays as strings from the .yyp
    __audioGroupsContent   = __YYPExtract(__yypString, "AudioGroups");
    __foldersContent       = __YYPExtract(__yypString, "Folders");
    __datafilesContent     = __YYPExtract(__yypString, "IncludedFiles");
    __resourcesContent     = __YYPExtract(__yypString, "resources");
    __textureGroupsContent = __YYPExtract(__yypString, "TextureGroups");
    
    if (__audioGroupsContent.__error)
    {
        __AbError($"Failed to extract audio groups from \"{_path}\"");
    }
    
    if (__foldersContent.__error)
    {
        __AbError($"Failed to extract IDE folders from \"{_path}\"");
    }
    
    if (__datafilesContent.__error)
    {
        __AbError($"Failed to extract datafiles from \"{_path}\"");
    }
    
    if (__resourcesContent.__error)
    {
        __AbError($"Failed to extract resources from \"{_path}\"");
    }
    
    if (__textureGroupsContent.__error)
    {
        __AbError($"Failed to extract texture groups from \"{_path}\"");
    }
    
    //Unpack arrays into dictionaries for faster lookups
    var _yypAudioGroupsDict = __yypAudioGroupsDict;
    var _yypAudioGroupsArray = __audioGroupsContent.__array;
    var _i = 0;
    repeat(array_length(_yypAudioGroupsArray))
    {
        _yypAudioGroupsDict[$ _yypAudioGroupsArray[_i].name] = true;
        ++_i;
    }
    
    var _yypFoldersDict = __yypFoldersDict;
    var _yypFoldersArray = __foldersContent.__array;
    var _i = 0;
    repeat(array_length(_yypFoldersArray))
    {
        _yypFoldersDict[$ string_delete(filename_change_ext(_yypFoldersArray[_i].folderPath, ""), 1, 8)] = true;
        ++_i;
    }
    
    var _yypDatafilesDict = __yypDatafilesDict;
    var _yypDatafilesArray = __datafilesContent.__array;
    var _i = 0;
    repeat(array_length(_yypDatafilesArray))
    {
        _yypDatafilesDict[$ _yypDatafilesArray[_i].name] = true;
        ++_i;
    }
    
    var _yypResourcesDict = __yypResourcesDict;
    var _yypResourcesArray = __resourcesContent.__array;
    var _i = 0;
    repeat(array_length(_yypResourcesArray))
    {
        var _resource = _yypResourcesArray[_i].id;
        _yypResourcesDict[$ _resource.name] = _resource.path;
        ++_i;
    }
    
    var _yypTextureGroupsDict = __yypTextureGroupsDict;
    var _yypTextureGroupsArray = __textureGroupsContent.__array;
    var _i = 0;
    repeat(array_length(_yypTextureGroupsArray))
    {
        _yypTextureGroupsDict[$ _yypTextureGroupsArray[_i][$ "%Name"]] = true;
        ++_i;
    }
    
    
    
    
    
    static __Destroy = function()
    {
        // TODO
    }
    
    static GetAssetExists = function(_assetName)
    {
        return struct_exists(__yypResourcesDict, _assetName);
    }
    
    static GetAssetFolder = function(_assetName)
    {
        var _folder = __assetFolderDict[$ _assetName];
        if (is_string(_folder))
        {
            return _folder;
        }
        
        var _localPath = __yypResourcesDict[$ _assetName];
        if (not struct_exists(__yypResourcesDict, _assetName))
        {
            return undefined;
        }
        
        var _assetData = __AbLoadJSON(__directory + _localPath);
        _folder = _assetData.parent.path;
        
        if (string_copy(_folder, 1, 8) == "folders/")
        {
            _folder = string_delete(_folder, 1, 8);
            
            if (string_copy(_folder, string_length(_folder)-2, 3) == ".yy")
            {
                _folder = string_copy(_folder, 1, string_length(_folder)-3);
            }
        }
        else if (_folder == __projectFilename)
        {
            _folder = "";
        }
        
        __assetFolderDict[$ _assetName] = _folder;
        return _folder;
    }
    
    static __SaveSound = function(_sourcePath, _soundName, _folderInProject, _compression = undefined, _audioGroupName = undefined)
    {
        var _extension = filename_ext(_sourcePath);
        if ((_extension == ".wav") && (_extension == ".ogg"))
        {
            __AbError($"Audio file extension \"{_extension}\" not supported (must be .wav or .ogg)\nPath was \"{_sourcePath}\"");
        }
        
        var _yyPath = $"{__directory}sounds/{_soundName}/{_soundName}.yy";
        if (file_exists(_yyPath))
        {
            var _soundStruct = (new __AbClassProjectSound())
                               .__Deserialize(_yyPath)
                               .__Overwrite(_sourcePath, self, _folderInProject, _compression, _audioGroupName);
        }
        else
        {
            var _soundStruct = (new __AbClassProjectSound())
                               .__Template(_sourcePath, self, _soundName, _folderInProject, _compression, _audioGroupName);
        }
        
        _soundStruct.__Save(_yyPath);
    }
    
    static __SaveSprite = function(_pathArray, _spriteName, _width, _height, _folderInProject, _textureGroupName)
    {
        var _yyPath = $"{__directory}sprites/{_spriteName}/{_spriteName}.yy";
        if (file_exists(_yyPath))
        {
            var _spriteStruct = (new __AbClassProjectSprite())
                                .__Deserialize(_yyPath)
                                .__Overwrite(_pathArray, self, _width, _height, _folderInProject, _textureGroupName);
        }
        //else
        //{
        //    var _spriteStruct = (new __AbClassProjectSprite())
        //                        .__Template(_pathArray, self, _spriteName, _width, _height, _folderInProject, _textureGroupName);
        //}
        //
        //_spriteStruct.__Save(_yyPath);
        
        
        var _frameCount = array_length(_pathArray);
        
        var _framePathArray = __SaveSpriteYY(_spriteName, _frameCount, _width, _height, _folderInProject, _textureGroupName);
        
        var _i = 0;
        repeat(_frameCount)
        {
            var _sourcePath    = _pathArray[_i];
            var _savePathArray = _framePathArray[_i];
            
            if (is_struct(_sourcePath))
            {
                __AbSaveBufferAsPNG(_savePathArray[0], _sourcePath.buffer, _sourcePath.width, _sourcePath.height, _sourcePath[$ "offset"] ?? 0);
            }
            else if (is_handle(_sourcePath) && buffer_exists(_sourcePath))
            {
                __AbSaveBufferAsPNG(_savePathArray[0], _sourcePath, _width, _height, 0);
            }
            else
            {
                file_copy(_sourcePath, _savePathArray[0]);
            }
            
            file_copy(_savePathArray[0], _savePathArray[1]);
            
            ++_i;
        }
    }
    
    static __SaveSpriteYY = function(_spriteName, _frameCount, _width, _height, _folderInProject, _textureGroupName)
    {
        var _directory = $"{__directory}sprites/{_spriteName}/";
        
        if (directory_exists(_directory))
        {
            __AbTrace($"Sprite asset directory \"{_directory}\" already exists; deleting and recreating");
            directory_destroy(_directory);
        }
        
        var _framePathArray = array_create(_frameCount, undefined);
        
        //Generate UUIDs
        var _frameUUIDArray = array_create_ext(_frameCount, __GenerateUUID);
        var _layerUUID    = __GenerateUUID();
        var _seqFrameUUID = __GenerateUUID();
        
        //Grab the template and do some basic replacements
        var _yyString = _templateYY;
        _yyString = string_replace_all(_yyString, "%resourceName%", _spriteName);
        _yyString = string_replace_all(_yyString, "%textureGroupName%", _textureGroupName);
        _yyString = string_replace_all(_yyString, "%layerUUID%", _layerUUID);
        _yyString = string_replace_all(_yyString, "%seqFrameUUID%", _seqFrameUUID);
        _yyString = string_replace_all(_yyString, "%width%", _width);
        _yyString = string_replace_all(_yyString, "%height%", _height);
        
        //Set the in-project folder path
        if (_folderInProject == "")
        {
            var _parentName = __projectName;
            var _parentPath = __projectFilename;
        }
        else
        {
            _folderInProject = __AbTrimDirectory(_folderInProject);
            var _parentPath = $"folders/{_folderInProject}.yy";
            var _parentName = $"{filename_name(_folderInProject)}.yy";
        }
        
        _yyString = string_replace_all(_yyString, "%folderName%", _parentName);
        _yyString = string_replace_all(_yyString, "%folderPath%", _parentPath);
        
        //Generate the frame array, sequence frame array, and also copy files around
        var _frameArrayString = "";
        var _seqFrameArrayString = "";
        
        var _i = 0;
        repeat(_frameCount)
        {
            var _frameUUID = _frameUUIDArray[_i];
            
            //Add to the frame array string
            _frameArrayString += string_replace_all(_templateFrame, "%frameUUID%", _frameUUID);
            
            //Add to the sequence frame array string
            var _seqFrameArraySubtring = _templateSeqFrame;
            _seqFrameArraySubtring = string_replace_all(_seqFrameArraySubtring, "%resourceName%", _spriteName);
            _seqFrameArraySubtring = string_replace_all(_seqFrameArraySubtring, "%frameUUID%", _frameUUID);
            _seqFrameArraySubtring = string_replace_all(_seqFrameArraySubtring, "%frameIndex%", _i);
            _seqFrameArraySubtring = string_replace_all(_seqFrameArraySubtring, "%seqFrameUUID%", __GenerateUUID());
            _seqFrameArrayString += _seqFrameArraySubtring;
            
            //Record the paths for saving images
            _framePathArray[@ _i] = [ $"{_directory}{_frameUUID}.png", $"{_directory}layers/{_frameUUID}/{_layerUUID}.png"];
            
            ++_i;
        }
        
        //Trim off the trailing newline
        _frameArrayString = string_copy(_frameArrayString, 1, string_length(_frameArrayString)-1);
        _seqFrameArrayString = string_copy(_seqFrameArrayString, 1, string_length(_seqFrameArrayString)-1);
        
        _yyString = string_replace_all(_yyString, "%frameArray%", _frameArrayString);
        _yyString = string_replace_all(_yyString, "%seqFrameArray%", _seqFrameArrayString);
        
        __AbSaveString(_yyString, $"{_directory}{_spriteName}.yy");
        
        return _framePathArray;
        
        static _templateFrame = @'    {"$GMSpriteFrame":"v1","%Name":"%frameUUID%","name":"%frameUUID%","resourceType":"GMSpriteFrame","resourceVersion":"2.0",},
';
        
        static _templateSeqFrame = @'            {"$Keyframe<SpriteFrameKeyframe>":"","Channels":{
                "0":{"$SpriteFrameKeyframe":"","Id":{"name":"%frameUUID%","path":"sprites/%resourceName%/%resourceName%.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},
              },"Disabled":false,"id":"%seqFrameUUID%","IsCreationKey":false,"Key":%frameIndex%.0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,},
';
        
        static _templateYY = @'{
  "$GMSprite":"v2",
  "%Name":"%resourceName%",
  "bboxMode":0,
  "bbox_bottom":0,
  "bbox_left":0,
  "bbox_right":0,
  "bbox_top":0,
  "collisionKind":1,
  "collisionTolerance":0,
  "DynamicTexturePage":false,
  "edgeFiltering":false,
  "For3D":false,
  "frames":[
%frameArray%
  ],
  "gridX":0,
  "gridY":0,
  "height":%height%,
  "HTile":false,
  "layers":[
    {"$GMImageLayer":"","%Name":"%layerUUID%","blendMode":0,"displayName":"default","isLocked":false,"name":"%layerUUID%","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,},
  ],
  "name":"%resourceName%",
  "nineSlice":null,
  "origin":0,
  "parent":{
    "name":"%folderName%",
    "path":"%folderPath%",
  },
  "preMultiplyAlpha":false,
  "resourceType":"GMSprite",
  "resourceVersion":"2.0",
  "sequence":{
    "$GMSequence":"v1",
    "%Name":"%resourceName%",
    "autoRecord":true,
    "backdropHeight":768,
    "backdropImageOpacity":0.5,
    "backdropImagePath":"",
    "backdropWidth":1366,
    "backdropXOffset":0.0,
    "backdropYOffset":0.0,
    "events":{
      "$KeyframeStore<MessageEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MessageEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "eventStubScript":null,
    "eventToFunction":{},
    "length":1.0,
    "lockOrigin":false,
    "moments":{
      "$KeyframeStore<MomentsEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MomentsEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "name":"{resourceName}",
    "playback":1,
    "playbackSpeed":30.0,
    "playbackSpeedType":0,
    "resourceType":"GMSequence",
    "resourceVersion":"2.0",
    "showBackdrop":true,
    "showBackdropImage":false,
    "timeUnits":1,
    "tracks":[
      {"$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[
%seqFrameArray%
          ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":null,"trackColour":0,"tracks":[],"traits":0,},
    ],
    "visibleRange":null,
    "volume":1.0,
    "xorigin":0,
    "yorigin":0,
  },
  "swatchColours":null,
  "swfPrecision":0.5,
  "textureGroupId":{
    "name":"%textureGroupName%",
    "path":"texturegroups/%textureGroupName%",
  },
  "type":0,
  "VTile":false,
  "width":%width%,
}';
    }
    
    static __GenerateUUID = function()
    {
        //UUIDv4 as per https://www.cryptosys.net/pki/uuid-rfc4122.html
        
        var _UUID = md5_string_unicode(string(irandom(0xFFFFFFFF)) + string(irandom(0xFFFFFFFF)) + string(irandom(0xFFFFFFFF)) + string(irandom(0xFFFFFFFF)));
        _UUID = string_set_byte_at(_UUID, 13, ord("4"));
        _UUID = string_set_byte_at(_UUID, 17, ord(choose("8", "9", "a", "b")));
        _UUID = string_copy(_UUID, 1, 8) + "-" + string_copy(_UUID, 9, 4) + "-" + string_copy(_UUID, 13, 4) + "-" + string_copy(_UUID, 17, 4) + "-" + string_copy(_UUID, 21, 12);
        
        return _UUID;
    }
    
    static __SaveNoteImmediate = function(_noteName, _folderInProject, _string)
    {
        var _directory = $"{__directory}notes/{_noteName}/";
        
        //Set the in-project folder path
        if (_folderInProject == "")
        {
            var _parentName = __projectName;
            var _parentPath = __projectFilename;
        }
        else
        {
            _folderInProject = __AbTrimDirectory(_folderInProject);
            var _parentPath = $"folders/{_folderInProject}.yy";
            var _parentName = $"{filename_name(_folderInProject)}.yy";
        }
        
        var _yyString = _templateYY;
        _yyString = string_replace_all(_yyString, "%resourceName%", _noteName);
        _yyString = string_replace_all(_yyString, "%folderName%", _parentName);
        _yyString = string_replace_all(_yyString, "%folderPath%", _parentPath);
    
        __AbSaveString(_string, $"{_directory}{_noteName}.txt")
        __AbSaveString(_yyString, $"{_directory}{_noteName}.yy");
        
        var _resourcesContent = __YYPExtract(__yypString, "resources");
        var _isEmptyArray = _resourcesContent.__emptyArray;
        if (_resourcesContent.__error)
        {
            __AbError($"Failed to extract resources from \"{__path}\"");
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
        
        var _yypString = __YYPInject(__yypString, _resourcesContent, _resourcesString);
        if (_yypString != __yypString)
        {
            //Save the .yyp if anything's changed
            __AbSaveString(_yypString, GM_project_filename);
            __yypString = _yyString;
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
    
    static __SaveYY = function(_newAudioGroupDict, _newFolderDict, _newDatafileDict, _newResourceDict, _newTextureGroupDict)
    {
        //Skip .yyp modification if we have nothing to add
        if ((struct_names_count(_newAudioGroupDict) <= 0)
        &&  (struct_names_count(_newFolderDict) <= 0)
        &&  (struct_names_count(_newDatafileDict) <= 0)
        &&  (struct_names_count(_newResourceDict) <= 0)
        &&  (struct_names_count(_newTextureGroupDict) <= 0))
        {
            return;
        }
        
        file_copy(__path, $"{__path}.old");
        var _yypString = __yypString;
        
        //Expand folder paths
        _newFolderDict = variable_clone(_newFolderDict);
        var _ensureFolderArray = struct_get_names(_newFolderDict);
        
        var _i = 0;
        repeat(array_length(_ensureFolderArray))
        {
            var _path = _ensureFolderArray[_i];
            while(_path != "")
            {
                _newFolderDict[$ _path] = true;
                _path = filename_dir(_path);
            }
            
            ++_i;
        }
        
        //Add new entries to each array-string
        var _newAudioGroupsString   = __audioGroupsContent.__string;
        var _newFoldersString       = __foldersContent.__string;
        var _newDatafilesString     = __datafilesContent.__string;
        var _newResourcesString     = __resourcesContent.__string;
        var _newTextureGroupsString = __textureGroupsContent.__string;
        
        _newAudioGroupsString   = _funcContentBuild(       _newAudioGroupsString,   __audioGroupsContent.__emptyArray,   _newAudioGroupDict,   __yypAudioGroupsDict,   _audioGroupTemplate                 );
        _newFoldersString       = _funcContentBuildFolders(_newFoldersString,       __foldersContent.__emptyArray,       _newFolderDict,       __yypFoldersDict,       _folderTemplate                     );
        _newDatafilesString     = _funcContentBuild(       _newDatafilesString,     __datafilesContent.__emptyArray,     _newDatafileDict,     __yypDatafilesDict,     _datafileTemplate                   );
        _newResourcesString     = _funcContentBuildExt(    _newResourcesString,     __resourcesContent.__emptyArray,     _newResourceDict,     __yypResourcesDict,     _resourceTemplate,    "resourceType");
        _newTextureGroupsString = _funcContentBuild(       _newTextureGroupsString, __textureGroupsContent.__emptyArray, _newTextureGroupDict, __yypTextureGroupsDict, _textureGroupTemplate               );
        
        static _funcContentBuild = function(_string, _isEmptyArray, _ensureDict, _existingDict, _templateString)
        {
            var _ensureArray = struct_get_names(_ensureDict);
            var _addedContent = false;
            var _i = 0;
            repeat(array_length(_ensureArray))
            {
                var _newName = _ensureArray[_i];
                if (not struct_exists(_existingDict, _newName))
                {
                    if ((not _addedContent) && _isEmptyArray)
                    {
                        _string += "\n";
                    }
                    
                    _addedContent = true;
                    _string += string_replace_all(_templateString, "%name%", _newName);
                }
                
                ++_i;
            }
            if (_addedContent && _isEmptyArray) _string += "  ";
            
            return _string;
        }
        
        static _funcContentBuildFolders = function(_string, _isEmptyArray, _ensureDict, _existingDict, _templateString, _replaceExt)
        {
            var _ensureArray = struct_get_names(_ensureDict);
            var _addedContent = false;
            var _i = 0;
            repeat(array_length(_ensureArray))
            {
                var _path = _ensureArray[_i];
                if (not struct_exists(_existingDict, _path))
                {
                    if ((not _addedContent) && _isEmptyArray)
                    {
                        _string += "\n";
                    }
                    
                    _addedContent = true;
                    _string += string_replace_all(string_replace_all(_templateString, "%name%", filename_name(_path)), "%path%", _path);
                }
                
                ++_i;
            }
            if (_addedContent && _isEmptyArray) _string += "  ";
            
            return _string;
        }
        
        static _funcContentBuildExt = function(_string, _isEmptyArray, _ensureDict, _existingDict, _templateString, _replaceExt)
        {
            var _replaceExtSubstring = $"%{_replaceExt}%";
            
            var _ensureArray = struct_get_names(_ensureDict);
            var _addedContent = false;
            var _i = 0;
            repeat(array_length(_ensureArray))
            {
                var _newName = _ensureArray[_i];
                var _newExt  = _ensureDict[$ _newName];
                
                if (not struct_exists(_existingDict, _newName))
                {
                    if ((not _addedContent) && _isEmptyArray)
                    {
                        _string += "\n";
                    }
                    
                    _addedContent = true;
                    _string += string_replace_all(string_replace_all(_templateString, "%name%", _newName), _replaceExtSubstring, _newExt);
                }
                
                ++_i;
            }
            if (_addedContent && _isEmptyArray) _string += "  ";
            
            return _string;
        }
        
        //Inject strings back into the .yyp
        // N.B. Order is important here!
        _yypString = __YYPInject(_yypString, __textureGroupsContent, _newTextureGroupsString);
        _yypString = __YYPInject(_yypString, __resourcesContent,     _newResourcesString);
        _yypString = __YYPInject(_yypString, __datafilesContent,     _newDatafilesString);
        _yypString = __YYPInject(_yypString, __foldersContent,       _newFoldersString);
        _yypString = __YYPInject(_yypString, __audioGroupsContent,   _newAudioGroupsString);
        
        if (_yypString != __yypString)
        {
            //Save the .yyp if anything's changed
            __AbSaveString(_yypString, __path);
        }
        
        static _audioGroupTemplate = "    {\"$GMAudioGroup\":\"v1\",\"%Name\":\"%name%\",\"exportDir\":\"\",\"name\":\"%name%\",\"resourceType\":\"GMAudioGroup\",\"resourceVersion\":\"2.0\",\"targets\":-1,},\n";
        
        static _folderTemplate = "    {\"$GMFolder\":\"\",\"%Name\":\"%name%\",\"folderPath\":\"folders/%path%.yy\",\"name\":\"%name%\",\"resourceType\":\"GMFolder\",\"resourceVersion\":\"2.0\",},\n";
        
        static _datafileTemplate = "    {\"$GMIncludedFile\":\"\",\"%Name\":\"%name%\",\"CopyToMask\":-1,\"filePath\":\"datafiles\",\"name\":\"%name%\",\"resourceType\":\"GMIncludedFile\",\"resourceVersion\":\"2.0\",},\n";
        
        static _resourceTemplate = "    {\"id\":{\"name\":\"%name%\",\"path\":\"%resourceType%/%name%/%name%.yy\",},},\n";
        
        static _textureGroupTemplate = "    {\"$GMTextureGroup\":\"\",\"%Name\":\"%name%\",\"autocrop\":true,\"border\":2,\"compressFormat\":\"bz2\",\"customOptions\":\"\",\"directory\":\"\",\"groupParent\":null,\"isScaled\":true,\"loadType\":\"default\",\"mipsToGenerate\":0,\"name\":\"%name%\",\"resourceType\":\"GMTextureGroup\",\"resourceVersion\":\"2.0\",\"targets\":-1,},\n";
    }
    
    static __YYPExtract = function(_yypString, _propertyName)
    {
        var _substring = $"  \"{_propertyName}\":[\r\n";
        var _startPos = string_pos(_substring, _yypString);
        if (_startPos > 0)
        {
            _startPos += string_length(_substring);
        }
        else
        {
            _substring = $"  \"{_propertyName}\":[\n";
            _startPos = string_pos(_substring, _yypString);
        
            if (_startPos > 0)
            {
                _startPos += string_length(_substring);
            }
            else
            {
                _substring = $"  \"{_propertyName}\":[],";
                _startPos = string_pos(_substring, _yypString);
                if (_startPos > 0)
                {
                    _startPos += string_length(_substring) - 2;
                
                    return {
                        __array:      [],
                        __string:     "",
                        __startPos:   _startPos,
                        __endPos:     _startPos,
                        __emptyArray: true,
                        __error:      false,
                    };
                }
            }
        }
    
        if (_startPos > 0)
        {
            var _endPos = string_pos_ext("   ],\r\n", _yypString, _startPos);
            if (_endPos <= 0)
            {
                _endPos = string_pos_ext("  ],\n", _yypString, _startPos);
            }
        
            if (_endPos > 0)
            {
                with({})
                {
                    __string     = string_copy(_yypString, _startPos, _endPos - _startPos);
                    __startPos   = _startPos;
                    __endPos     = _endPos;
                    __emptyArray = false;
                
                    try
                    {
                        __array = json_parse($"[{__string}]");
                        __error = false;
                    }
                    catch(_error)
                    {
                        show_debug_message(_error);
                        __array = [];
                        __error = true;
                    }
                
                    return self;
                }
            }
        }
    
        return {
            __array:      [],
            __string:     "",
            __startPos:   _startPos,
            __endPos:     _startPos,
            __emptyArray: false,
            __error:      true,
        }
    }
    
    static __YYPInject = function(_yypString, _contentStruct, _string)
    {
        _yypString = string_delete(_yypString, _contentStruct.__startPos, _contentStruct.__endPos - _contentStruct.__startPos);
        _yypString = string_insert(_string, _yypString, _contentStruct.__startPos);
        return _yypString;
    }
}