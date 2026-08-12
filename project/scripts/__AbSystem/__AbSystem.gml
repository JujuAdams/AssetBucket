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
            
            __fileInfoDict = {};
            __builderStack = [];
            
            __projectMetadata = undefined;
            
            __projectBucketArray = [];
            __projectBucketMap   = ds_map_create();
            
            __runtimeBucketDatafileMap = ds_map_create();
            __runtimeBucketSoundMap    = ds_map_create();
            
            __spriteFormatDict = {};
            
            __spriteCacheDict       = {};
            __spriteWidthCacheDict  = {};
            __spriteHeightCacheDict = {};
            
            return self;
        }
    })();
    
    return _system;
}