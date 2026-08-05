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
    compression        = AB_COMPRESSION_AUTO;
    compressionQuality = 4;
    conversionMode     = 0;
    duration           = 0;
    exportDir          = "";
    folder             = "";
    preload            = false;
    sampleRate         = 44100;
    volume             = 1;
    
    if (_projectStruct.GetAssetExists(_assetName) && file_exists(__yyPath))
    {
        var _yyData = __AbLoadJSON(__yyPath);
        
        assetName          = _yyData.name;
        audioGroupName     = _yyData.audioGroupId.name;
        bitDepth           = _yyData.bitDepth;
        channelFormat      = _yyData.channelFormat;
        compression        = _yyData.compression;
        compressionQuality = _yyData.compressionQuality;
        conversionMode     = _yyData.conversionMode;
        duration           = _yyData.duration;
        exportDir          = _yyData.exportDir;
        folder             = __AbStringifyYYFolderPath(_yyData.parent.path);
        preload            = _yyData.preload;
        sampleRate         = _yyData.sampleRate;
        volume             = _yyData.volume;
        
        __sourceFilePath = $"{AbFilenameDir(__yyPath)}/{_yyData.soundFile}";
        __destinationSoundPath = __sourceFilePath;
        
        if (not file_exists(__sourceFilePath))
        {
            __AbTrace($"Failed to sound file {__sourceFilePath} for .yy at \"{__sourceFilePath}\"");
        }
    }
    
    
    
    
    
    static SetSource = function(_sourcePath, _compression = undefined)
    {
        var _extension = filename_ext(_sourcePath);
        if ((_extension != ".wav") && (_extension != ".ogg"))
        {
            __AbError($"Audio file extension \"{_extension}\" not supported (must be .wav or .ogg)\nPath was \"{_sourcePath}\"");
        }
        
        //TODO - Set duration
        
        __sourceFilePath = _sourcePath;
        __destinationSoundPath = $"{AbFilenameDir(__yyPath)}/{assetName}{_extension}";
        
        if (_compression != undefined)
        {
            compression = _compression;
        }
        
        return self;
    }
    
    static SetFolderIfRoot = function(_fallback)
    {
        if (folder == "")
        {
            folder = _fallback;
        }
        
        return self;
    }
    
    static AddToCommandList = function(_commandList)
    {
        _commandList.AddSoundToProject(self);
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
        
        if (compression != AB_COMPRESSION_AUTO)
        {
            var _compression = compression;
        }
        else
        {
            var _compression = (filename_ext(__sourceFilePath) == ".ogg")? AB_COMPRESSION_COMPRESSED : AB_COMPRESSION_UNCOMPRESSED;
        }
        
        var _folderInfo = __AbMakeProjectFolderInfo(folder, __projectStruct);
        
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
        __AbBufferWritePair(_buffer, 2, "compression", _compression);
        __AbBufferWritePair(_buffer, 2, "compressionQuality", compressionQuality);
        __AbBufferWritePair(_buffer, 2, "conversionMode", conversionMode);
        __AbBufferWritePair(_buffer, 2, "duration", duration);
        __AbBufferWritePair(_buffer, 2, "exportDir", exportDir);
        __AbBufferWritePair(_buffer, 2, "name", assetName);
        __AbBufferWriteLine(_buffer, "  \"parent\":{");
        __AbBufferWriteLine(_buffer, $"    \"name\":\"{_folderInfo.__name}\",");
        __AbBufferWriteLine(_buffer, $"    \"path\":\"{_folderInfo.__path}\",");
        __AbBufferWriteLine(_buffer, "  },");
        __AbBufferWritePair(_buffer, 2, "preload", bool(preload));
        __AbBufferWritePair(_buffer, 2, "resourceType", "GMSound");
        __AbBufferWritePair(_buffer, 2, "resourceVersion", "2.0"); //Needs to be a string
        __AbBufferWritePair(_buffer, 2, "sampleRate", sampleRate);
        __AbBufferWritePair(_buffer, 2, "soundFile", filename_name(__destinationSoundPath));
        __AbBufferWriteDecimal(_buffer, 2, "volume", volume);
        __AbBufferWriteLine(_buffer, "}");
        
        buffer_save_ext(_buffer, __yyPath, 0, buffer_tell(_buffer)-1); //Trim off the final newline
        buffer_delete(_buffer);
        
        return self;
    }
}