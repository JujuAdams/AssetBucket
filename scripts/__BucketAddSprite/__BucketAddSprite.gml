function __BucketAddSprite(_absolutePath)
{
    if (filename_ext(_absolutePath) != ".psd")
    {
        return sprite_add(_absolutePath, 0, false, false, 0, 0);
    }
    
    var _sprite = -1;
    
    var _destinationPath = $"{game_save_id}convert.png";
    var _batchPath = $"{game_save_id}convert_psd.bat";
    
    file_delete(_batchPath);
    file_delete(_destinationPath);
    
    var _batchFileString = string_join("\n",
    "@echo off",
    "echo Converting PSD file",
    $"\"{BUCKET_IMAGEMAGICK_PATH}\" \"{_absolutePath}\"[0] \"{_destinationPath}\"");
    
    __BucketSaveString(_batchFileString, _batchPath);
    __BucketExecuteShell(_batchPath, "");
    
    var _overallTimer = current_time;
    while((current_time - _overallTimer) < 10_000)
    {
        var _timer = current_time;
        while((current_time - _timer) < 500)
        {
            
        }
        
        if (file_exists(_destinationPath))
        {
            _sprite = sprite_add(_destinationPath, 0, false, false, 0, 0);
            break;
        }
    }
    
    var _timer = current_time;
    while((current_time - _timer) < 500)
    {
        
    }
    
    file_delete(_batchPath);
    file_delete(_destinationPath);
    
    return _sprite;
}