function __BucketClassConfigBucket() constructor
{
    static _system = __BucketSystem();
    
    static __Deserialize = function(_parent, _struct)
    {
        __BucketVariableAssertOnly(_struct, ["name"]);
        
        __parent = _parent;
        
        __name = __BucketVariableAssertString(_struct, "name");
        
        return self;
    }
    
    static __Build = function()
    {
        var _ingestStruct = _system.__currentIngestStruct;
        
        var _bucketStruct = new __BucketClassIngestBucket(__name);
        array_push(_ingestStruct.__bucketArray, _bucketStruct);
        _ingestStruct.__bucketDict[$ __name] = _bucketStruct;
    }
}