function __BucketClassConfigAction() constructor
{
    static __Deserialize = function(_parent, _struct)
    {
        __parent = _parent;
        
        __BucketVariableAssertMutuallyExclusive(_struct, "addToBucket", "importToFolder");
        
        __addToBucket = undefined;
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
        
        if (struct_exists(_struct, "addToBucket"))
        {
            __addToBucket = __BucketVariableAssertStringOrArray(_struct, "addToBucket");
        }
        else if (struct_exists(_struct, "importToFolder"))
        {
            __importToFolder = __BucketEnsureDirectory(__BucketVariableAssertString(_struct, "importToFolder"));
        }
        
        if (is_instanceof(_parent, __BucketClassConfigSounds))
        {
            __BucketVariableAssertOnly(_struct, ["addToBucket", "importToFolder", "compression", "folderOrigin"]);
            __BucketVariableDefaultUndefined(_struct, "compression");
        }
        else
        {
            __BucketVariableAssertOnly(_struct, ["addToBucket", "importToFolder", "folderOrigin"]);
        }
        
        __folderOrigin = __BucketVariableDefaultUndefined(_struct, "folderOrigin");
        
        if (is_string(__folderOrigin))
        {
            __folderOrigin = __BucketEnsureDirectory(__folderOrigin);
        }
        
        return self;
    }
    
    static __Collect = function(_processStruct, _sourcePath)
    {
        if (__addToBucket != undefined)
        {
            var _processAction = new __BucketClassProcessAction(_sourcePath, undefined, __addToBucket);
            array_push(_processStruct.__actionToBucketArray, _processAction);
        }
        
        if (__importToFolder != undefined)
        {
            var _assetName = filename_change_ext(filename_name(_sourcePath), "");
            
            if (is_string(__folderOrigin))
            {
                var _length = string_length(__folderOrigin);
                if (string_copy(_sourcePath, 1, _length) == __folderOrigin)
                {
                    var _destinationPath = __importToFolder + string_delete(filename_dir(_sourcePath), 1, _length) + "/" + _assetName;
                }
                else
                {
                    __BucketWarning($"Could not find folder origin \"{__folderOrigin}\" in source file path \"{_sourcePath}\"");
                    var _destinationPath = __importToFolder + _assetName;
                }
            }
            else
            {
                var _destinationPath = __importToFolder + _assetName;
            }
            
            var _processAction = new __BucketClassProcessAction(_sourcePath, _destinationPath, __addToBucket);
            array_push(_processStruct.__actionToProjectArray, _processAction);
        }
    }
}