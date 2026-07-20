function __BucketClassConfigSounds() : __BucketClassConfigAsset() constructor
{
    static __ExecuteImport = function(_injestStruct, _fileArray)
    {
        var _rootDirectory = $"{BUCKET_PROJECT_DIRECTORY}{_injestStruct.__configStruct.__rootDirectory}";
        var _projectName = filename_change_ext(filename_name(GM_project_filename), "");
        var _projectDirectory = BUCKET_PROJECT_DIRECTORY;
        
        with(__import)
        {
            var _projectImportFolder = __projectImportFolder;
            var _audioGroupName = __audioGroup;
            
            var _i = 0;
            repeat(array_length(_fileArray))
            {
                var _sourcePath = _fileArray[_i];
                
                var _fileExtension = filename_ext(_sourcePath);
                if ((_fileExtension == ".wav") || (_fileExtension == ".wave") || (_fileExtension == ".ogg"))
                {
                    var _soundName = filename_change_ext(filename_name(_sourcePath), "");
                    
                    _injestStruct.__RegisterProjectSound(_sourcePath, _soundName, _projectImportFolder, _audioGroupName);
                    __BucketCreateYYSound(_rootDirectory + _sourcePath, _soundName,
                                          _projectImportFolder, _audioGroupName,
                                          _projectName, _projectDirectory);
                }
                else
                {
                    __BucketError($"Audio file extension \"{_fileExtension}\" not supported (path was \"{_sourcePath}\")");
                }
                
                ++_i;
            }
        }
    }
}