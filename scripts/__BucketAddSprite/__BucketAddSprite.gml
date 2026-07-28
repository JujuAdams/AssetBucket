function __BucketAddSprite(_rootDirectory, _path)
{
    var _sprite = -1;
    
    if (is_struct(_path))
    {
        var _surface = surface_create(_path.width, _path.height);
        buffer_set_surface(_path.buffer, _surface, _path[$ "offset"] ?? 0);
        var _sprite = sprite_create_from_surface(_surface, 0, 0, _path.width, _path.height, false, false, 0, 0);
        surface_free(_surface);
    }
    else if (is_struct(_path))
    {
        var _absolutePath = _rootDirectory + _path;
        
        if (filename_ext(_absolutePath) != ".psd")
        {
            _sprite = sprite_add(_absolutePath, 0, false, false, 0, 0);
        }
        else
        {
            if (BUCKET_IMAGEMAGICK_PATH == undefined)
            {
                __BucketError($"`BUCKET_IMAGEMAGICK_PATH` must be defined before importing PSD files");
            }
        
            if (not file_exists(BUCKET_IMAGEMAGICK_PATH))
            {
                __BucketError($"ImageMagick binary could not be found. Please check `BUCKET_IMAGEMAGICK_PATH`\nPath was {BUCKET_IMAGEMAGICK_PATH}");
            }
        
            var _destinationPath = $"{game_save_id}convert.png";
            var _batchPath = $"{game_save_id}convert_psd_to_png.bat";
        
            file_delete(_batchPath);
            file_delete(_destinationPath);
        
            var _batchFileString = string_join("\n",
            "@echo off",
            $"echo Converting {_absolutePath} from PSD to PNG",
            $"\"{BUCKET_IMAGEMAGICK_PATH}\" \"{_absolutePath}\"[0] \"{_destinationPath}\"");
        
            __BucketSaveString(_batchFileString, _batchPath);
            __BucketExecuteShell(_batchPath, "");
        
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
                __BucketError($"ImageMagick conversion of \"{_absolutePath}\" failed");
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
        __BucketError($"Failed to load \"{_absolutePath}\" as a sprite");
    }
    
    return _sprite;
}