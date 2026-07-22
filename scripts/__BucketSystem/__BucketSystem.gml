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
            
            __config = undefined;
            
            __fileInfoDict = {};
            __workerFunctionDict = {};
            __currentIngestStruct = undefined;
            
            __runtimeBucketArray = [];
            __runtimeBucketMap   = ds_map_create();
            
            __runtimeBucketDatafileMap = ds_map_create();
            __runtimeBucketSoundMap    = ds_map_create();
            
            __metadataBucketDatafileDict  = {};
            __metadataProjectDatafileDict = {};
            __metadataAssetDict           = {};
            
            return self;
        }
    })();
    
    return _system;
}