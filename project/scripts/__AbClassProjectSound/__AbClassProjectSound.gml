function __AbClassProjectSound() constructor
{
    __sourceFilePath = undefined;
    
    __assetName          = undefined;
    __audioGroupName     = undefined;
    __bitDepth           = undefined;
    __channelFormat      = undefined;
    __compression        = undefined;
    __compressionQuality = undefined;
    __conversionMode     = undefined;
    __duration           = undefined;
    __exportDir          = undefined;
    __folderName         = undefined;
    __folderPath         = undefined;
    __preload            = undefined;
    __sampleRate         = undefined;
    __soundFilename      = undefined;
    __volume             = undefined;
    
    
    
    
    
    static __Template = function(_sourcePath, _projectStruct, _assetName, _projectFolder, _compression = undefined, _audioGroupName = "audiogroup_default")
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
        
        //Set the in-project folder path
        if (_projectFolder == "")
        {
            var _folderName = _projectStruct.__projectName;
            var _folderPath = _projectStruct.__projectFilename;
        }
        else
        {
            _projectFolder = __AbTrimDirectory(_projectFolder);
            var _folderName = $"{filename_name(_projectFolder)}.yy";
            var _folderPath = $"folders/{_projectFolder}.yy";
        }
        
        __TemplateExt(_sourcePath, _assetName, _folderName, _folderPath, _compression, _audioGroupName);
        
        return self;
    }
    
    static __TemplateExt = function(_sourcePath, _assetName, _folderName, _folderPath, _compression, _audioGroupName)
    {
        __sourceFilePath = _sourcePath;
        
        __assetName          = _assetName;
        __audioGroupName     = _audioGroupName;
        __bitDepth           = 1;
        __channelFormat      = 1;
        __compression        = _compression;
        __compressionQuality = 4;
        __conversionMode     = 0;
        __duration           = 0;
        __exportDir          = "";
        __folderName         = _folderName;
        __folderPath         = _folderPath;
        __preload            = false;
        __sampleRate         = 44100;
        __soundFilename      = filename_name(_sourcePath);
        __volume             = 1;
        
        return self;
    }
    
    static __DeserializeFrom = function(_path)
    {
        var _yypData = __AbLoadJSON(_path);
        
        __assetName          = _yypData.name;
        __audioGroupName     = _yypData.audioGroupId.name;
        __bitDepth           = _yypData.bitDepth;
        __channelFormat      = _yypData.channelFormat;
        __compression        = _yypData.compression;
        __compressionQuality = _yypData.compressionQuality;
        __conversionMode     = _yypData.conversionMode;
        __duration           = _yypData.duration;
        __exportDir          = _yypData.exportDir;
        __folderName         = _yypData.parent.name;
        __folderPath         = _yypData.parent.path;
        __preload            = _yypData.preload;
        __sampleRate         = _yypData.sampleRate;
        __soundFilename      = _yypData.soundFile;
        __volume             = _yypData.volume;
        
        __sourceFilePath = __GetExpectedSoundFilePath(_path);
        
        if (not file_exists(__sourceFilePath))
        {
            __AbTrace($"Failed to sound file {__sourceFilePath} for .yy at \"{_path}\"");
        }
        
        return self;
    }
    
    static __Overwrite = function(_sourcePath, _projectStruct, _assetName, _projectFolder, _compression, _audioGroupName)
    {
        __sourceFilePath = _sourcePath;
        
        //Set the in-project folder path
        if (_projectFolder == "")
        {
            var _folderName = _projectStruct.__projectName;
            var _folderPath = _projectStruct.__projectFilename;
        }
        else
        {
            _projectFolder = __AbTrimDirectory(_projectFolder);
            var _folderName = $"folders/{_projectFolder}.yy";
            var _folderPath = $"{filename_name(_projectFolder)}.yy";
        }
        
        __assetName = _assetName;
        
        if (_compression != undefined)
        {
            __compression = _compression;
        }
        
        if (_audioGroupName != undefined)
        {
            __audioGroupName = _audioGroupName;
        }
    }
    
    static __GetExpectedSoundFilePath = function(_yyPath)
    {
        return $"{filename_dir(_yyPath)}/{__soundFilename}";
    }
    
    static __Save = function(_yyPath)
    {
        if (__sourceFilePath == undefined)
        {
            __AbError($"Sound source file not set for asset \"{__assetName}\"");
        }
        else if (__sourceFilePath != __GetExpectedSoundFilePath(_yyPath))
        {
            if (not file_exists(__sourceFilePath))
            {
                __AbError($"Sound source file \"{__sourceFilePath}\" could not be found (asset \"{__assetName}\")");
            }
            
            file_copy(__sourceFilePath, __GetExpectedSoundFilePath(_yyPath));
        }
        
        var _buffer = buffer_create(1024, buffer_grow, 1);
        
        __AbBufferWriteLine(_buffer, "{");
        __AbBufferWritePair(_buffer, "$GMSound", "v2");
        __AbBufferWritePair(_buffer, "%Name", __assetName);
        __AbBufferWriteLine(_buffer, "  \"audioGroupId\":{");
        __AbBufferWriteLine(_buffer, $"    \"name\":\"{__audioGroupName}\",");
        __AbBufferWriteLine(_buffer, $"    \"path\":\"audiogroups/{__audioGroupName}\",");
        __AbBufferWriteLine(_buffer, "  },");
        __AbBufferWritePair(_buffer, "bitDepth", __bitDepth);
        __AbBufferWritePair(_buffer, "channelFormat", __channelFormat);
        __AbBufferWritePair(_buffer, "compression", __compression);
        __AbBufferWritePair(_buffer, "compressionQuality", __compressionQuality);
        __AbBufferWritePair(_buffer, "conversionMode", __conversionMode);
        __AbBufferWritePair(_buffer, "duration", __duration);
        __AbBufferWritePair(_buffer, "exportDir", __exportDir);
        __AbBufferWritePair(_buffer, "name", __assetName);
        __AbBufferWriteLine(_buffer, "  \"parent\":{");
        __AbBufferWriteLine(_buffer, $"    \"name\":\"{__folderName}\",");
        __AbBufferWriteLine(_buffer, $"    \"path\":\"{__folderPath}\",");
        __AbBufferWriteLine(_buffer, "  },");
        __AbBufferWritePair(_buffer, "preload", bool(__preload));
        __AbBufferWritePair(_buffer, "resourceType", "GMSound");
        __AbBufferWritePair(_buffer, "resourceVersion", "2.0"); //Needs to be a string
        __AbBufferWritePair(_buffer, "sampleRate", __sampleRate);
        __AbBufferWritePair(_buffer, "soundFile", __soundFilename);
        __AbBufferWritePair(_buffer, "volume", __volume);
        __AbBufferWriteLine(_buffer, "}");
        
        buffer_save_ext(_buffer, _yyPath, 0, buffer_tell(_buffer));
        buffer_delete(_buffer);
        
        return self;
    }
}