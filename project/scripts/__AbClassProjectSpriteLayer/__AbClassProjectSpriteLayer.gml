function __AbClassProjectSpriteLayer() constructor
{
    static __Template = function()
    {
        layerUUID   = __AbGenerateUUID();
        blendMode   = 0;
        displayName = "default";
        isLocked    = false;
        opacity     = 100;
        visible     = true;
        
        return self;
    }
    
    static __Deserialize = function(_yyStruct)
    {
        layerUUID   = _yyStruct.name;
        blendMode   = _yyStruct.blendMode;
        displayName = _yyStruct.displayName;
        isLocked    = _yyStruct.isLocked;
        opacity     = _yyStruct.opacity;
        visible     = _yyStruct.visible;
        
        return self;
    }
    
    static __Save = function(_buffer)
    {
        buffer_write(_buffer, buffer_text, $"    \{\"$GMImageLayer\":\"\",\"%Name\":\"{layerUUID}\",\"blendMode\":{blendMode},\"displayName\":\"{displayName}\",\"isLocked\":{isLocked? "true" : "false"},\"name\":\"{layerUUID}\",\"opacity\":{opacity},\"resourceType\":\"GMSpriteFrame\",\"resourceVersion\":\"2.0\",\"visible\":{visible? "true" : "false"},\},\n");
    }
}