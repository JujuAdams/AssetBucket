function __BucketClassConfigBlob() constructor
{
    static __Deserialize = function(_parent, _struct)
    {
        __BucketVariableAssertOnly(_struct, ["name", "macroScript"]);
        
        __parent = _parent;
        
        __name        = __BucketVariableAssertString(_struct, "name");
        __macroScript = __BucketVariableAssertString(_struct, "macroScript");
        
        return self;
    }
    
    static __Collect = function(_processStruct)
    {
        array_push(_processStruct.__blobArray, new __BucketClassProcessBlob(__name, __macroScript));
    }
}