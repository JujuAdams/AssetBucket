/// @param processStruct
/// @param filePath

function __BucketEnsureFileInfo(_processStruct, _filePath)
{
    static _fileInfoDict = __BucketSystem().__fileInfoDict;
    
    var _infoStruct = _fileInfoDict[$ _filePath];
    if (_infoStruct == undefined)
    {
        _infoStruct = new __BucketClassFileInfo(_processStruct, _filePath);
        _fileInfoDict[$ _filePath] = _infoStruct;
    }
    
    return _infoStruct;
}