#macro __AB_PATH_WILDCARD  ((os_type == os_windows)? "*.*" : "*")



__AbSystem();

function __AbSystem()
{
    static _system = (function()
    {
        with({})
        {
            __AbTrace($"Welcome to Asset Bucket by Juju Adams! This is version {AB_VERSION}, {AB_DATE}");
            
            if (debug_mode)
            {
                global.__Bucket = self;
            }
            
            __manifestLoaded = false;
            
            __fileInfoDict = {};
            
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