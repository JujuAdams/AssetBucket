function __AbClassProjectSprite(_projectStruct, _assetName) constructor
{
    _assetName = AsciiTransliterateNoSymbols(_assetName);
    
    __projectStruct = _projectStruct;
    __yyPath        = $"{_projectStruct.__directory}sprites/{_assetName}/{_assetName}.yy";
    
    assetName          = _assetName;
    bboxMode           = 0;
    bboxBottom         = 0;
    bboxLeft           = 0;
    bboxRight          = 0;
    bboxTop            = 0;
    collisionKind      = 1;
    collisionTolerance = 0;
    configValues       = undefined;
    dynamicTexturePage = false;
    edgeFiltering      = false;
    for3D              = false;
    framesArray        = [];
    gridX              = 0;
    gridY              = 0;
    height             = undefined;
    hTile              = 0;
    layer              = (new __AbClassProjectSpriteLayer()).__Template();
    nineSlice          = undefined;
    origin             = 0;
    folder             = "";
    preMultiplyAlpha   = false;
    sequence           = (new __AbClassProjectSpriteSequence()).__Template(_assetName);
    swatchColours      = undefined;
    swfPrecision       = 0.5;
    tagsArray          = [];
    textureGroupName   = "Default";
    type               = 0;
    vTile              = false;
    width              = undefined;
    
    if (_projectStruct.GetAssetExists(_assetName) && file_exists(__yyPath))
    {
        var _yyString = __AbLoadString(__yyPath);
        var _data = undefined;
    
        try
        {
            _yyData = json_parse(_yyString);
        }
        catch(_error)
        {
            show_debug_message(_error);
            __AbError($"Failed to parse JSON from \"{__yyPath}\"");
        }
        
        var _yyDirectory = AbFilenameDir(__yyPath) + "/";
        
        if (array_length(_yyData.layers) > 1)
        {
            __AbError($"More than one layer not supported");
        }
        
        var _startPos = string_pos("\n  \"ConfigValues\":{\n", _yyString);
        if (_startPos > 0)
        {
            var _endPos = string_pos("\n  \"DynamicTexturePage\":", _yyString);
            configValues = string_copy(_yyString, _startPos+1, _endPos - _startPos);
        }
        
        assetName          = _yyData.name;
        bboxMode           = _yyData.bboxMode;
        bboxBottom         = _yyData.bbox_bottom;
        bboxLeft           = _yyData.bbox_left;
        bboxRight          = _yyData.bbox_right;
        bboxTop            = _yyData.bbox_top;
        collisionKind      = _yyData.collisionKind;
        collisionTolerance = _yyData.collisionTolerance;
        dynamicTexturePage = _yyData.DynamicTexturePage;
        edgeFiltering      = _yyData.edgeFiltering;
        for3D              = _yyData.For3D;
        gridX              = _yyData.gridX;
        gridY              = _yyData.gridY;
        height             = _yyData.height;
        hTile              = _yyData.HTile;
        layer              = (new __AbClassProjectSpriteLayer()).__Deserialize(_yyData.layers[0]);
        preMultiplyAlpha   = _yyData.preMultiplyAlpha;
        sequence           = (new __AbClassProjectSpriteSequence()).__Deserialize(_yyData.sequence);
        origin             = _yyData.origin;
        folder             = __AbStringifyYYFolderPath(_yyData.parent.path);
        swatchColours      = _yyData.swatchColours;
        swfPrecision       = _yyData.swfPrecision;
        textureGroupName   = _yyData.textureGroupId.name;
        tagsArray          = _yyData[$ "tags"] ?? [];
        type               = _yyData.type;
        vTile              = _yyData.VTile;
        width              = _yyData.width;
        
        if (_yyData.nineSlice == undefined)
        {
            nineSlice = undefined;
        }
        else
        {
            nineSlice = (new __AbClassProjectSpriteNineslice()).__Deserialize(_yyData.nineSlice);
        }
        
        var _yyFramesArray = _yyData.frames;
        framesArray = array_create(array_length(_yyFramesArray), undefined);
        
        var _layerUUID = layer.layerUUID;
        var _i = 0;
        repeat(array_length(_yyFramesArray))
        {
            framesArray[@ _i] = (new __AbClassProjectSpriteFrame(self)).__Deserialize(_yyFramesArray[_i], _yyDirectory, _layerUUID);
            ++_i;
        }
    }
    
    
    
    
    static SetNineslice = function(_enabled, _left, _top, _right, _bottom)
    {
        if (nineSlice == undefined)
        {
            nineSlice = new __AbClassProjectSpriteNineslice();
        }
        
        nineSlice.__Set(_enabled, _left, _top, _right, _bottom);
        
        return self;
    }
    
    static SetSource = function(_sourcePathArray, _width = undefined, _height = undefined)
    {
        _sourcePathArray = __AbEnsureArray(_sourcePathArray);
        
        //Overwrite existing frame data
        var _i = 0;
        repeat(min(array_length(_sourcePathArray), array_length(framesArray)))
        {
            framesArray[_i].__SetSource(_sourcePathArray[_i]);
            ++_i;
        }
        
        if (array_length(_sourcePathArray) <= array_length(framesArray))
        {
            //If the incoming frame count is lower than the existing number of frames, trim some off
            array_resize(framesArray, _i);
        }
        else
        {
            //Pad out the frame array with incoming source paths
            repeat(array_length(_sourcePathArray) - _i)
            {
                array_push(framesArray, (new __AbClassProjectSpriteFrame()).__Template(_sourcePathArray[_i]));
                ++_i;
            }
        }
        
        if ((_width == undefined) || (_height == undefined))
        {
            _width  ??= __AbGetSourceWidth(_sourcePathArray[0]);
            _height ??= __AbGetSourceHeight(_sourcePathArray[0]);
        }
        
        if (width != _width)
        {
            if ((bboxLeft == 0) && (bboxRight == 0))
            {
                bboxRight = _width-1;
            }
            else
            {
                bboxLeft  = min(bboxLeft,  _width-1);
                bboxRight = min(bboxRight, _width-1);
            }
            
            width = _width;
        }
        
        if (height != _height)
        {
            if ((bboxTop == 0) && (bboxBottom == 0))
            {
                bboxBottom = _height-1;
            }
            else
            {
                bboxTop    = min(bboxTop,    _height-1);
                bboxBottom = min(bboxBottom, _height-1);
            }
            
            height = _height;
        }
        
        return self;
    }
    
    static SetFolderIfRoot = function(_fallback)
    {
        if (folder == "")
        {
            folder = _fallback;
        }
        
        return self;
    }
    
    static AddToCommandList = function(_commandList)
    {
        _commandList.__AddSpriteToProject(self);
        return self;
    }
    
    static __Save = function()
    {
        if (array_length(framesArray) <= 0)
        {
            __AbError($"Sprite \"{assetName}\" has no frames");
        }
        
        var _yyDirectory = AbFilenameDir(__yyPath) + "/";
        var _folderInfo = __AbMakeProjectFolderInfo(folder, __projectStruct);
        
        var _buffer = buffer_create(1024, buffer_grow, 1);
        
        __AbBufferWriteLine(_buffer, "{");
        __AbBufferWritePair(_buffer, 2, "$GMSprite",          "v2");
        __AbBufferWritePair(_buffer, 2, "%Name",              assetName);
        __AbBufferWritePair(_buffer, 2, "bboxMode",           bboxMode);
        __AbBufferWritePair(_buffer, 2, "bbox_bottom",        bboxBottom);
        __AbBufferWritePair(_buffer, 2, "bbox_left",          bboxLeft);
        __AbBufferWritePair(_buffer, 2, "bbox_right",         bboxRight);
        __AbBufferWritePair(_buffer, 2, "bbox_top",           bboxTop);
        __AbBufferWritePair(_buffer, 2, "collisionKind",      collisionKind);
        __AbBufferWritePair(_buffer, 2, "collisionTolerance", collisionTolerance);
        
        if (configValues != undefined)
        {
            buffer_write(_buffer, buffer_text, configValues);
        }
        
        __AbBufferWritePair(_buffer, 2, "DynamicTexturePage", bool(dynamicTexturePage));
        __AbBufferWritePair(_buffer, 2, "edgeFiltering",      bool(edgeFiltering));
        __AbBufferWritePair(_buffer, 2, "For3D",              bool(for3D));
        
        __AbBufferWriteLine(_buffer, "  \"frames\":[");
        var _layerUUID = layer.layerUUID;
        var _i = 0;
        repeat(array_length(framesArray))
        {
            framesArray[_i].__Save(_buffer, width, height, _yyDirectory, _layerUUID);
            ++_i;
        }
        __AbBufferWriteLine(_buffer, "  ],");
        
        __AbBufferWritePair(_buffer, 2, "gridX",  gridX);
        __AbBufferWritePair(_buffer, 2, "gridY",  gridY);
        __AbBufferWritePair(_buffer, 2, "height", height);
        __AbBufferWritePair(_buffer, 2, "HTile",  bool(hTile));
        
        __AbBufferWriteLine(_buffer, "  \"layers\":[");
        layer.__Save(_buffer);
        __AbBufferWriteLine(_buffer, "  ],");
        
        __AbBufferWritePair(_buffer, 2, "name", assetName);
        
        if (nineSlice == undefined)
        {
            __AbBufferWritePair(_buffer, 2, "nineSlice", undefined);
        }
        else
        {
            nineSlice.__Save(_buffer);
        }
        
        __AbBufferWritePair(_buffer, 2, "origin", origin);
        __AbBufferWriteLine(_buffer, "  \"parent\":{");
        __AbBufferWriteLine(_buffer, $"    \"name\":\"{_folderInfo.__name}\",");
        __AbBufferWriteLine(_buffer, $"    \"path\":\"{_folderInfo.__path}\",");
        __AbBufferWriteLine(_buffer, "  },");
        __AbBufferWritePair(_buffer, 2, "preMultiplyAlpha", bool(preMultiplyAlpha));
        __AbBufferWritePair(_buffer, 2, "resourceType",     "GMSprite");
        __AbBufferWritePair(_buffer, 2, "resourceVersion",  "2.0"); //Needs to be a string
        
        sequence.__Save(_buffer, assetName, framesArray);
        
        __AbBufferWritePair(_buffer, 2, "swatchColours", swatchColours);
        __AbBufferWriteDecimal(_buffer, 2, "swfPrecision",  swfPrecision);
        __AbBufferWriteLine(_buffer, "  \"textureGroupId\":{");
        __AbBufferWriteLine(_buffer, $"    \"name\":\"{textureGroupName}\",");
        __AbBufferWriteLine(_buffer, $"    \"path\":\"texturegroups/{textureGroupName}\",");
        __AbBufferWriteLine(_buffer, "  },");
        
        if (array_length(tagsArray) > 0)
        {
            __AbBufferWriteLine(_buffer, "  \"tags\":[");
            
            var _i = 0;
            repeat(array_length(tagsArray))
            {
                __AbBufferWriteLine(_buffer, $"    \"{tagsArray[_i]}\",");
                ++_i;
            }
            
            __AbBufferWriteLine(_buffer, "  ],");
        }
        
        __AbBufferWritePair(_buffer, 2, "type",  type);
        __AbBufferWritePair(_buffer, 2, "VTile", bool(vTile));
        __AbBufferWritePair(_buffer, 2, "width", width);
        __AbBufferWriteLine(_buffer, "}");
        
        buffer_save_ext(_buffer, __yyPath, 0, buffer_tell(_buffer)-1); //Trim off the final newline
        buffer_delete(_buffer);
        
        return self;
    }
}