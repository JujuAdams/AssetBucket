function __AbClassProjectSpriteSequence() constructor
{
    static __Template = function(_assetName)
    {
        autoRecord           = true;
        backdropHeight       = 768;
        backdropImageOpacity = 0.5;
        backdropImagePath    = "";
        backdropWidth        = 1366;
        backdropXOffset      = 0;
        backdropYOffset      = 0;
        eventStubScript      = undefined;
        eventToFunction      = {};
        length               = 1.0;
        lockOrigin           = false;
        name                 = _assetName;
        playback             = 1;
        playbackSpeed        = 30;
        playbackSpeedType    = 0;
        showBackdrop         = true;
        showBackdropImage    = false;
        timeUnits            = 1;
        visibleRange         = undefined;
        volume               = 1;
        xorigin              = 0;
        yorigin              = 0;
        seqFrameUUIDArray    = [];
        
        return self;
    }
    
    static __Deserialize = function(_yyData)
    {
        autoRecord           = _yyData.autoRecord;
        backdropHeight       = _yyData.backdropHeight;
        backdropImageOpacity = _yyData.backdropImageOpacity;
        backdropImagePath    = _yyData.backdropImagePath;
        backdropWidth        = _yyData.backdropWidth;
        backdropXOffset      = _yyData.backdropXOffset;
        backdropYOffset      = _yyData.backdropYOffset;
        eventStubScript      = _yyData.eventStubScript;
        eventToFunction      = _yyData.eventToFunction;
        length               = _yyData.length;
        lockOrigin           = _yyData.lockOrigin;
        name                 = _yyData.name;
        playback             = _yyData.playback;
        playbackSpeed        = _yyData.playbackSpeed;
        playbackSpeedType    = _yyData.playbackSpeedType;
        showBackdrop         = _yyData.showBackdrop;
        showBackdropImage    = _yyData.showBackdropImage;
        timeUnits            = _yyData.timeUnits;
        visibleRange         = _yyData.visibleRange;
        volume               = _yyData.volume;
        xorigin              = _yyData.xorigin;
        yorigin              = _yyData.yorigin;
        
        if (array_length(_yyData.events.Keyframes) > 0)
        {
            __AbError($"Sprite sequence event keyframes not supported");
        }
        
        if (array_length(_yyData.moments.Keyframes) > 0)
        {
            __AbError($"Sprite sequence moment keyframes not supported");
        }
        
        if (array_length(_yyData.tracks) > 1)
        {
            __AbError($"More than one sequence track not supported");
        }
        
        var _yyKeyframeArray = _yyData.tracks[0].keyframes.Keyframes;
        var _frameCount = array_length(_yyKeyframeArray);
        seqFrameUUIDArray = array_create(_frameCount);
        
        var _i = 0;
        repeat(_frameCount)
        {
            seqFrameUUIDArray[@ _i] = _yyKeyframeArray[_i].id;
            ++_i;
        }
        
        return self;
    }
    
    static __Save = function(_buffer, _assetName, _framesArray)
    {
        __AbBufferWriteLine(_buffer, "  \"sequence\":{");
        __AbBufferWritePair(_buffer, 4, "$GMSequence", "v1");
        __AbBufferWritePair(_buffer, 4, "%Name", name);
        __AbBufferWritePair(_buffer, 4, "autoRecord", bool(autoRecord));
        __AbBufferWritePair(_buffer, 4, "backdropHeight", backdropHeight);
        __AbBufferWriteDecimal(_buffer, 4, "backdropImageOpacity", backdropImageOpacity);
        __AbBufferWritePair(_buffer, 4, "backdropImagePath", backdropImagePath);
        __AbBufferWritePair(_buffer, 4, "backdropWidth", backdropWidth);
        __AbBufferWriteDecimal(_buffer, 4, "backdropXOffset", backdropXOffset);
        __AbBufferWriteDecimal(_buffer, 4, "backdropYOffset", backdropYOffset);
        
        __AbBufferWriteLine(_buffer, "    \"events\":{");
        __AbBufferWriteLine(_buffer, "      \"$KeyframeStore<MessageEventKeyframe>\":\"\",");
        __AbBufferWriteLine(_buffer, "      \"Keyframes\":[],");
        __AbBufferWriteLine(_buffer, "      \"resourceType\":\"KeyframeStore<MessageEventKeyframe>\",");
        __AbBufferWriteLine(_buffer, "      \"resourceVersion\":\"2.0\",");
        __AbBufferWriteLine(_buffer, "    },");
        
        __AbBufferWritePair(_buffer, 4, "eventStubScript", eventStubScript);
        __AbBufferWriteLine(_buffer, "    \"eventToFunction\":{},");
        __AbBufferWriteDecimal(_buffer, 4, "length", array_length(_framesArray));
        __AbBufferWritePair(_buffer, 4, "lockOrigin", bool(lockOrigin));
        
        __AbBufferWriteLine(_buffer, "    \"moments\":{");
        __AbBufferWriteLine(_buffer, "      \"$KeyframeStore<MomentsEventKeyframe>\":\"\",");
        __AbBufferWriteLine(_buffer, "      \"Keyframes\":[],");
        __AbBufferWriteLine(_buffer, "      \"resourceType\":\"KeyframeStore<MomentsEventKeyframe>\",");
        __AbBufferWriteLine(_buffer, "      \"resourceVersion\":\"2.0\",");
        __AbBufferWriteLine(_buffer, "    },");
        
        __AbBufferWritePair(_buffer, 4, "name", name);
        __AbBufferWritePair(_buffer, 4, "playback", playback);
        __AbBufferWriteDecimal(_buffer, 4, "playbackSpeed", playbackSpeed);
        __AbBufferWritePair(_buffer, 4, "playbackSpeedType", playbackSpeedType);
        __AbBufferWritePair(_buffer, 4, "resourceType", "GMSequence");
        __AbBufferWritePair(_buffer, 4, "resourceVersion", "2.0");
        __AbBufferWritePair(_buffer, 4, "showBackdrop", bool(showBackdrop));
        __AbBufferWritePair(_buffer, 4, "showBackdropImage", bool(showBackdropImage));
        __AbBufferWritePair(_buffer, 4, "timeUnits", timeUnits);
        
        __AbBufferWriteLine(_buffer, "    \"tracks\":[");
        __AbBufferWriteLine(_buffer, "      {\"$GMSpriteFramesTrack\":\"\",\"builtinName\":0,\"events\":[],\"inheritsTrackColour\":true,\"interpolation\":1,\"isCreationTrack\":false,\"keyframes\":{\"$KeyframeStore<SpriteFrameKeyframe>\":\"\",\"Keyframes\":[");
        
        //Ensure we have enough sequence frame UUIDs
        repeat(array_length(_framesArray) - array_length(seqFrameUUIDArray))
        {
            array_push(seqFrameUUIDArray, __AbGenerateUUID());
        }
        
        var _i = 0;
        repeat(array_length(_framesArray))
        {
            __AbBufferWriteLine(_buffer,  "            {\"$Keyframe<SpriteFrameKeyframe>\":\"\",\"Channels\":{");
            __AbBufferWriteLine(_buffer, $"                \"0\":\{\"$SpriteFrameKeyframe\":\"\",\"Id\":\{\"name\":\"{_framesArray[_i].frameUUID}\",\"path\":\"sprites/{_assetName}/{_assetName}.yy\",\},\"resourceType\":\"SpriteFrameKeyframe\",\"resourceVersion\":\"2.0\",\},");
            __AbBufferWriteLine(_buffer, $"              \},\"Disabled\":false,\"id\":\"{seqFrameUUIDArray[_i]}\",\"IsCreationKey\":false,\"Key\":{_i}.0,\"Length\":1.0,\"resourceType\":\"Keyframe<SpriteFrameKeyframe>\",\"resourceVersion\":\"2.0\",\"Stretch\":false,\},");
            ++_i;
        }
        
        __AbBufferWriteLine(_buffer, "          ],\"resourceType\":\"KeyframeStore<SpriteFrameKeyframe>\",\"resourceVersion\":\"2.0\",},\"modifiers\":[],\"name\":\"frames\",\"resourceType\":\"GMSpriteFramesTrack\",\"resourceVersion\":\"2.0\",\"spriteId\":null,\"trackColour\":0,\"tracks\":[],\"traits\":0,},");
        __AbBufferWriteLine(_buffer, "    ],");
        
        __AbBufferWritePair(_buffer, 4, "visibleRange", visibleRange);
        __AbBufferWriteDecimal(_buffer, 4, "volume", volume);
        __AbBufferWritePair(_buffer, 4, "xorigin", xorigin);
        __AbBufferWritePair(_buffer, 4, "yorigin", yorigin);
        __AbBufferWriteLine(_buffer, "  },");
    }
}