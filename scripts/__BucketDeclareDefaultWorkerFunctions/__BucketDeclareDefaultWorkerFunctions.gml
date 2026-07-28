function __BucketDeclareDefaultWorkerFunctions()
{
    static _once = (function()
    {
        BucketDeclareWorkerFunction("importToBucket", function(_fileStruct, _workerInfo)
        {
            __BucketVariableAssertString(_workerInfo, "function");
            __BucketVariableAssertString(_workerInfo, "resourceType");
            __BucketVariableAssertString(_workerInfo, "bucket");
            
            var _type = _workerInfo.resourceType;
            if (_type == "datafile")
            {
                BucketIngestBucketDatafile(_fileStruct.path, _workerInfo.bucket);
            }
            else if (_type == "sprite")
            {
                BucketIngestBucketSprite(_fileStruct.path, _workerInfo.bucket, _fileStruct.alias, _workerInfo[$ "textureGroup"]);
            }
            else if (_type == "sound")
            {
                BucketIngestBucketSound(_fileStruct.path, _workerInfo.bucket, _workerInfo[$ "compress"] ?? false, _fileStruct.alias);
            }
            else
            {
                __BucketError($"Type \"{_type}\" unhandled");
            }
        });
        
        BucketDeclareWorkerFunction("importToProject", function(_fileStruct, _workerInfo)
        {
            __BucketVariableAssertString(_workerInfo, "function");
            __BucketVariableAssertString(_workerInfo, "resourceType");
            __BucketVariableAssertString(_workerInfo, "folder");
            
            var _type = _workerInfo.resourceType;
            if (_type == "datafile")
            {
                BucketIngestProjectDatafile(_workerInfo.folder);
            }
            else if (_type == "sprite")
            {
                BucketIngestProjectSprite(_fileStruct.alias, _fileStruct.path, _workerInfo.folder, _workerInfo[$ "textureGroup"]);
            }
            else if (_type == "sound")
            {
                BucketIngestProjectSound(_fileStruct.alias, _fileStruct.path, _workerInfo.folder, _workerInfo[$ "audioGroup"]);
            }
            else
            {
                __BucketError($"Type \"{_type}\" unhandled");
            }
        });
    })();
}