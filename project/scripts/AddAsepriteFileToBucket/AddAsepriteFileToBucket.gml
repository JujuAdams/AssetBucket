/// @param assetName
/// @param fileDesc
/// @param bucketName
/// @param commandList

function AddAsepriteFileToBucket(_assetName, _fileDesc, _bucketName, _commandList)
{
    //Load the Aseprite file
    var _aseStruct = AsepriteRead(_fileDesc.absolutePath);
    
    //Remove any layers and tags that we want to ignore
    _aseStruct.HideLayersByMask("*[ignore]").DeleteTagsByMask("*[ignore]");
    
    //Render out the Aseprite frames
    _aseStruct.Render(true);
    
    var _frameArray = _aseStruct.frameArray;
    var _tagArray   = _aseStruct.tagArray;
    var _sliceArray = _aseStruct.sliceArray;
    
    if (array_length(_sliceArray))
    {
        if (array_length(_tagArray) <= 0) //We have no tags
        {
            var _surface = _aseStruct.frameArray[0].GetSurface();
            var _fallbackProjectFolder = $"Sprites/{AbFilenameDir(_fileDesc.localPath)}/{_fileDesc.suggestedName}";
            
            //Build an array from each frame's buffer
            var _i = 0;
            repeat(array_length(_sliceArray))
            {
                var _sliceStruct = _sliceArray[_i];
                var _keyStruct = _sliceStruct.keyArray[0];
                
                var _surfaceDesc = new AbSurfaceDescription(_surface, _keyStruct.xOrigin, _keyStruct.yOrigin, _keyStruct.width, _keyStruct.height);
                var _bucketSprite = new AbBucketSprite($"{_assetName}_{_sliceStruct.name}", _surfaceDesc, _keyStruct.width, _keyStruct.height);
                
                if (_sliceStruct.flags & 0b01)
                {
                    _bucketSprite.SetNineslice(_keyStruct.xCenter, _keyStruct.yCenter,
                                               _keyStruct.width  - (_keyStruct.xCenter + _keyStruct.centerWidth ),
                                               _keyStruct.height - (_keyStruct.yCenter + _keyStruct.centerHeight));
                }
                
                _commandList.AddSpriteToBucket(_bucketName, _bucketSprite);
                ++_i;
            }
        }
        else
        {
            //TODO
        }
    }
    else
    {
        var _canvasWidth  = _aseStruct.width;
        var _canvasHeight = _aseStruct.height;
        
        if (array_length(_tagArray) <= 0) //We have no tags
        {
            //Build an array from each frame's buffer
            var _frameArray = _aseStruct.frameArray;
            var _frameBufferArray = array_create(array_length(_frameArray));
            var _i = 0;
            repeat(array_length(_frameArray))
            {
                _frameBufferArray[@ _i] = _frameArray[_i].buffer;
                ++_i;
            }
            
            _commandList.AddSpriteToBucket(_bucketName, new AbBucketSprite(_assetName, _frameBufferArray, _canvasWidth, _canvasHeight));
        }
        else //We have some tags
        {
            //If we don't have an existing project folder, organise all imported tags into a separate
            //folder in the project
            var _fallbackProjectFolder = $"Sprites/{AbFilenameDir(_fileDesc.localPath)}/{_fileDesc.suggestedName}";
            
            var _i = 0;
            repeat(array_length(_tagArray))
            {
                var _tagName = _tagArray[_i].name;
                var _frameArray = _aseStruct.GetTagFrames(_tagName);
                
                //Build an array from each frame's buffer
                var _frameBufferArray = array_create(array_length(_frameArray));
                var _j = 0;
                repeat(array_length(_frameArray))
                {
                    _frameBufferArray[@ _j] = _frameArray[_j].buffer;
                    ++_j;
                }
                
                _commandList.AddSpriteToBucket(_bucketName, new AbBucketSprite($"{_assetName}_{_tagName}", _frameBufferArray, _canvasWidth, _canvasHeight));
                ++_i;
            }
        }
    }
}