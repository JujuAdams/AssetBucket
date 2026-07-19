/// @param processStruct
/// @param filePath

function __BucketEnsureProcessFileInfo(_processStruct, _filePath)
{
    static _fileInfoDict = __BucketSystem().__fileInfoDict;
    
    var _infoStruct = _fileInfoDict[$ _filePath];
    if (_infoStruct == undefined)
    {
        _infoStruct = new __BucketClassProcessFileInfo(_processStruct, _filePath);
        _fileInfoDict[$ _filePath] = _infoStruct;
    }
    
    return _infoStruct;
}