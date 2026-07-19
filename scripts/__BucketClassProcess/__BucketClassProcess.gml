function __BucketClassProcess(_configStruct) constructor
{
    __configStruct = variable_clone(_configStruct);
    
    __workingFileArray = [];
    __bucketArray = [];
    __bucketDict = {};
    
    __assetToBucketDict    = {};
    __projectDatafileArray = [];
    __projectSpriteArray   = [];
    __projectSoundArray    = [];
    
    
    
    static __RegisterBucketDatafile = function(_originalPath, _bucketNameArray)
    {
        array_push(__projectDatafileArray, _originalPath);
        __assetToBucketDict[$ _originalPath] = _bucketNameArray;
    }
    
    static __RegisterProjectDatafile = function(_originalPath)
    {
        array_push(__projectDatafileArray, _originalPath);
    }
    
    static __RegisterProjectSprite = function(_originalPath)
    {
        array_push(__projectSpriteArray, _originalPath);
    }
    
    static __RegisterProjectSound = function(_originalPath)
    {
        array_push(__projectSoundArray, _originalPath);
    }
    
    static __Process = function()
    {
        var _i = 0;
        repeat(array_length(__bucketArray))
        {
            __bucketArray[_i].__Save();
            ++_i;
        }
        
        var _json = json_stringify({
            buckets:      struct_get_names(__bucketDict),
            bucketLookup: __assetToBucketDict,
            datafiles:    __projectDatafileArray,
            sprites:      __projectSpriteArray,
            sounds:       __projectSoundArray,
        });
        
        var _buffer = buffer_create(string_byte_length(_json), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _json);
        buffer_save(_buffer, $"{BUCKET_PROJECT_DIRECTORY}datafiles/{BUCKET_MANIFEST_FILENAME}");
        buffer_delete(_buffer);
    }
}