function __BucketClassConfigSprites() : __BucketClassConfigAsset() constructor
{
    static __ExecuteImport = function(_injestStruct, _fileArray)
    {
        var _bucketDict = _injestStruct.__bucketDict;
        
        with(__import)
        {
            var _i = 0;
            repeat(array_length(_fileArray))
            {
                var _sourcePath = _fileArray[_i];
                
                _injestStruct.__RegisterProjectSprite(_sourcePath);
                
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