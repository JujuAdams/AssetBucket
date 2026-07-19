function __BucketClassConfigImport() constructor
{
    static __Deserialize = function(_parent, _struct)
    {
        __parent = _parent;
        
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
        
        if (struct_exists(_struct, "folder"))
        {
            __projectImportFolder = __BucketEnsureDirectory(__BucketVariableAssertString(_struct, "folder"));
        }
        else if (struct_exists(_struct, "bucket"))
        {
            __importBucket = __BucketVariableAssertString(_struct, "bucket");
        }
        
        if (is_instanceof(_parent, __BucketClassConfigDatafiles))
        {
            __BucketVariableAssertOnly(_struct, ["bucket", "folder", "folderOrigin"]);
            __BucketVariableAssertMutuallyExclusive(_struct, "folder", "bucket");
        }
        else if (is_instanceof(_parent, __BucketClassConfigSounds))
        {
            __BucketVariableAssertOnly(_struct, ["folder", "compression", "audioGroup", "folderOrigin"]);
            __BucketVariableDefaultUndefined(_struct, "compression");
            __BucketVariableDefaultUndefined(_struct, "audioGroup");
        }
        else if (is_instanceof(_parent, __BucketClassConfigSprites))
        {
            __BucketVariableAssertOnly(_struct, ["folder", "textureGroup", "folderOrigin"]);
            __BucketVariableDefaultUndefined(_struct, "textureGroup");
        }
        
        __folderOrigin = __BucketVariableDefaultUndefined(_struct, "folderOrigin");
        
        if (is_string(__folderOrigin))
        {
            __folderOrigin = __BucketEnsureDirectory(__folderOrigin);
        }
        
        return self;
    }
}