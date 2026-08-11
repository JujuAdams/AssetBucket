/// @param bucketName
/// @param assetName
/// @param fileDesc


function CustomPipeBucketAseprite(_bucketName, _assetName, _fileDesc)
{
    //Load the Aseprite file
    var _aseStruct = AsepriteRead(_fileDesc.absolutePath);
    
    //Remove any layers and tags that we want to ignore
    _aseStruct.HideLayersByMask("*[ignore]").DeleteTagsByMask("*[ignore]");
    
    //Render out the Aseprite frames
    _aseStruct.Render(false);
    
    var _frameArray = _aseStruct.frameArray;
    var _tagArray   = _aseStruct.tagArray;
    var _sliceArray = _aseStruct.sliceArray;
    
    if (array_length(_sliceArray))
    {
        var _fallbackProjectFolder = $"Sprites/{AbFilenameDir(_fileDesc.localPath)}/{_fileDesc.suggestedName}";
        
        if (array_length(_tagArray) <= 0) //We have no tags
        {
            //Build an array from each frame's buffer
            var _i = 0;
            repeat(array_length(_sliceArray))
            {
                var _sliceStruct = _sliceArray[_i];
                var _keyStruct = _sliceStruct.keyArray[0];
                
                var _spriteDesc = AbPipeBucketSprite(_bucketName, $"{_assetName}_{_sliceStruct.name}", _sliceStruct.GetBuffer(0), _keyStruct.width, _keyStruct.height);
                
                if (_sliceStruct.flags & 0b01)
                {
                    _spriteDesc.SetNineslice(_keyStruct.xCenter, _keyStruct.yCenter,
                                             _keyStruct.width  - (_keyStruct.xCenter + _keyStruct.centerWidth ),
                                             _keyStruct.height - (_keyStruct.yCenter + _keyStruct.centerHeight));
                }
                
                ++_i;
            }
        }
        else
        {
            //Build an array from each slice buffer for each frame of all tags
            var _i = 0;
            repeat(array_length(_sliceArray))
            {
                var _sliceStruct = _sliceArray[_i];
                var _keyStruct = _sliceStruct.keyArray[0];
                
                var _j = 0;
                repeat(array_length(_tagArray))
                {
                    var _tagStruct = _tagArray[_j];
                    
                    var _tagFrame = _tagStruct.fromFrame;
                    var _tagCount = 1 + _tagStruct.toFrame - _tagFrame;
                    
                    //Build an array from each slice frame's buffer
                    var _sourcesArray = array_create(_tagCount, undefined);
                    var _k = 0;
                    repeat(_tagCount)
                    {
                        _sourcesArray[@ _k] = _sliceStruct.GetBuffer(_tagFrame);
                        ++_k;
                        ++_tagFrame;
                    }
                    
                    var _spriteDesc = AbPipeBucketSprite(_bucketName, $"{_assetName}_{_sliceStruct.name}_{_tagStruct.name}", _sourcesArray, _keyStruct.width, _keyStruct.height);
                    
                    if (_sliceStruct.flags & 0b01)
                    {
                        _spriteDesc.SetNineslice(_keyStruct.xCenter, _keyStruct.yCenter,
                                                 _keyStruct.width  - (_keyStruct.xCenter + _keyStruct.centerWidth ),
                                                 _keyStruct.height - (_keyStruct.yCenter + _keyStruct.centerHeight));
                    }
                    
                    ++_j;
                }
                
                ++_i;
            }
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
            
            AbPipeBucketSprite(_bucketName, _assetName, _frameBufferArray, _canvasWidth, _canvasHeight);
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
                
                AbPipeBucketSprite(_bucketName, $"{_assetName}_{_tagName}", _frameBufferArray, _canvasWidth, _canvasHeight);
                
                ++_i;
            }
        }
    }
}