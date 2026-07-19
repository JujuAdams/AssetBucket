function __BucketClassConfigAsset() constructor
{
    static __Deserialize = function(_parent, _struct)
    {
        __BucketVariableAssertOnly(_struct, ["include", "exclude", "import"]);
        
        __parent = _parent;
        
        __include = __BucketDeserializeStruct(self, _struct[$ "include"], __BucketClassConfigFilter);
        __exclude = __BucketDeserializeStruct(self, _struct[$ "exclude"], __BucketClassConfigFilter);
        __import  = __BucketDeserializeStruct(self, _struct[$ "import" ], __BucketClassConfigImport);
        
        if ((__include == undefined) && (__exclude == undefined))
        {
            __BucketError("Must have either an `.include` or `.exclude` struct");
        }
        
        if (__import == undefined)
        {
            __BucketError("Must have an `.import` struct");
        }
        
        return self;
    }
    
    static __Collect = function(_injestStruct)
    {
        var _fileArray = variable_clone(_injestStruct.__workingFileArray);
        
        var _includeStruct = __include;
        if (is_struct(_includeStruct))
        {
            var _i = array_length(_fileArray)-1;
            repeat(array_length(_fileArray))
            {
                if (not _includeStruct.__TestFilter(_injestStruct, _fileArray[_i]))
                {
                    array_delete(_fileArray, _i, 1);
                }
                
                --_i;
            }
        }
        
        var _excludeStruct = __exclude;
        if (is_struct(_excludeStruct))
        {
            var _i = array_length(_fileArray)-1;
            repeat(array_length(_fileArray))
            {
                if (_excludeStruct.__TestFilter(_injestStruct, _fileArray[_i]))
                {
                    array_delete(_fileArray, _i, 1);
                }
                
                --_i;
            }
        }
        
        __ExecuteImport(_injestStruct, _fileArray);
    }
}