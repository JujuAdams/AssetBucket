function __AbClassProjectSprite() constructor
{
    __sourceFilePathArray = [];
    
    assetName          = undefined;
    bboxMode           = undefined;
    bboxBottom         = undefined;
    bboxLeft           = undefined;
    bboxRight          = undefined;
    bboxTop            = undefined;
    collisionKind      = undefined;
    collisionTolerance = undefined;
    dynamicTexturePage = undefined;
    edgeFiltering      = undefined;
    for3D              = undefined;
    framesArray        = undefined;
    gridX              = undefined;
    gridY              = undefined;
    height             = undefined;
    HTile              = undefined;
    layersArray        = undefined;
    nineSlice          = undefined;
    origin             = undefined;
    folderInfo         = {};
    preMultiplyAlpha   = undefined;
    sequenceArray      = undefined;
    swatchColours      = undefined;
    swfPrecision       = undefined;
    textureGroupName   = undefined;
    type               = undefined;
    VTile              = undefined;
    width              = undefined;
    
    static __Template = function(_sourcePathArray, _projectStruct, _assetName, _width, _height, _projectFolder = "", _textureGroupName = "Default")
    {
        __sourcePathArray = _sourcePathArray;
        
        assetName          = _assetName;
        bboxMode           = 0;
        bboxBottom         = 0;
        bboxLeft           = 0;
        bboxRight          = 0;
        bboxTop            = 0;
        collisionKind      = 1;
        collisionTolerance = 0;
        dynamicTexturePage = false;
        edgeFiltering      = false;
        for3D              = false;
        gridX              = 0;
        gridY              = 0;
        height             = _height;
        HTile              = 0;
        nineSlice          = undefined;
        origin             = 0;
        folderInfo         = __AbMakeProjectFolderInfo(_projectFolder, _projectStruct, __folderInfo);
        preMultiplyAlpha   = false;
        swatchColours      = undefined;
        swfPrecision       = 0.5;
        textureGroupName   = _textureGroupName;
        type               = 0;
        VTile              = false;
        width              = _width;
        
        framesArray   = []; //TODO
        layersArray   = []; //TODO
        sequenceArray = []; //TODO
        
        return self;
    }
    
    static __Overwrite = function(_sourcePathArray, _projectStruct, _width, _height, _projectFolder = undefined, _textureGroupName = undefined)
    {
        __sourcePathArray = _sourcePathArray;
        
        if (_projectFolder != undefined)
        {
            __AbMakeProjectFolderInfo(_projectFolder, _projectStruct, __folderInfo);
        }
        
        if (_width != undefined)
        {
            __width = _width;
        }
        
        if (_height != undefined)
        {
            __height = _height;
        }
        
        if (_textureGroupName != undefined)
        {
            __textureGroupName = _textureGroupName;
        }
        
        return self;
    }
    
    static __Deserialize = function(_path)
    {
        var _yypData = __AbLoadJSON(_path);
        
        assetName          = _yypData.name;
        bboxMode           = _yypData.bboxMode;
        bboxBottom         = _yypData.bbox_bottom;
        bboxLeft           = _yypData.bbox_left;
        bboxRight          = _yypData.bbox_right;
        bboxTop            = _yypData.bbox_top;
        collisionKind      = _yypData.collisionKind;
        collisionTolerance = _yypData.collisionTolerance;
        dynamicTexturePage = _yypData.DynamicTexturePage;
        edgeFiltering      = _yypData.edgeFiltering;
        for3D              = _yypData.For3D;
        gridX              = _yypData.gridX;
        gridY              = _yypData.gridY;
        height             = _yypData.height;
        HTile              = _yypData.HTile;
        preMultiplyAlpha   = _yypData.preMultiplyAlpha;
        nineSlice          = _yypData.nineSlice;
        origin             = _yypData.origin;
        folderInfo         = { __name: _yypData.parent.name, __path: _yypData.parent.path };
        swatchColours      = _yypData.swatchColours;
        swfPrecision       = _yypData.swfPrecision;
        textureGroupName   = _yypData.textureGroupId.name;
        type               = _yypData.type;
        VTile              = _yypData.VTile;
        width              = _yypData.width;
        
        framesArray = _yypData.frames;
        array_map_ext(_yypData.frames, function(_element, _index)
        {
            return (new __AbClassProjectSpriteFrame()).__Deserialize(_element);
        });
        
        layersArray = _yypData.layers;
        array_map_ext(_yypData.layers, function(_element, _index)
        {
            return (new __AbClassProjectSpriteLayer()).__Deserialize(_element);
        });
        
        sequenceArray = _yypData.sequence;
        array_map_ext(_yypData.sequence, function(_element, _index)
        {
            return (new __AbClassProjectSpriteSequence()).__Deserialize(_element);
        });
        
        return self;
    }
    
    static __Save = function(_yyPath)
    {
        if (__sourceFilePath == undefined)
        {
            __AbError($"Sound source file not set for asset \"{__assetName}\"");
        }
        else if (__sourceFilePath != __GetExpectedSoundFilePath(_yyPath))
        {
            if (not file_exists(__sourceFilePath))
            {
                __AbError($"Sound source file \"{__sourceFilePath}\" could not be found (asset \"{__assetName}\")");
            }
            
            file_copy(__sourceFilePath, __GetExpectedSoundFilePath(_yyPath));
        }
        
        var _buffer = buffer_create(1024, buffer_grow, 1);
        
        __AbBufferWriteLine( _buffer, "{");
        __AbBufferWritePair( _buffer, "$GMSprite", "v2");
        __AbBufferWritePair( _buffer, "%Name",              assetName);
        __AbBufferWritePair( _buffer, "bboxMode",           bboxMode);
        __AbBufferWritePair( _buffer, "bbox_bottom",        bboxBottom);
        __AbBufferWritePair( _buffer, "bbox_left",          bboxLeft);
        __AbBufferWritePair( _buffer, "bbox_right",         bboxRight);
        __AbBufferWritePair( _buffer, "bbox_top",           bboxTop);
        __AbBufferWritePair( _buffer, "collisionKind",      collisionKind);
        __AbBufferWritePair( _buffer, "collisionTolerance", collisionTolerance);
        __AbBufferWritePair( _buffer, "DynamicTexturePage", bool(dynamicTexturePage));
        __AbBufferWritePair( _buffer, "edgeFiltering",      bool(edgeFiltering));
        __AbBufferWritePair( _buffer, "For3D",              bool(for3D));
        __AbBufferWriteArray(_buffer, "frames",             framesArray);
        __AbBufferWritePair( _buffer, "gridX",              gridX);
        __AbBufferWritePair( _buffer, "gridY",              gridY);
        __AbBufferWritePair( _buffer, "height",             height);
        __AbBufferWritePair( _buffer, "HTile",              bool(HTile));
        __AbBufferWriteArray(_buffer, "layers",             layersArray);
        __AbBufferWritePair( _buffer, "name",               assetName);
        __AbBufferWritePair( _buffer, "nineSlice",          nineSlice);
        __AbBufferWritePair( _buffer, "origin",             origin);
        __AbBufferWriteLine( _buffer, "  \"parent\":{");
        __AbBufferWriteLine( _buffer, $"    \"name\":\"{__folderInfo.__name}\",");
        __AbBufferWriteLine( _buffer, $"    \"path\":\"{__folderInfo.__path}\",");
        __AbBufferWriteLine( _buffer, "  },");
        __AbBufferWritePair( _buffer, "preMultiplyAlpha", bool(preMultiplyAlpha));
        __AbBufferWritePair( _buffer, "resourceType",     "GMSprite");
        __AbBufferWritePair( _buffer, "resourceVersion",  "2.0"); //Needs to be a string
        __AbBufferWriteArray(_buffer, "sequence",         sequenceArray);
        __AbBufferWritePair( _buffer, "swatchColours",    swatchColours);
        __AbBufferWritePair( _buffer, "swfPrecision",     swfPrecision);
        __AbBufferWriteLine( _buffer, "  \"textureGroupId\":{");
        __AbBufferWriteLine( _buffer, $"    \"name\":\"{textureGroupName}\",");
        __AbBufferWriteLine( _buffer, $"    \"path\":\"texturegroups/{textureGroupName}\",");
        __AbBufferWriteLine( _buffer, "  },");
        __AbBufferWritePair( _buffer, "type",  type);
        __AbBufferWritePair( _buffer, "VTile", bool(VTile));
        __AbBufferWritePair( _buffer, "width", width);
        __AbBufferWriteLine( _buffer, "}");
        
        buffer_save_ext(_buffer, _yyPath, 0, buffer_tell(_buffer));
        buffer_delete(_buffer);
        
        return self;
    }
}