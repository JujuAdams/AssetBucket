function __AbClassProjectSpriteFrame() constructor
{
    static __Template = function(_source)
    {
        __source = _source;
        frameUUID = __AbGenerateUUID();
        
        return self;
    }
    
    static __Deserialize = function(_yyStruct, _yyDirectory, _layerUUID)
    {
        frameUUID = _yyStruct.name;
        __source = __GetExpectedImageFilePath(_yyDirectory, _layerUUID);
        
        return self;
    }
    
    static __GetExpectedImageFilePath = function(_yyDirectory, _layerUUID)
    {
        return $"{_yyDirectory}{frameUUID}.png";
    }
    
    static __SetSource = function(_source)
    {
        __source = _source;
        
        return self;
    }
    
    static __Save = function(_buffer, _width, _height, _yyDirectory, _layerUUID)
    {
        buffer_write(_buffer, buffer_text, $"    \{\"$GMSpriteFrame\":\"v1\",\"%Name\":\"{frameUUID}\",\"name\":\"{frameUUID}\",\"resourceType\":\"GMSpriteFrame\",\"resourceVersion\":\"2.0\",\},\n");
        
        var _imagePath = __GetExpectedImageFilePath(_yyDirectory, _layerUUID);
        __AbSaveSourceAsImage(__source, _imagePath, _width, _height);
        file_copy(_imagePath, $"{_yyDirectory}layers/{frameUUID}/{_layerUUID}.png");
    }
}