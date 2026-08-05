function __AbClassProjectSpriteFrame() constructor
{
    static __Template = function(_sourceFilePath)
    {
        __sourceFilePath = _sourceFilePath;
        
        frameUUID = __AbGenerateUUID();
        
        return self;
    }
    
    static __Deserialize = function(_yyStruct, _yyDirectory, _layerUUID)
    {
        frameUUID = _yyStruct.name;
        
        __sourceFilePath = __GetExpectedImageFilePath(_yyDirectory, _layerUUID);
        
        return self;
    }
    
    static __GetExpectedImageFilePath = function(_yyDirectory, _layerUUID)
    {
        return $"{_yyDirectory}{frameUUID}.png";
    }
    
    static __Edit = function(_sourceFilePath)
    {
        __sourceFilePath = _sourceFilePath;
        
        return self;
    }
    
    static __Save = function(_buffer, _yyDirectory, _layerUUID)
    {
        buffer_write(_buffer, buffer_text, $"    \{\"$GMSpriteFrame\":\"v1\",\"%Name\":\"{frameUUID}\",\"name\":\"{frameUUID}\",\"resourceType\":\"GMSpriteFrame\",\"resourceVersion\":\"2.0\",\},\n");
        
        var _imagePath = __GetExpectedImageFilePath(_yyDirectory, _layerUUID);
        if (__sourceFilePath != _imagePath)
        {
            file_copy(__sourceFilePath, _imagePath);
            file_copy(__sourceFilePath, $"{_yyDirectory}layers/{frameUUID}/{_layerUUID}.png");
        }
    }
}