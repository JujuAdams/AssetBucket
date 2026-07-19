function __BucketClassConfigSounds() : __BucketClassConfigAsset() constructor
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
                
                var _fileExtension = filename_ext(_sourcePath);
                if ((_fileExtension == "wav") || (_fileExtension == "ogg"))
                {
                    _injestStruct.__RegisterProjectSound(_sourcePath);
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