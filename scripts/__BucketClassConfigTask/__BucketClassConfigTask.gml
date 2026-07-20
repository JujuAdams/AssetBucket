function __BucketClassConfigTask() constructor
{
    static _system = __BucketSystem();
    
    static __Deserialize = function(_parent, _struct)
    {
        __BucketVariableAssertOnly(_struct, ["include", "exclude", "worker"]);
        
        __parent = _parent;
        
        __worker  = __BucketDeserializeStruct(self, _struct[$ "worker" ], __BucketClassConfigWorker);
        __include = __BucketDeserializeStruct(self, _struct[$ "include"], __BucketClassConfigFilter);
        __exclude = __BucketDeserializeStruct(self, _struct[$ "exclude"], __BucketClassConfigFilter);
        
        if ((__include == undefined) && (__exclude == undefined))
        {
            __BucketError("Must have either an `.include` or `.exclude` struct");
        }
        
        if (__worker == undefined)
        {
            __BucketError("Must have an `.worker` struct");
        }
        
        return self;
    }
    
    static __Execute = function(_globalFileArray)
    {
        var _fileArray = variable_clone(_globalFileArray);
        
        var _includeStruct = __include;
        if (is_struct(_includeStruct))
        {
            var _i = array_length(_fileArray)-1;
            repeat(array_length(_fileArray))
            {
                if (not _includeStruct.__TestFilter(_fileArray[_i]))
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
                if (_excludeStruct.__TestFilter(_fileArray[_i]))
                {
                    array_delete(_fileArray, _i, 1);
                }
                
                --_i;
            }
        }
        
        __worker.__Execute(_fileArray);
    }
}