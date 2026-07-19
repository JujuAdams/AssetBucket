function __BucketClassConfigBucket() constructor
{
    static __Deserialize = function(_parent, _struct)
    {
        __BucketVariableAssertOnly(_struct, ["name"]);
        
        __parent = _parent;
        
        __name = __BucketVariableAssertString(_struct, "name");
        
        return self;
    }
    
    static __Collect = function(_injestStruct)
    {
        var _bucketStruct = new __BucketClassInjestBucket(__name);
        array_push(_injestStruct.__bucketArray, _bucketStruct);
        _injestStruct.__bucketDict[$ __name] = _bucketStruct;
    }
}