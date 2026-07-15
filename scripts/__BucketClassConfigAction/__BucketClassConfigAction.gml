function __BucketClassConfigAction() constructor
{
    static __Deserialize = function(_parent, _struct)
    {
        __parent = _parent;
        
        __BucketVariableAssertMutuallyExclusive(_struct, "addToBlob", "importToFolder");
        
        __addToBlob = undefined;
        __importToFolder = undefined;
        
        if (is_instanceof(_parent, __BucketClassConfigDatafiles))
        {
            __parentConstructor = __BucketClassConfigDatafiles;
        }
        else if (is_instanceof(_parent, __BucketClassConfigSprites))
        {
            __parentConstructor = __BucketClassConfigSprites;
        }
        else if (is_instanceof(_parent, __BucketClassConfigSounds))
        {
            __parentConstructor = __BucketClassConfigSounds;
        }
        
        if (struct_exists(_struct, "addToBlob"))
        {
            __addToBlob = __BucketVariableAssertStringOrArray(_struct, "addToBlob");
        }
        else if (struct_exists(_struct, "importToFolder"))
        {
            __importToFolder = __BucketVariableAssertString(_struct, "importToFolder");
        }
        
        if (is_instanceof(_parent, __BucketClassConfigSounds))
        {
            __BucketVariableAssertOnly(_struct, ["addToBlob", "importToFolder", "compression"]);
            __BucketVariableDefaultUndefined(_struct, "compression");
        }
        else
        {
            __BucketVariableAssertOnly(_struct, ["addToBlob", "importToFolder"]);
        }
        
        return self;
    }
    
    static __Collect = function(_processStruct, _filePath)
    {
        if (__addToBlob != undefined)
        {
            array_push(_processStruct.__actionToBlobArray, new __BucketClassProcessActionBlob(_filePath, __addToBlob));
        }
        
        if (__importToFolder != undefined)
        {
            array_push(_processStruct.__actionToProjectArray, new __BucketClassProcessActionProject(_filePath, __importToFolder, __importToFolder));
        }
    }
}