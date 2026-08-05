function __AbClassProjectSpriteFrame(_projectSprite) constructor
{
    __projectSprite = _projectSprite;
    
    static __Template = function(_source)
    {
        __source = _source;
        
        frameUUID = __AbGenerateUUID();
        
        return self;
    }
    
    static __Deserialize = function(_yyStruct, _yyDirectory, _layerUUID)
    {
        __source = __GetExpectedImageFilePath(_yyDirectory, _layerUUID);
        
        frameUUID = _yyStruct.name;
        
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
    
    static __Save = function(_buffer, _yyDirectory, _layerUUID)
    {
        buffer_write(_buffer, buffer_text, $"    \{\"$GMSpriteFrame\":\"v1\",\"%Name\":\"{frameUUID}\",\"name\":\"{frameUUID}\",\"resourceType\":\"GMSpriteFrame\",\"resourceVersion\":\"2.0\",\},\n");
        
        var _imagePath = __GetExpectedImageFilePath(_yyDirectory, _layerUUID);
        if (is_string(__source))
        {
            if (__source != _imagePath)
            {
                file_copy(__source, _imagePath);
            }
        }
        else if (is_handle(__source))
        {
            if (buffer_exists(__source))
            {
                __AbSaveBufferAsPNG(_imagePath, __source, __projectSprite.width, __projectSprite.height);
            }
            else if (surface_exists(__source))
            {
                surface_save(__source, _imagePath);
            }
        }
        
        file_copy(_imagePath, $"{_yyDirectory}layers/{frameUUID}/{_layerUUID}.png");
    }
}