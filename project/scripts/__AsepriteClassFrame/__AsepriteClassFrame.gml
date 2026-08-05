/// The constructed struct has the following public methods:
/// `.GetSurface()`
/// `.Draw(x, y)`
/// `.DrawExt(x, y, xScale, yScale, angle, blend, alpha)`
/// `.SaveAs(path)`
/// 
/// The constructed struct has the following public read-only variables:
/// `.duration`
/// `.celArray`
/// `.buffer`

function __AsepriteClassFrame() constructor
{
    static _system = __AsepriteSystem();
    
    __fileStruct = undefined;
    
    duration = 66.666;
    
    celArray = [];
    buffer = undefined;
    
    __surface = undefined;
    
    
    
    static GetSurface = function()
    {
        if (not surface_exists(__surface))
        {
            __surface = surface_create(__fileStruct.width, __fileStruct.height);
            
            if (buffer_exists(buffer))
            {
                buffer_set_surface(buffer, __surface, 0);
            }
            else
            {
                surface_set_target(__surface);
                draw_clear_alpha(c_black, 0);
                surface_reset_target();
            }
        }
        
        return __surface;
    }
    
    static Draw = function(_x, _y)
    {
        draw_surface(GetSurface(), _x, _y);
    }
    
    static DrawPart = function(_left, _top, _width, _height, _x, _y)
    {
        draw_surface_part(GetSurface(), _left, _top, _width, _height, _x, _y);
    }
    
    static DrawExt = function(_x, _y, _xScale, _yScale, _angle, _blend, _alpha)
    {
        draw_surface_ext(GetSurface(), _x, _y, _xScale, _yScale, _angle, _blend, _alpha);
    }
    
    static DrawPartExt = function(_left, _top, _width, _height, _x, _y, _xScale, _yScale, _blend, _alpha)
    {
        draw_surface_part_ext(GetSurface(), _left, _top, _width, _height, _x, _y, _xScale, _yScale, _blend, _alpha);
    }
    
    static SaveAs = function(_path)
    {
        surface_save(GetSurface(), _path);
        
        return self;
    }
    
    
    
    static __Destroy = function()
    {
        var _i = 0;
        repeat(array_length(frameArray))
        {
            celArray[_i].__Destroy();
            ++_i;
        }
        
        if (buffer_exists(buffer))
        {
            buffer_delete(buffer);
            buffer = undefined;
        }
        
        if (surface_exists(__surface))
        {
            surface_free(__surface);
            __surface = undefined;
        }
    }
    
    static __Render = function(_paletteArray, _keepSurfaces)
    {
        var _width      = __fileStruct.width;
        var _height     = __fileStruct.height;
        var _layerArray = __fileStruct.layerArray;
        
        var _surface = surface_create(_width, _height);
        surface_set_target(_surface);
        draw_clear_alpha(c_black, 0); //TODO - Apply background colour
        surface_reset_target();
        
        var _orderedCelArray = variable_clone(celArray, 0);
        array_sort(_orderedCelArray, function(_a, _b)
        {
            if (_a.order != _b.order)
            {
                return sign(_a.order - _b.order);
            }
            else
            {
                return sign(_a.zIndex - _b.zIndex);
            }
        });
        
        var _i = 0;
        repeat(array_length(_orderedCelArray))
        {
            _orderedCelArray[_i].__Render(_surface, _layerArray, _paletteArray, _keepSurfaces);
            ++_i;
        }
        
        buffer = buffer_create(4*_width*_height, buffer_fixed, 1);
        buffer_get_surface(buffer, _surface, 0);
        
        if (_keepSurfaces)
        {
            __surface = _surface;
        }
        else
        {
            surface_free(_surface);
        }
    }
    
    static __Deserialize = function(_buffer, _fileStruct)
    {
        __fileStruct = _fileStruct;
        
        var _hasUUIDs         = __fileStruct.__hasUUIDs;
        var _paletteArray     = __fileStruct.paletteArray;
        var _paletteNameArray = __fileStruct.paletteNameArray;
        
        var _frameStart = buffer_tell(_buffer);
        var _frameSize = buffer_read(_buffer, buffer_u32);
        
        var _magicNumber = buffer_read(_buffer, buffer_u16);
        if (_magicNumber != 0xF1FA)
        {
            __AsepriteError($"Frame magic number check failed; got 0x{string_delete(string(ptr(_magicNumber)), 1, 12)}, expecting 0xF1FA");
        }
        
        var _oldChunkCount = buffer_read(_buffer, buffer_u16);
        duration           = buffer_read(_buffer, buffer_u16); //milliseconds
        buffer_seek(_buffer, buffer_seek_relative, 2);
        var _newChunkCount = buffer_read(_buffer, buffer_u32);
        chunkCount = (_newChunkCount == 0)? _oldChunkCount : _newChunkCount;
        
        //Discover new palette chunks (0x2019). If we find one then we should ignore old palette chunks
        var _ignoreLegacyPaletteChunks = false;
        var _tell = buffer_tell(_buffer);
        repeat(chunkCount)
        {
            var _chunkSize = buffer_peek(_buffer, buffer_tell(_buffer),   buffer_u32);
            var _chunkType = buffer_peek(_buffer, buffer_tell(_buffer)+4, buffer_u16);
            
            if (_chunkType == 0x2019)
            {
                _ignoreLegacyPaletteChunks = true;
                break;
            }
            
            buffer_seek(_buffer, buffer_seek_relative, _chunkSize);
        }
        
        var _userDataDestination = undefined;
        var _previousCelStruct   = undefined;
        
        buffer_seek(_buffer, buffer_seek_start, _tell);
        repeat(chunkCount)
        {
            var _chunkStart = buffer_tell(_buffer);
            var _chunkSize = buffer_read(_buffer, buffer_u32);
            var _chunkType = buffer_read(_buffer, buffer_u16);
            
            switch(_chunkType)
            {
                case 0x0004: //Old palette chunk
                    if (not _ignoreLegacyPaletteChunks)
                    {
                        var _writePaletteIndex = _system.__writePaletteIndex;
                        
                        var _packetCount = buffer_read(_buffer, buffer_u16);
                        repeat(_packetCount)
                        {
                            var _skip = buffer_read(_buffer, buffer_u8);
                            var _colorCount = buffer_read(_buffer, buffer_u8);
                            
                            _writePaletteIndex += _skip;
                            repeat(_colorCount)
                            {
                                var _red   = buffer_read(_buffer, buffer_u8);
                                var _green = buffer_read(_buffer, buffer_u8);
                                var _blue  = buffer_read(_buffer, buffer_u8);
                            
                                var _color = 0xFF000000 | (_blue << 16) | (_green << 8) | _red;
                                _paletteArray[@ _writePaletteIndex++] = _color;
                            }
                        }
                        
                        _system.__writePaletteIndex = _writePaletteIndex;
                        _userDataDestination = _fileStruct;
                    }
                break;
                
                case 0x0011: //Old palette chunk
                    if (not _ignoreLegacyPaletteChunks)
                    {
                        var _writePaletteIndex = _system.__writePaletteIndex;
                        
                        var _packetCount = buffer_read(_buffer, buffer_u16);
                        repeat(_packetCount)
                        {
                            var _skip = buffer_read(_buffer, buffer_u8);
                            var _colorCount = buffer_read(_buffer, buffer_u8);
                            
                            _writePaletteIndex += _skip;
                            repeat(_colorCount)
                            {
                                var _red   = floor(min(63, buffer_read(_buffer, buffer_u8)) * (255/63));
                                var _green = floor(min(63, buffer_read(_buffer, buffer_u8)) * (255/63));
                                var _blue  = floor(min(63, buffer_read(_buffer, buffer_u8)) * (255/63));
                                
                                var _color = 0xFF000000 | (_blue << 16) | (_green << 8) | _red;
                                _paletteArray[@ _writePaletteIndex++] = _color;
                            }
                        }
                        
                        _system.__writePaletteIndex = _writePaletteIndex;
                        _userDataDestination = _fileStruct;
                    }
                break;
                
                case 0x2004: //Layer chunk
                    var _layerStruct = (new __AsepriteClassLayer()).__Deserialize(_buffer, _hasUUIDs);
                    array_push(_fileStruct.layerArray, _layerStruct);
                    _userDataDestination = _layerStruct;
                break;
                
                case 0x2005: //Cel chunk
                    var _celStruct = (new __AsepriteClassCel()).__Deserialize(_buffer, _fileStruct, _chunkStart + _chunkSize);
                    
                    if (_celStruct.__linkFrame != undefined)
                    {
                        array_push(_fileStruct.__linkedCelArray, {
                            __frame:      _celStruct.__linkFrame,
                            __layerIndex: _celStruct.layerIndex,
                            __celArray:   celArray,
                            __celIndex:   array_length(celArray),
                        });
                    }
                    
                    array_push(celArray, _celStruct);
                    _userDataDestination = _celStruct;
                    _previousCelStruct = _celStruct;
                break;
                
                case 0x2006: //Cel extra chunk
                    if (is_struct(_previousCelStruct))
                    {
                        _previousCelStruct.__DeserializeExtra(_buffer);
                    }
                    else
                    {
                        __AsepriteTrace($"Warning! Saw extra cel chunk but we haven't read a normal cel chunk yet");
                    }
                break;
                
                case 0x2007: //Color profle chunk
                    var _colorType = buffer_read(_buffer, buffer_u16);
                    // 0 - no color profile (as in old .aseprite files)
                    // 1 - use sRGB
                    // 2 - use the embedded ICC profile
                    
                    with(_fileStruct.colorProfile)
                    {
                        type       = _colorType;
                        flags      = buffer_read(_buffer, buffer_u16);
                        fixedGamma = __AsepriteReadFixedPoint(_buffer);
                        buffer_seek(_buffer, buffer_seek_relative, 8); //Reserved
                        
                        if (_colorType == 2)
                        {
                            var _iccProfileSize = buffer_read(_buffer, buffer_u32);
                            buffer_seek(_buffer, buffer_seek_relative, _iccProfileSize); //ICC profile data
                        }
                    }
                    
                    _userDataDestination = _fileStruct;
                break;
                
                case 0x2008: //External file chunk
                    var _entriesCount = buffer_read(_buffer, buffer_u32);
                    buffer_seek(_buffer, buffer_seek_relative, 8);
                    
                    var _i = 0;
                    repeat(_entriesCount)
                    {
                        array_push(_fileStruct.externalFileArray, (new __AsepriteClassExternalFile()).__Deserialize(_buffer));
                        ++_i;
                    }
                    
                    _userDataDestination = undefined;
                break;
            
                case 0x2016: //Mask chunk
                    //Deprecated
                    
                    _userDataDestination = undefined;
                break;
            
                case 0x2017: //Path chunk
                    //Never used
                    
                    _userDataDestination = undefined;
                break;

                case 0x2018: //Tags chunk
                    __userDataToTagIndex = array_length(_fileStruct.tagArray);
                    
                    var _tagCount = buffer_read(_buffer, buffer_u16);
                    buffer_seek(_buffer, buffer_seek_relative, 8); //Reserved
                    
                    repeat(_tagCount)
                    {
                        var _tagStruct = (new __AsepriteClassTag()).__Deserialize(_buffer, self);
                        
                        array_push(_fileStruct.tagArray, _tagStruct);
                        _fileStruct.tagDict[$ _tagStruct.name] = _tagStruct;
                    
                        _userDataDestination = _tagStruct;
                    }
                break;
                
                case 0x2019: //Palette chunk
                    var _paletteEntryCount = buffer_read(_buffer, buffer_u32);
                    var _paletteEntryFirst = buffer_read(_buffer, buffer_u32);
                    var _paletteEntryLast  = buffer_read(_buffer, buffer_u32);
                    buffer_seek(_buffer, buffer_seek_relative, 8); //Reserved
                    
                    var _paletteIndex = _paletteEntryFirst;
                    repeat(_paletteEntryCount)
                    {
                        var _flags = buffer_read(_buffer, buffer_u16);
                        var _red   = buffer_read(_buffer, buffer_u8);
                        var _green = buffer_read(_buffer, buffer_u8);
                        var _blue  = buffer_read(_buffer, buffer_u8);
                        var _alpha = buffer_read(_buffer, buffer_u8);
                        
                        var _color = (_alpha << 24) | (_blue << 16) | (_green << 8) | _red;
                        var _name = (_flags & 0b1)? __AsepriteReadString(_buffer) : undefined;
                        
                        _paletteArray[@     _paletteIndex] = _color;
                        _paletteNameArray[@ _paletteIndex] = _name;
                        _paletteIndex++;
                    }
                
                    _userDataDestination = _fileStruct;
                break;
                
                case 0x2020: //User chunk
                    var _userDataStruct = (new __AsepriteClassUserData()).__Deserialize(_buffer);
                    
                    if (is_struct(_userDataDestination))
                    {
                        if (not is_instanceof(_userDataDestination, __AsepriteClassTag))
                        {
                            _userDataDestination.userData = _userDataStruct;
                        }
                        else
                        {
                            _fileStruct.tagArray[@ __userDataToTagIndex++].userData = _userDataStruct;
                        }
                    }
                    else
                    {
                        __AsepriteTrace($"Warning! User data has no valid destination");
                    }
                break;
                
                case 0x2022: //Slice chunk
                    var _sliceStruct = (new __AsepriteClassSlice()).__Deserialize(_buffer);
                    array_push(_fileStruct.sliceArray, _sliceStruct);
                    _fileStruct.sliceDict[$ _sliceStruct.name] = _sliceStruct;
                    _userDataDestination = _sliceStruct;
                break;
                
                case 0x2023: //Tileset chunk
                    var _tilesetStruct = (new __AsepriteClassTileset()).__Deserialize(_buffer, _fileStruct);
                    array_push(_fileStruct.tilesetArray, _tilesetStruct);
                    _fileStruct.tilesetDict[$ _tilesetStruct.tilesetID] = _tilesetStruct;
                    _userDataDestination = _tilesetStruct;
                break;
            
                default:
                    show_error($" \nChunk unhandled {string(ptr(_chunkType))}\n ", true);
                break;
            }
        
            if (buffer_tell(_buffer) != _chunkStart + _chunkSize)
            {
                __AsepriteTrace($"Warning! Buffer position mismatch for chunk type 0x{string_delete(string(ptr(_chunkType)), 1, 12)}. We're at {buffer_tell(_buffer)}, expecting {_chunkStart + _chunkSize}");
            }
        
            buffer_seek(_buffer, buffer_seek_start, _chunkStart + _chunkSize);
        }
        
        buffer_seek(_buffer, buffer_seek_start, _frameStart + _frameSize);
        
        return self;
    }
}