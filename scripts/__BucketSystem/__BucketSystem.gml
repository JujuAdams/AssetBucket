function __BucketSystem()
{
    static _system = (function()
    {
        with({})
        {
            __config = undefined;
            
            __fileInfoDict = {};
            
            return self;
        }
    })();
    
    return _system;
}