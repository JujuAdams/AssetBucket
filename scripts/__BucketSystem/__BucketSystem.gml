function __BucketSystem()
{
    static _system = (function()
    {
        with({})
        {
            __config = undefined;
            
            __fileInfoDict = {};
            
            __bucketMap = ds_map_create();
            
            return self;
        }
    })();
    
    return _system;
}