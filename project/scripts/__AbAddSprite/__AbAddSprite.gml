function __AbAddSprite(_source, _hintWidth = undefined, _hintHeight = undefined)
{
    var _sprite = -1;
    
    if (is_handle(_source))
    {
        if (buffer_exists(_source))
        {
            if ((_hintWidth == undefined) || (_hintHeight == undefined))
            {
                __AbError($"Buffer source type not supported without hinted width & height\nPlease hint a width and height or pass a `AbBufferDescription()`");
            }
            else
            {
                var _surface = surface_create(_hintWidth, _hintHeight);
                buffer_set_surface(_source, _surface, 0);
                var _sprite = sprite_create_from_surface(_surface, 0, 0, _hintWidth, _hintHeight, false, false, 0, 0);
                surface_free(_surface);
            }
        }
        else if (surface_exists(_source))
        {
            var _sprite = sprite_create_from_surface(_surface, 0, 0, surface_get_width(_source), surface_get_height(_source), false, false, 0, 0);
        }
        else
        {
            __AbError($"Source type not supported ({typeof(_source)})");
        }
    }
    else if (is_struct(_source))
    {
        if (is_instanceof(_source, AbBufferDescription))
        {
            var _surface = surface_create(_source.imageWidth, _source.imageHeight);
            buffer_set_surface(_source.buffer, _surface, _source.offset);
            var _sprite = sprite_create_from_surface(_surface, 0, 0, _source.imageWidth, _source.imageHeight, false, false, 0, 0);
            surface_free(_surface);
        }
        else if (is_instanceof(_source, AbSurfaceDescription))
        {
            var _sprite = sprite_create_from_surface(_source.surface, _source.left, _source.top, _source.width, _source.height, false, false, 0, 0);
        }
        else
        {
            __AbError($"Source struct not supported ({instanceof(_source)})");
        }
    }
    else if (is_string(_source))
    {
        if (filename_ext(_source) != ".psd")
        {
            _sprite = sprite_add(_source, 0, false, false, 0, 0);
        }
        else
        {
            if (AB_IMAGEMAGICK_PATH == undefined)
            {
                __AbError($"`AB_IMAGEMAGICK_PATH` must be defined before importing PSD files");
            }
        
            if (not file_exists(AB_IMAGEMAGICK_PATH))
            {
                __AbError($"ImageMagick binary could not be found. Please check `AB_IMAGEMAGICK_PATH`\nPath was {AB_IMAGEMAGICK_PATH}");
            }
        
            var _destinationPath = $"{game_save_id}convert.png";
            var _batchPath = $"{game_save_id}convert_psd_to_png.bat";
        
            file_delete(_batchPath);
            file_delete(_destinationPath);
        
            var _batchFileString = string_join("\n",
            "@echo off",
            $"echo Converting {_source} from PSD to PNG",
            $"\"{AB_IMAGEMAGICK_PATH}\" \"{_source}\"[0] \"{_destinationPath}\"");
        
            __AbSaveString(_batchFileString, _batchPath);
            __AbExecuteShell(_batchPath, "");
        
            var _finished = false;
            var _overallTimer = current_time;
            while((current_time - _overallTimer) < 10_000)
            {
                if (file_exists(_destinationPath))
                {
                    _finished = true;
                    break;
                }
            }
        
            if (not _finished)
            {
                __AbError($"ImageMagick conversion of \"{_source}\" failed");
            }
            else
            {
                var _timer = current_time;
                while((current_time - _timer) < 1_000)
                {
            
                }
            
                _sprite = sprite_add(_destinationPath, 1, false, false, 0, 0);
            }
        }
    }
    else
    {
        __AbError($"Source type not supported ({typeof(_source)})");
    }
    
    if (not sprite_exists(_sprite))
    {
        __AbError($"Failed to load \"{_source}\" as a sprite");
    }
    
    return _sprite;
}