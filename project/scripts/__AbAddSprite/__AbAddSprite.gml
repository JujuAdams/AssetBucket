function __AbAddSprite(_absolutePath)
{
    var _sprite = -1;
    
    if (is_struct(_absolutePath))
    {
        var _surface = surface_create(_absolutePath.width, _absolutePath.height);
        buffer_set_surface(_absolutePath.buffer, _surface, _absolutePath[$ "offset"] ?? 0);
        var _sprite = sprite_create_from_surface(_surface, 0, 0, _absolutePath.width, _absolutePath.height, false, false, 0, 0);
        surface_free(_surface);
    }
    else if (is_string(_absolutePath))
    {
        if (filename_ext(_absolutePath) != ".psd")
        {
            _sprite = sprite_add(_absolutePath, 0, false, false, 0, 0);
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
            $"echo Converting {_absolutePath} from PSD to PNG",
            $"\"{AB_IMAGEMAGICK_PATH}\" \"{_absolutePath}\"[0] \"{_destinationPath}\"");
        
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
                __AbError($"ImageMagick conversion of \"{_absolutePath}\" failed");
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
    
    if (not sprite_exists(_sprite))
    {
        __AbError($"Failed to load \"{_absolutePath}\" as a sprite");
    }
    
    return _sprite;
}