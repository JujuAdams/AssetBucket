/// @param soundName
/// @param soundPath
/// @param projectFolder
/// @param [audioGroup="audiogroup_default"]

function BucketIngestSoundToProject(_soundName, _soundPath, _projectFolder, _audioGroup = "audiogroup_default")
{
    static _system = __BucketSystem();
    
    var _ingestStruct = _system.__currentIngestStruct;
    if (not is_struct(_ingestStruct))
    {
        __BucketError("Cannot call `BucketIngestSpriteToProject()` outside of a worker function");
    }
    
    var _fileExtension = filename_ext(_soundPath);
    if ((_fileExtension == ".wav") || (_fileExtension == ".wave") || (_fileExtension == ".ogg"))
    {
        var _rootDirectory = $"{BUCKET_PROJECT_DIRECTORY}{_ingestStruct.__configStruct.__rootDirectory}";
        
        _ingestStruct.__RegisterProjectSound(_soundPath, _soundName);
        _ingestStruct.__EnsureProjectFolder(_projectFolder);
        _ingestStruct.__EnsureProjectAudioGroup(_audioGroup);
        
        __BucketCreateYYSound(_rootDirectory, _soundPath, _soundName, _projectFolder, _audioGroup);
    }
    else
    {
        __BucketError($"Audio file extension \"{_fileExtension}\" not supported (path was \"{_soundPath}\")");
    }
}