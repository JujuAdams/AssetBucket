function __BucketClassConfigBucket() constructor
{
    static _system = __BucketSystem();
    
    static __Deserialize = function(_parent, _struct)
    {
        __BucketVariableAssertOnly(_struct, ["name", "textureSize", "textureFormat"]);
        
        __parent = _parent;
        
        __name          = __BucketVariableAssertString(_struct, "name");
        __textureSize   = __BucketVariableDefault(_struct, "textureSize", 2048);
        __textureFormat = __BucketVariableDefault(_struct, "textureFormat", "png");
        
        return self;
    }
    
    static __Build = function()
    {
        var _ingestStruct = _system.__currentIngestStruct;
        
        var _bucketStruct = new __BucketClassIngestBucket(__name, __textureSize, __textureFormat);
        array_push(_ingestStruct.__bucketArray, _bucketStruct);
        _ingestStruct.__bucketDict[$ __name] = _bucketStruct;
    }
}