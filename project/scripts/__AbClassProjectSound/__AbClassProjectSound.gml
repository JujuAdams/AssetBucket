function __AbClassProjectSound() constructor
{
    static __Template = function(_sourcePath, _projectStruct, _assetName, _projectFolder = "", _compression = undefined, _audioGroupName = "audiogroup_default")
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
        
        __assetName          = _assetName;
        __audioGroupName     = _audioGroupName;
        __bitDepth           = 1;
        __channelFormat      = 1;
        __compression        = _compression;
        __compressionQuality = 4;
        __conversionMode     = 0;
        __duration           = 0;
        __exportDir          = "";
        __folderInfo         = __AbMakeProjectFolderInfo(_projectFolder, _projectStruct);
        __preload            = false;
        __sampleRate         = 44100;
        __soundFilename      = filename_name(_sourcePath);
        __volume             = 1;
        
        return self;
    }
    
    static __Deserialize = function(_path)
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
        __folderInfo         = { __name: _yypData.parent.name, __path: _yypData.parent.path };
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
    
    static __Overwrite = function(_sourcePath, _projectStruct, _projectFolder = undefined, _compression = undefined, _audioGroupName = undefined)
    {
        __sourceFilePath = _sourcePath;
        
        if (_projectFolder != undefined)
        {
            __AbMakeProjectFolderInfo(_projectFolder, _projectStruct, __folderInfo);
        }
        
        if (_compression != undefined)
        {
            __compression = _compression;
        }
        
        if (_audioGroupName != undefined)
        {
            __audioGroupName = _audioGroupName;
        }
        
        return self;
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
        __AbBufferWritePair(_buffer, 2, "$GMSound", "v2");
        __AbBufferWritePair(_buffer, 2, "%Name", __assetName);
        __AbBufferWriteLine(_buffer, "  \"audioGroupId\":{");
        __AbBufferWriteLine(_buffer, $"    \"name\":\"{__audioGroupName}\",");
        __AbBufferWriteLine(_buffer, $"    \"path\":\"audiogroups/{__audioGroupName}\",");
        __AbBufferWriteLine(_buffer, "  },");
        __AbBufferWritePair(_buffer, 2, "bitDepth", __bitDepth);
        __AbBufferWritePair(_buffer, 2, "channelFormat", __channelFormat);
        __AbBufferWritePair(_buffer, 2, "compression", __compression);
        __AbBufferWritePair(_buffer, 2, "compressionQuality", __compressionQuality);
        __AbBufferWritePair(_buffer, 2, "conversionMode", __conversionMode);
        __AbBufferWritePair(_buffer, 2, "duration", __duration);
        __AbBufferWritePair(_buffer, 2, "exportDir", __exportDir);
        __AbBufferWritePair(_buffer, 2, "name", __assetName);
        __AbBufferWriteLine(_buffer, "  \"parent\":{");
        __AbBufferWriteLine(_buffer, $"    \"name\":\"{__folderInfo.__name}\",");
        __AbBufferWriteLine(_buffer, $"    \"path\":\"{__folderInfo.__path}\",");
        __AbBufferWriteLine(_buffer, "  },");
        __AbBufferWritePair(_buffer, 2, "preload", bool(__preload));
        __AbBufferWritePair(_buffer, 2, "resourceType", "GMSound");
        __AbBufferWritePair(_buffer, 2, "resourceVersion", "2.0"); //Needs to be a string
        __AbBufferWritePair(_buffer, 2, "sampleRate", __sampleRate);
        __AbBufferWritePair(_buffer, 2, "soundFile", __soundFilename);
        __AbBufferWritePair(_buffer, 2, "volume", __volume);
        __AbBufferWriteLine(_buffer, "}");
        
        buffer_save_ext(_buffer, _yyPath, 0, buffer_tell(_buffer));
        buffer_delete(_buffer);
        
        return self;
    }
}