__BucketSystem();

function __BucketSystem()
{
    static _system = (function()
    {
        with({})
        {
            __BucketTrace($"Welcome to Asset Bucket by Juju Adams! This is version {BUCKET_VERSION}, {BUCKET_DATE}");
            
            if (debug_mode)
            {
                global.__Bucket = self;
            }
            
            __manifest = {
                buckets:      [],
                bucketLookup: {},
                datafiles:    [],
                sprites:      [],
                sounds:       [],
            };
            
            __config = undefined;
            
            __fileInfoDict = {};
            
            __runtimeAllAssetsArray = [];
            __runtimeBucketArray    = [];
            __runtimeBucketMap      = ds_map_create();
            
            return self;
        }
    })();
    
    return _system;
}