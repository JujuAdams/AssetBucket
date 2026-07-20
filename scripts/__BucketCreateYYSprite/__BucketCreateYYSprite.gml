/// @param framePathArray
/// @param spriteName
/// @param width
/// @param height
/// @param folderInProject
/// @param textureGroupName
/// @param projectName
/// @param projectDirectory

function __BucketCreateYYSprite(_framePathArray, _spriteName, _width, _height, _folderInProject, _textureGroupName, _projectName, _projectDirectory)
{
    var _directory = $"{_projectDirectory}sprites/{_spriteName}/";
    
    //Generate UUIDs
    var _frameCount = array_length(_framePathArray);
    var _frameUUIDArray = array_create_ext(_frameCount, __BucketGenerateUUID);
    var _layerUUID    = __BucketGenerateUUID();
    var _seqFrameUUID = __BucketGenerateUUID();
    
    //Grab the template and do some basic replacements
    var _yyString = _templateYY;
    _yyString = string_replace_all(_yyString, "%resourceName%", _spriteName);
    _yyString = string_replace_all(_yyString, "%textureGroupName%", _textureGroupName);
    _yyString = string_replace_all(_yyString, "%layerUUID%", _layerUUID);
    _yyString = string_replace_all(_yyString, "%seqFrameUUID%", _seqFrameUUID);
    _yyString = string_replace_all(_yyString, "%width%", _width);
    _yyString = string_replace_all(_yyString, "%height%", _height);
    
    //Set the in-project folder path
    if (_folderInProject == "")
    {
        var _parentName = _projectName;
        var _parentPath = $"{_projectName}.yyp";
    }
    else
    {
        _folderInProject = __BucketTrimDirectory(_folderInProject);
        var _parentPath = $"folders/{_folderInProject}.yy";
        var _parentName = $"{filename_name(_folderInProject)}.yy";
    }
    
    _yyString = string_replace_all(_yyString, "%folderName%", _parentName);
    _yyString = string_replace_all(_yyString, "%folderPath%", _parentPath);
    
    //Generate the frame array, sequence frame array, and also copy files around
    var _frameArrayString = "";
    var _seqFrameArrayString = "";
    
    var _i = 0;
    repeat(_frameCount)
    {
        var _frameUUID = _frameUUIDArray[_i];
        
        //Add to the frame array string
        _frameArrayString += string_replace_all(_templateFrame, "%frameUUID%", _frameUUID);
        
        //Add to the sequence frame array string
        var _seqFrameArraySubtring = _templateSeqFrame;
        _seqFrameArraySubtring = string_replace_all(_seqFrameArraySubtring, "%resourceName%", _spriteName);
        _seqFrameArraySubtring = string_replace_all(_seqFrameArraySubtring, "%frameIndex%", _i);
        _seqFrameArraySubtring = string_replace_all(_seqFrameArraySubtring, "%frameUUID%", _frameUUID);
        _seqFrameArrayString += _seqFrameArraySubtring;
        
        //Copy the source file over
        var _sourcePath = _framePathArray[_i];
        file_copy(_sourcePath, $"{_directory}/{_frameUUID}.png");
        file_copy(_sourcePath, $"{_directory}/layers/{_frameUUID}/{_layerUUID}.png");
        
        ++_i;
    }
    
    //Trim off the trailing newline
    _frameArrayString = string_copy(_frameArrayString, 1, string_length(_frameArrayString)-1);
    _seqFrameArrayString = string_copy(_seqFrameArrayString, 1, string_length(_seqFrameArrayString)-1);
    
    _yyString = string_replace_all(_yyString, "%frameArray%", _frameArrayString);
    _yyString = string_replace_all(_yyString, "%seqFrameArray%", _seqFrameArrayString);
    
    __BucketSaveString(_yyString, $"{_directory}{_spriteName}.yy");
    
    
    
    static _templateFrame = @'    {"$GMSpriteFrame":"v1","%Name":"%frameUUID%","name":"%frameUUID%","resourceType":"GMSpriteFrame","resourceVersion":"2.0",},
';
    
    static _templateSeqFrame = @'                "%frameIndex%":{"$SpriteFrameKeyframe":"","Id":{"name":"%frameUUID%","path":"sprites/%resourceName%/%resourceName%.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},
';
    
    static _templateYY = @'{
  "$GMSprite":"v2",
  "%Name":"%resourceName%",
  "bboxMode":0,
  "bbox_bottom":0,
  "bbox_left":0,
  "bbox_right":0,
  "bbox_top":0,
  "collisionKind":1,
  "collisionTolerance":0,
  "DynamicTexturePage":false,
  "edgeFiltering":false,
  "For3D":false,
  "frames":[
%frameArray%
  ],
  "gridX":0,
  "gridY":0,
  "height":%height%,
  "HTile":false,
  "layers":[
    {"$GMImageLayer":"","%Name":"%layerUUID%","blendMode":0,"displayName":"default","isLocked":false,"name":"%layerUUID%","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,},
  ],
  "name":"%resourceName%",
  "nineSlice":null,
  "origin":0,
  "parent":{
    "name":"%folderName%",
    "path":"%folderPath%",
  },
  "preMultiplyAlpha":false,
  "resourceType":"GMSprite",
  "resourceVersion":"2.0",
  "sequence":{
    "$GMSequence":"v1",
    "%Name":"%resourceName%",
    "autoRecord":true,
    "backdropHeight":768,
    "backdropImageOpacity":0.5,
    "backdropImagePath":"",
    "backdropWidth":1366,
    "backdropXOffset":0.0,
    "backdropYOffset":0.0,
    "events":{
      "$KeyframeStore<MessageEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MessageEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "eventStubScript":null,
    "eventToFunction":{},
    "length":1.0,
    "lockOrigin":false,
    "moments":{
      "$KeyframeStore<MomentsEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MomentsEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "name":"{resourceName}",
    "playback":1,
    "playbackSpeed":30.0,
    "playbackSpeedType":0,
    "resourceType":"GMSequence",
    "resourceVersion":"2.0",
    "showBackdrop":true,
    "showBackdropImage":false,
    "timeUnits":1,
    "tracks":[
      {"$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[
            {"$Keyframe<SpriteFrameKeyframe>":"","Channels":{
%seqFrameArray%
              },"Disabled":false,"id":"%seqFrameUUID%","IsCreationKey":false,"Key":0.0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,},
          ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":null,"trackColour":0,"tracks":[],"traits":0,},
    ],
    "visibleRange":null,
    "volume":1.0,
    "xorigin":0,
    "yorigin":0,
  },
  "swatchColours":null,
  "swfPrecision":0.5,
  "textureGroupId":{
    "name":"%textureGroupName%",
    "path":"texturegroups/%textureGroupName%",
  },
  "type":0,
  "VTile":false,
  "width":%width%,
}';
}