/// @param path

function BucketClassImagePSD(_path)
{
    __parent = undefined;
    
    __path = _path;
    
    __sprite = undefined;
    __width  = undefined;
    __height = undefined;
    
    static GetSprite = function()
    {
        if (sprite_exists(__sprite)) return __sprite;
        
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
        $"echo Converting {__path} from PSD to PNG",
        $"\"{BUCKET_IMAGEMAGICK_PATH}\" \"{__path}\"[0] \"{_destinationPath}\"");
        
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
            __BucketError($"ImageMagick conversion of \"{__path}\" failed");
        }
        else
        {
            var _timer = current_time;
            while((current_time - _timer) < 1_000)
            {
            
            }
            
            __sprite = sprite_add(_destinationPath, 1, false, false, 0, 0);
        }
    }
    
    static GetWidth = function()
    {
        if (__width == undefined)
        {
            __width = sprite_get_width(GetSprite());
        }
        
        return __width;
    }
    
    static GetHeight = function()
    {
        if (__height == undefined)
        {
            __height = sprite_get_height(GetSprite());
        }
        
        return __height;
    }
    
    static SaveAs = function(_filename)
    {
        sprite_save(GetSprite(), 0, _filename);
    }
    
    static FreeMemory = function()
    {
        if (sprite_exists(__sprite))
        {
            sprite_delete(__sprite);
            __sprite = undefined;
        }
    }
}