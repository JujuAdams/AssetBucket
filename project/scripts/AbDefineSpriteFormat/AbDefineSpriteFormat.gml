/// @param extensionOrArray
/// @param loadFunction

function AbDefineSpriteFormat(_extensionOrArray, _loadFunction)
{
    static _spriteFormatDict = __AbSystem().__spriteFormatDict;
    
    _extensionOrArray = __AbEnsureArray(_extensionOrArray);
    
    var _i = 0;
    repeat(array_length(_extensionOrArray))
    {
        _spriteFormatDict[$ _extensionOrArray[_i]] = _loadFunction;
        ++_i;
    }
}

AbDefineSpriteFormat(".psd", function(_path)
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
    $"echo Converting {_path} from PSD to PNG",
    $"\"{AB_IMAGEMAGICK_PATH}\" \"{_path}\"[0] \"{_destinationPath}\"");
    
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
        __AbError($"ImageMagick conversion of \"{_path}\" failed");
    }
    
    var _timer = current_time;
    while((current_time - _timer) < 1_000)
    {
    
    }
    
    return sprite_add(_destinationPath, 1, false, false, 0, 0);
});