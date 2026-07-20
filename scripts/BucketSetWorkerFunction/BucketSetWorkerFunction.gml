/// Callback is called with the following parameters:
/// 
/// callback(filePath, workerInfo)
/// 
/// @param name
/// @param callback

function BucketSetWorkerFunction(_name, _callback)
{
    static _workerFunctionDict = __BucketSystem().__workerFunctionDict;
    
    _workerFunctionDict[$ _name] = _callback;
}