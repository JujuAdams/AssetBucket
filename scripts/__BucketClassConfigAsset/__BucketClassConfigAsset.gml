function __BucketClassConfigAsset() constructor
{
    static __Deserialize = function(_parent, _struct)
    {
        __BucketVariableAssertOnly(_struct, ["include", "exclude", "action"]);
        
        __parent = _parent;
        
        __include = __BucketDeserializeStruct(self, _struct[$ "include"], __BucketClassConfigFilter);
        __exclude = __BucketDeserializeStruct(self, _struct[$ "exclude"], __BucketClassConfigFilter);
        __action  = __BucketDeserializeStruct(self, _struct[$ "action" ], __BucketClassConfigAction);
        
        if ((__include == undefined) && (__exclude == undefined))
        {
            __BucketError("Must have either an `.include` or `.exclude` struct");
        }
        
        if (__action == undefined)
        {
            __BucketError("Must have an `.action` struct");
        }
        
        return self;
    }
    
    static __Collect = function(_processStruct)
    {
        var _fileArray = variable_clone(_processStruct.__fileArray);
        
        var _includeStruct = __include;
        if (is_struct(_includeStruct))
        {
            var _i = array_length(_fileArray)-1;
            repeat(array_length(_fileArray))
            {
                if (not _includeStruct.__TestFilter(_processStruct, _fileArray[_i]))
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
                if (_excludeStruct.__TestFilter(_processStruct, _fileArray[_i]))
                {
                    array_delete(_fileArray, _i, 1);
                }
                
                --_i;
            }
        }
        
        var _actionStruct = __action;
        var _i = 0;
        repeat(array_length(_fileArray))
        {
            _actionStruct.__Collect(_processStruct, _fileArray[_i]);
            ++_i;
        }
    }
}