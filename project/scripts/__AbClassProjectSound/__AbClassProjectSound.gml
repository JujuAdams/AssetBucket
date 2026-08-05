function __AbClassProjectSound(_projectStruct, _assetName) constructor
{
    __projectStruct        = _projectStruct;
    __yyPath               = $"{_projectStruct.__directory}sounds/{_assetName}/{_assetName}.yy";
    __destinationSoundPath = undefined;
    __sourceFilePath       = undefined;
    
    assetName          = _assetName;
    audioGroupName     = "audiogroup_default";
    bitDepth           = 1;
    channelFormat      = 1;
    compression        = undefined;
    compressionQuality = 4;
    conversionMode     = 0;
    duration           = 0;
    exportDir          = "";
    folderInfo         = __AbMakeProjectFolderInfo("", _projectStruct);
    preload            = false;
    sampleRate         = 44100;
    volume             = 1;
    
    if (_projectStruct.GetAssetExists(_assetName) && file_exists(__yyPath))
    {
        var _yypData = __AbLoadJSON(__yyPath);
        
        assetName          = _yypData.name;
        audioGroupName     = _yypData.audioGroupId.name;
        bitDepth           = _yypData.bitDepth;
        channelFormat      = _yypData.channelFormat;
        compression        = _yypData.compression;
        compressionQuality = _yypData.compressionQuality;
        conversionMode     = _yypData.conversionMode;
        duration           = _yypData.duration;
        exportDir          = _yypData.exportDir;
        folderInfo         = { __name: _yypData.parent.name, __path: _yypData.parent.path }; //TODO - Refactor to a path string
        preload            = _yypData.preload;
        sampleRate         = _yypData.sampleRate;
        volume             = _yypData.volume;
        
        __sourceFilePath = $"{AbFilenameDir(__yyPath)}/{soundFilename}";
        __destinationSoundPath = __sourceFilePath;
        
        if (not file_exists(__sourceFilePath))
        {
            __AbTrace($"Failed to sound file {__sourceFilePath} for .yy at \"{__sourceFilePath}\"");
        }
    }
    
    
    
    
    
    static Edit = function(_sourcePath, _projectFolder = undefined, _compression = undefined, _audioGroupName = undefined)
    {
        var _extension = filename_ext(_sourcePath);
        if (_extension == ".wav")
        {
            _compression ??= AB_COMPRESSION_SETTING_UNCOMPRESSED;
        }
        else if (_extension == ".ogg")
        {
            _compression ??= AB_COMPRESSION_SETTING_COMPRESSED;
        }
        else
        {
            __AbError($"Audio file extension \"{_extension}\" not supported (must be .wav or .ogg)\nPath was \"{_sourcePath}\"");
        }
        
        __sourceFilePath = _sourcePath;
        __destinationSoundPath = $"{AbFilenameDir(__yyPath)}/{assetName}{_extension}";
        
        if (_projectFolder != undefined)
        {
            __AbMakeProjectFolderInfo(_projectFolder, __projectStruct, folderInfo);
        }
        
        if (_compression != undefined)
        {
            compression = _compression;
        }
        
        if (_audioGroupName != undefined)
        {
            audioGroupName = _audioGroupName;
        }
        
        return self;
    }
    
    static Save = function()
    {
        if (__sourceFilePath == undefined)
        {
            __AbError($"Sound source file not set for asset \"{assetName}\"");
        }
        else if (__sourceFilePath != __destinationSoundPath)
        {
            if (not file_exists(__sourceFilePath))
            {
                __AbError($"Sound source file \"{__sourceFilePath}\" could not be found (asset \"{assetName}\")");
            }
            
            file_copy(__sourceFilePath, __destinationSoundPath);
        }
        
        var _buffer = buffer_create(1024, buffer_grow, 1);
        
        __AbBufferWriteLine(_buffer, "{");
        __AbBufferWritePair(_buffer, 2, "$GMSound", "v2");
        __AbBufferWritePair(_buffer, 2, "%Name", assetName);
        __AbBufferWriteLine(_buffer, "  \"audioGroupId\":{");
        __AbBufferWriteLine(_buffer, $"    \"name\":\"{audioGroupName}\",");
        __AbBufferWriteLine(_buffer, $"    \"path\":\"audiogroups/{audioGroupName}\",");
        __AbBufferWriteLine(_buffer, "  },");
        __AbBufferWritePair(_buffer, 2, "bitDepth", bitDepth);
        __AbBufferWritePair(_buffer, 2, "channelFormat", channelFormat);
        __AbBufferWritePair(_buffer, 2, "compression", compression);
        __AbBufferWritePair(_buffer, 2, "compressionQuality", compressionQuality);
        __AbBufferWritePair(_buffer, 2, "conversionMode", conversionMode);
        __AbBufferWritePair(_buffer, 2, "duration", duration);
        __AbBufferWritePair(_buffer, 2, "exportDir", exportDir);
        __AbBufferWritePair(_buffer, 2, "name", assetName);
        __AbBufferWriteLine(_buffer, "  \"parent\":{");
        __AbBufferWriteLine(_buffer, $"    \"name\":\"{folderInfo.__name}\",");
        __AbBufferWriteLine(_buffer, $"    \"path\":\"{folderInfo.__path}\",");
        __AbBufferWriteLine(_buffer, "  },");
        __AbBufferWritePair(_buffer, 2, "preload", bool(preload));
        __AbBufferWritePair(_buffer, 2, "resourceType", "GMSound");
        __AbBufferWritePair(_buffer, 2, "resourceVersion", "2.0"); //Needs to be a string
        __AbBufferWritePair(_buffer, 2, "sampleRate", sampleRate);
        __AbBufferWritePair(_buffer, 2, "soundFile", filename_name(__destinationSoundPath));
        __AbBufferWritePair(_buffer, 2, "volume", volume);
        __AbBufferWriteLine(_buffer, "}");
        
        buffer_save_ext(_buffer, __yyPath, 0, buffer_tell(_buffer));
        buffer_delete(_buffer);
        
        return self;
    }
}