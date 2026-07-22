/// @param soundName
/// @param soundPath
/// @param projectFolder
/// @param [audioGroup="audiogroup_default"]
/// @param [metadata]

function BucketIngestProjectSound(_soundName, _soundPath, _projectFolder, _audioGroup = "audiogroup_default", _metadata = undefined)
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestProjectSprite()` outside of a worker function");
    }
    
    _ingestStruct.__QueueProjectOperation(_soundName, new __BucketClassDeferredFunction(function(_ingestStruct)
    {
        static _system = __BucketSystem();
        
        var _fileExtension = filename_ext(__soundPath);
        if ((_fileExtension == ".wav") || (_fileExtension == ".wave") || (_fileExtension == ".ogg"))
        {
            var _rootDirectory = $"{_system.__currentYYPDirectory}{_ingestStruct.__configStruct.__rootDirectory}";
            
            _ingestStruct.__EnsureProjectSound(__soundName);
            _ingestStruct.__EnsureProjectFolder(__projectFolder);
            _ingestStruct.__EnsureProjectAudioGroup(__audioGroup);
            _ingestStruct.__SetAssetMetadata(__soundName, __metadata);
            
            __BucketYYWriteSoundFile(_rootDirectory, __soundPath, __soundName, __projectFolder, __audioGroup);
        }
        else
        {
            __BucketError($"Audio file extension \"{_fileExtension}\" not supported (path was \"{_soundPath}\")");
        }
    },
    {
        __soundName:     _soundName,
        __soundPath:     _soundPath,
        __projectFolder: _projectFolder,
        __audioGroup:    _audioGroup,
        __metadata:      _metadata,
    }));
}