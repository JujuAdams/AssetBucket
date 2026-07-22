function __BucketDeclareDefaultWorkerFunctions()
{
    static _once = (function()
    {
        BucketDeclareWorkerFunction("importToBucket", function(_filePath, _workerInfo)
        {
            __BucketVariableAssertString(_workerInfo, "function");
            __BucketVariableAssertString(_workerInfo, "resourceType");
            __BucketVariableAssertString(_workerInfo, "bucket");
            
            var _type = _workerInfo.resourceType;
            if (_type == "datafile")
            {
                BucketIngestBucketDatafile(_filePath, _workerInfo.bucket);
            }
            else if (_type == "sprite")
            {
                if (is_array(_filePath))
                {
                    var _spriteName = filename_change_ext(string_replace_all(filename_name(_filePath[0]), "_frame0.", "."), "");
                }
                else
                {
                    var _spriteName = filename_change_ext(filename_name(_filePath), "");
                }
                
                BucketIngestBucketSprite(_filePath, _workerInfo.bucket, _spriteName, _workerInfo[$ "textureGroup"]);
            }
            else if (_type == "sound")
            {
                var _soundName = filename_change_ext(filename_name(_filePath), "");
                BucketIngestBucketSound(_filePath, _workerInfo.bucket, _workerInfo[$ "compress"] ?? false, _soundName);
            }
            else
            {
                __BucketError($"Type \"{_type}\" unhandled");
            }
        });
        
        BucketDeclareWorkerFunction("importToProject", function(_filePath, _workerInfo)
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
                if (is_array(_filePath))
                {
                    var _spriteName = filename_change_ext(string_replace_all(filename_name(_filePath[0]), "_frame0.", "."), "");
                }
                else
                {
                    var _spriteName = filename_change_ext(filename_name(_filePath), "");
                }
                
                BucketIngestProjectSprite(_spriteName, _filePath, _workerInfo.folder, _workerInfo[$ "textureGroup"]);
            }
            else if (_type == "sound")
            {
                var _soundName = filename_change_ext(filename_name(_filePath), "");
                BucketIngestProjectSound(_soundName, _filePath, _workerInfo.folder, _workerInfo[$ "audioGroup"]);
            }
            else
            {
                __BucketError($"Type \"{_type}\" unhandled");
            }
        });
    })();
}