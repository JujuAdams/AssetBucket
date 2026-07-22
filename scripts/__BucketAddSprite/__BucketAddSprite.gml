function __BucketAddSprite(_absolutePath)
{
    var _sprite = -1;
    
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
        var _batchPath = $"{game_save_id}convert_psd.bat";
        
        file_delete(_batchPath);
        file_delete(_destinationPath);
        
        var _batchFileString = string_join("\n",
        "@echo off",
        $"echo Converting {_absolutePath}",
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
    
    if (not sprite_exists(_sprite))
    {
        __BucketError($"Failed to load \"{_absolutePath}\" as a sprite");
    }
    
    return _sprite;
}