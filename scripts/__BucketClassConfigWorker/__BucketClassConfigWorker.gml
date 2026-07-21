function __BucketClassConfigWorker() constructor
{
    static _system = __BucketSystem();
    static _workerFunctionDict = _system.__workerFunctionDict;
    
    static __Deserialize = function(_parent, _struct)
    {
        __parent = _parent;
        
        __name         = __BucketVariableAssertString(_struct, "name");
        __resourceType = __BucketVariableAssertString(_struct, "resourceType");
        
        __data = _struct;
        
        return self;
    }
    
    static __Execute = function(_fileArray)
    {
        var _data = __data;
        
        var _workerCallback =_workerFunctionDict[$ _data.name];
        if (not is_method(_workerCallback))
        {
            __BucketError($"No worker function found with name \"{_data}\"");
            return;
        }
        
        var _i = 0;
        repeat(array_length(_fileArray))
        {
            _workerCallback(_fileArray[_i], _data);
            ++_i;
        }
    }
}