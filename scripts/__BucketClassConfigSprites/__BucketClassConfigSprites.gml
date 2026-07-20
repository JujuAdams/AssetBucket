function __BucketClassConfigSprites() : __BucketClassConfigAsset() constructor
{
    static __ExecuteImport = function(_injestStruct, _fileArray)
    {
        var _rootDirectory = $"{BUCKET_PROJECT_DIRECTORY}{_injestStruct.__configStruct.__rootDirectory}";
        var _projectName = filename_change_ext(filename_name(GM_project_filename), "");
        var _projectDirectory = BUCKET_PROJECT_DIRECTORY;
        
        with(__import)
        {
            var _projectImportFolder = __projectImportFolder;
            var _textureGroupName = __textureGroup;
            
            var _i = 0;
            repeat(array_length(_fileArray))
            {
                var _sourcePath = _fileArray[_i];
                
                var _spriteName = filename_change_ext(filename_name(_sourcePath), "");
                
                _injestStruct.__RegisterProjectSprite(_sourcePath, _spriteName, _projectImportFolder, _textureGroupName);
                
                var _fileInfo = __BucketEnsureInjestFileInfo(_injestStruct, _sourcePath);
                __BucketCreateYYSprite([_rootDirectory + _sourcePath],
                                       _spriteName, _fileInfo.__GetWidth(), _fileInfo.__GetHeight(),
                                       _projectImportFolder, _textureGroupName,
                                       _projectName, _projectDirectory);
                
                //if (is_string(_folderOrigin))
                //{
                //    var _length = string_length(_folderOrigin);
                //    if (string_copy(_sourcePath, 1, _length) == _folderOrigin)
                //    {
                //        _destDirectory += string_delete(filename_dir(_sourcePath), 1, _length) + "/" + _destFilename;
                //    }
                //    else
                //    {
                //        __BucketWarning($"Could not find folder origin \"{_folderOrigin}\" in source file path \"{_sourcePath}\"");
                //        _destDirectory += _destFilename;
                //    }
                //}
                //else
                //{
                //    _destDirectory += _destFilename;
                //}
                
                ++_i;
            }
        }
    }
}