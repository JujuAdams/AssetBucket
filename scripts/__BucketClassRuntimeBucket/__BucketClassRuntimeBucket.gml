#macro BUCKET_LOAD_PREVENT  0
#macro BUCKET_LOAD_INSTANT  1
#macro BUCKET_LOAD_ASYNC    2

#macro BUCKET_STATE_UNLOADED  0
#macro BUCKET_STATE_LOADING   1
#macro BUCKET_STATE_LOADED    2

function __BucketClassRuntimeBucket(_guid) constructor
{
    static _system = __BucketSystem();
    
    __guid = _guid;
    
    __state = BUCKET_STATE_UNLOADED;
    __loadPhase = 0;
    __timeSource = undefined;
    
    __loadBlobIndex = 0;
    __loadTextureGroupIndex = 0;
    __loadWAVIndex = 0;
    __loadOGGIndex = 0;
    
    __blobCount = 0;
    __blobArray = [];
    
    __textureGroupCount = 0;
    __textureGroupMetadataArray = [];
    
    __wavCount = 0;
    __wavArray = [];
    __wavMetadataArray = [];
    
    __oggCount = 0;
    __oggArray = [];
    __oggMetadataArray = [];
    
    
    
    
    static __SetDescriptor = function(_bucketDescriptor)
    {
        __Destroy();
        
        __blobArray                 = variable_clone(_bucketDescriptor.__blobArray);
        __textureGroupMetadataArray = variable_clone(_bucketDescriptor.__textureGroupArray);
        __wavMetadataArray          = variable_clone(_bucketDescriptor.__wavArray);
        __oggMetadataArray          = variable_clone(_bucketDescriptor.__oggArray);
        
        __blobCount         = array_length(__blobArray);
        __textureGroupCount = array_length(__textureGroupMetadataArray);
        __wavCount          = array_length(__wavMetadataArray);
        __oggCount          = array_length(__oggMetadataArray);
    }
    
    static __Load = function()
    {
        if (__state != BUCKET_STATE_UNLOADED) return;
        __state = BUCKET_STATE_LOADING;
        
        __timeSource = time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            var _loadPhase = __loadPhase;
            if (_loadPhase == 0)
            {
                //Load blobs
                
                var _buffer = __blobArray[__loadBlobIndex].__GetBuffer(BUCKET_LOAD_ASYNC);
                if (_buffer != undefined)
                {
                    if ((++__loadBlobIndex) >= __blobCount)
                    {
                        ++__loadPhase;
                    }
                }
            }
            else if (_loadPhase == 1)
            {
                //Load texture groups
                
                with(__textureGroupMetadataArray[__loadTextureGroupIndex])
                {
                    var _bufferArray = array_create(array_length(__blobIndexArray), undefined);
                    var _i = 0;
                    repeat(array_length(__blobIndexArray))
                    {
                        _bufferArray[@ _i] = other.__blobArray[__blobIndexArray[_i]];
                        ++_i;
                    }
                    
                    texturegroup_add(__groupName, _bufferArray, __assetDescStruct);
                }
                
                if ((++__loadTextureGroupIndex) >= __textureGroupCount)
                {
                    ++__loadPhase;
                }
            }
            else if (_loadPhase == 2)
            {
                //Load WAVs
                
                with(__wavMetadataArray[__loadWAVIndex])
                {
                    var _sound = audio_create_buffer_sound(other.__blobArray[__blobIndex], __format, __rate, __offset, __bytes, __channels);
                }
                
                __wavArray[@ __loadWAVIndex] = _sound;
                
                if ((++__loadWAVIndex) >= __wavCount)
                {
                    ++__loadPhase;
                }
            }
            else if (_loadPhase == 4)
            {
                //Load OGGs
                
                __oggMetadataArray[__loadOGGIndex] = audio_create_stream(__oggMetadataArray[__loadOGGIndex].__path);
                
                if ((++__loadOGGIndex) >= __oggCount)
                {
                    __state = BUCKET_STATE_LOADED;
                    time_source_destroy(__timeSource);
                    __timeSource = undefined;
                }
            }
        },
        [], -1);
        
        time_source_start(__timeSource);
    }
    
    static __Unload = function()
    {
        if (__timeSource != undefined)
        {
            time_source_destroy(__timeSource);
            __timeSource = undefined;
        }
        
        var _i = 0;
        repeat(__blobCount)
        {
            __blobArray[_i].__Unload();
            ++_i;
        }
        
        var _i = 0;
        repeat(__textureGroupCount)
        {
            texturegroup_delete(__textureGroupMetadataArray[_i]);
            ++_i;
        }
        
        var _i = 0;
        repeat(__wavCount)
        {
            audio_free_buffer_sound(__wavArray[_i]);
            ++_i;
        }
        
        var _i = 0;
        repeat(__oggCount)
        {
            audio_destroy_stream(__oggArray[_i]);
            ++_i;
        }
        
        array_resize(__wavArray, 0);
        array_resize(__oggArray, 0);
        
        __state = BUCKET_STATE_UNLOADED;
    }
    
    static __Destroy = function()
    {
        var _i = 0;
        repeat(__blobCount)
        {
            __blobArray[_i].__Destroy();
            ++_i;
        }
        
        __Unload();
    }
}