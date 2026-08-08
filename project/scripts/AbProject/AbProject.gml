/// @param path

function AbProject(_path) constructor
{
    if (not file_exists(_path))
    {
        __AbError($"Could not find \"{_path}\"");
    }
    
    __path               = _path;
    __directory          = AbFilenameDir(_path) + "/";
    __datafilesDirectory = $"{AbFilenameDir(_path)}/datafiles/";
    
    __projectFilename = filename_name(_path);
    __projectName     = filename_change_ext(__projectFilename, "");
    
    __assetTree = undefined;
    
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
    
    static GetAssetTree = function()
    {
        if (__assetTree != undefined)
        {
            return __assetTree;
        }
        
        __assetTree = {};
        
        var _directory = __directory;
        var _assetTreeRoot = __assetTree;
        
        var _yypData = json_parse(__yypString);
        var _resourceArray = _yypData.resources;
        var _i = 0;
        repeat(array_length(_resourceArray))
        {
            var _localPath = _resourceArray[_i].id.path;
            var _absolutePath = _directory + _localPath;
            
            var _resourceYY = __AbLoadJSON(_absolutePath);
            var _folderPath = __AbStringifyYYFolderPath(_resourceYY.parent.path);
            
            var _folderStruct = _assetTreeRoot;
            if (_folderPath != "")
            {
                var _folderArray = string_split(_folderPath, "/");
                var _j = 0;
                repeat(array_length(_folderArray))
                {
                    var _nextFolderStruct = _folderStruct[$ _folderArray[_j]];
                    if (_nextFolderStruct == undefined)
                    {
                        _nextFolderStruct = {};
                        _folderStruct[$ _folderArray[_j]] = _nextFolderStruct;
                    }
                    
                    _folderStruct = _nextFolderStruct;
                    
                    ++_j;
                }
            }
            
            _folderStruct[$ _resourceYY.name] = _resourceYY.resourceType;
            ++_i;
        }
        
        return _assetTreeRoot;
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
        
        _folder = __AbStringifyYYFolderPath(_assetData.parent.path);
        __assetFolderDict[$ _assetName] = _folder;
        
        return _folder;
    }
    
    static MakeSound = function(_assetName)
    {
        return new __AbClassProjectSound(self, AsciiTransliterateNoSymbols(_assetName));
    }
    
    static MakeSprite = function(_assetName)
    {
        return new __AbClassProjectSprite(self, AsciiTransliterateNoSymbols(_assetName));
    }
    
    static __Save = function(_newAudioGroupDict, _newFolderDict, _newDatafileDict, _newResourceDict, _newTextureGroupDict)
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
                _path = AbFilenameDir(_path);
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