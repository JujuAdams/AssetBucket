function __BucketClassConfigBucket() constructor
{
    static __Deserialize = function(_parent, _struct)
    {
        __BucketVariableAssertOnly(_struct, ["name"]);
        
        __parent = _parent;
        
        __name = __BucketVariableAssertString(_struct, "name");
        
        return self;
    }
    
    static __Collect = function(_processStruct)
    {
        var _bucketStruct = new __BucketClassProcessBucket(__name);
        array_push(_processStruct.__bucketArray, _bucketStruct);
        _processStruct.__bucketDict[$ __name] = _bucketStruct;
    }
}