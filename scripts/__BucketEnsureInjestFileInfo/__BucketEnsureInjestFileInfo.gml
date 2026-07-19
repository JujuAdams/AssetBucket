/// @param injestStruct
/// @param filePath

function __BucketEnsureInjestFileInfo(_injestStruct, _filePath)
{
    static _fileInfoDict = __BucketSystem().__fileInfoDict;
    
    var _infoStruct = _fileInfoDict[$ _filePath];
    if (_infoStruct == undefined)
    {
        _infoStruct = new __BucketClassInjestFileInfo(_injestStruct, _filePath);
        _fileInfoDict[$ _filePath] = _infoStruct;
    }
    
    return _infoStruct;
}