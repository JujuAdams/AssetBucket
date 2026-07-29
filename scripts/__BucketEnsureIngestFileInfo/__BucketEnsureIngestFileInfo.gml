/// @param filePath

function __AbEnsureIngestFileInfo(_filePath)
{
    static _fileInfoDict = __AbSystem().__fileInfoDict;
    
    var _infoStruct = _fileInfoDict[$ _filePath];
    if (_infoStruct == undefined)
    {
        _infoStruct = new __AbClassIngestFileInfo(_filePath);
        _fileInfoDict[$ _filePath] = _infoStruct;
    }
    
    return _infoStruct;
}