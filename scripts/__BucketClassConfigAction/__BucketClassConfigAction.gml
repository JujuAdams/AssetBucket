function __BucketClassConfigAction() constructor
{
    static __Deserialize = function(_parent, _struct)
    {
        __parent = _parent;
        
        __BucketVariableAssertMutuallyExclusive(_struct, "importBucket", "projectImportFolder");
        
        __importBucket = undefined;
        __projectImportFolder = undefined;
        
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
        
        if (struct_exists(_struct, "importBucket"))
        {
            __importBucket = __BucketVariableAssertStringOrArray(_struct, "importBucket");
        }
        else if (struct_exists(_struct, "projectImportFolder"))
        {
            __projectImportFolder = __BucketEnsureDirectory(__BucketVariableAssertString(_struct, "projectImportFolder"));
        }
        
        if (is_instanceof(_parent, __BucketClassConfigSounds))
        {
            __BucketVariableAssertOnly(_struct, ["importBucket", "projectImportFolder", "compression", "folderOrigin"]);
            __BucketVariableDefaultUndefined(_struct, "compression");
        }
        else
        {
            __BucketVariableAssertOnly(_struct, ["importBucket", "projectImportFolder", "folderOrigin"]);
        }
        
        __folderOrigin = __BucketVariableDefaultUndefined(_struct, "folderOrigin");
        
        if (is_string(__folderOrigin))
        {
            __folderOrigin = __BucketEnsureDirectory(__folderOrigin);
        }
        
        return self;
    }
}