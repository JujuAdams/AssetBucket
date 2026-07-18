function __BucketClassProcess(_configStruct) constructor
{
    __configStruct = variable_clone(_configStruct);
    
    __fileArray = [];
    __bucketArray = [];
    __bucketDict = {};
    
    __assetToBucketDict = {};
    
    
    
    static __RegisterAsset = function(_originalPath, _bucketNameArray)
    {
        __assetToBucketDict[$ _originalPath] = _bucketNameArray;
    }
    
    static __Process = function()
    {
        //Compile all the buckets
        var _i = 0;
        repeat(array_length(__bucketArray))
        {
            __bucketArray[_i].__Compile(self);
            ++_i;
        }
    }
}