function __AbClassProjectSpriteNineslice() constructor
{
    bottom          = 0;
    enabled         = false;
    guideColour     = [0xFFFF00FF, 0xFFFF00FF, 0xFFFF00FF, 0xFFFF00FF];
    highlightColour = 0x66FF8A00;
    highlightStyle  = 0;
    left            = 0;
    right           = 0;
    tileMode        = [0, 0, 0, 0, 0];
    top             = 0;
    
    static __Deserialize = function(_yyStruct)
    {
        bottom          = _yyStruct.bottom;
        enabled         = _yyStruct.enabled;
        guideColour     = _yyStruct.guideColour;
        highlightColour = _yyStruct.highlightColour;
        highlightStyle  = _yyStruct.highlightStyle;
        left            = _yyStruct.left;
        right           = _yyStruct.right;
        tileMode        = _yyStruct.tileMode;
        top             = _yyStruct.top;
        
        return self;
    }
    
    static __Set = function(_enabled = undefined, _left = undefined, _top = undefined, _right = undefined, _bottom = undefined)
    {
        if (_enabled != undefined) enabled = _enabled;
        if (_left    != undefined) left    = _left;
        if (_top     != undefined) top     = _top;
        if (_right   != undefined) right   = _right;
        if (_bottom  != undefined) bottom  = _bottom;
        
        return self;
    }
    
    static __Save = function(_buffer)
    {
        __AbBufferWriteLine(_buffer, "  \"nineSlice\":{");
        __AbBufferWritePair(_buffer, 4, "$GMNineSliceData", "");
        __AbBufferWritePair(_buffer, 4, "bottom", bottom);
        __AbBufferWritePair(_buffer, 4, "enabled", bool(enabled));
        __AbBufferWritePair(_buffer, 4, "guideColour", guideColour);
        __AbBufferWritePair(_buffer, 4, "highlightColour", highlightColour);
        __AbBufferWritePair(_buffer, 4, "highlightStyle", highlightStyle);
        __AbBufferWritePair(_buffer, 4, "left", left);
        __AbBufferWritePair(_buffer, 4, "resourceType", "GMNineSliceData");
        __AbBufferWritePair(_buffer, 4, "resourceVersion", "2.0");
        __AbBufferWritePair(_buffer, 4, "right", right);
        __AbBufferWriteLine(_buffer, "    \"tileMode\":[\n");
        __AbBufferWriteLine(_buffer, $"      {tileMode[0]},");
        __AbBufferWriteLine(_buffer, $"      {tileMode[1]},");
        __AbBufferWriteLine(_buffer, $"      {tileMode[2]},");
        __AbBufferWriteLine(_buffer, $"      {tileMode[3]},");
        __AbBufferWriteLine(_buffer, $"      {tileMode[4]},");
        __AbBufferWriteLine(_buffer, "    ],");
        __AbBufferWritePair(_buffer, 4, "top", top);
        __AbBufferWriteLine(_buffer, "  },");
    }
}