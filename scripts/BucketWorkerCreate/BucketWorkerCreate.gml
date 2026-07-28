/// @param function
/// @param [variableStruct]

function BucketWorkerCreate(_function, _variableStruct = {})
{
    if (not is_method(_function))
    {
        __BucketError($"Function is incorrect datatype ({typeof(_function)})");
    }
    
    static_set(_variableStruct, static_get(__BucketClassWorker));
    _variableStruct.__bucketWorkerFunction = method(_variableStruct, _function);
    
    return _variableStruct;
}

//Spin up a copy on boot so we can access its static later
new __BucketClassWorker();
function __BucketClassWorker() constructor
{
    __bucketWorkerFunction = undefined;
    
    
    
    static SetBucketMetadata = function(_bucketName, _alias, _metadata)
    {
        __commandList.__SetBucketMetadata(_bucketName, _alias, _metadata);
    }
    
    static AddDatafileToBucket = function(_bucketName, _alias, _path)
    {
        __commandList.__AddDatafileToBucket(_bucketName, _alias, _path);
    }
    
    static AddSpriteToBucket = function(_bucketName, _alias, _pathOrArray, _textureGroup = _bucketName)
    {
        __commandList.__AddSpriteToBucket(_bucketName, _alias, _pathOrArray, _textureGroup);
    }
    
    static AddWAVToBucket = function(_bucketName, _alias, _path, _compress = false)
    {
        __commandList.__AddWAVToBucket(_bucketName, _alias, _path, _compress);
    }
    
    static AddOGGToBucket = function(_bucketName, _alias, _path)
    {
        __commandList.__AddOGGToBucket(_bucketName, _alias, _path);
    }
    
    static AddDataBufferToBucket = function(_bucketName, _alias, _bufferDescriptor)
    {
        __commandList.__AddDataBufferToBucket(_bucketName, _alias, __BucketEnsureBufferDescriptor(_bufferDescriptor));
    }
    
    //static AddSpriteBufferToBucket = function(_bucketName, _alias, _bufferDescriptor)
    //{
    //    __commandList.__AddSpriteBufferToBucket(_bucketName, _alias, __BucketEnsureBufferDescriptor(_bufferDescriptor));
    //}
    //
    //static AddWAVBufferToBucket = function(_bucketName, _alias, _bufferDescriptor)
    //{
    //    __commandList.__AddWAVBufferToBucket(_bucketName, _alias, __BucketEnsureBufferDescriptor(_bufferDescriptor));
    //}
    //
    //static AddOGGBufferToBucket = function(_bucketName, _alias, _bufferDescriptor)
    //{
    //    __commandList.__AddOGGBufferToBucket(_bucketName, _alias, __BucketEnsureBufferDescriptor(_bufferDescriptor));
    //}
    //
    //static AddPCMBufferToBucket = function(_bucketName, _alias, _bufferDescriptor)
    //{
    //    __commandList.__AddPCMBufferToBucket(_bucketName, _alias, __BucketEnsureBufferDescriptor(_bufferDescriptor));
    //}
    
    
    
    
    
    static SetProjectMetadata = function(_bucketName, _alias, _metadata)
    {
        __commandList.__SetProjectMetadata(_bucketName, _alias, _metadata);
    }
    
    static AddDatafileToProject = function(_localDatafilePath, _absoluteSourcePath)
    {
        __commandList.__AddDatafileToProject(_localDatafilePath, _absoluteSourcePath);
    }
    
    static AddSpriteToProject = function(_assetName, _pathOrArray, _projectFolder, _textureGroup = "Default")
    {
        __commandList.__AddSpriteToProject(_assetName, __BucketEnsureArray(_pathOrArray));
    }
    
    static AddSoundToProject = function(_assetName, _path, _projectFolder, _audioGroup = "audiogroup_default")
    {
        __commandList.__AddSoundToProject(_assetName, _path, _audioGroup);
    }
    
    static AddDataBufferToProject = function(_localDatafilePath, _bufferDescriptor)
    {
        __commandList.__AddDataBufferToProject(_localDatafilePath, __BucketEnsureBufferDescriptor(_bufferDescriptor));
    }
    
    //static AddSpriteBufferToProject = function(_assetName, _bufferDescriptorOrArray)
    //{
    //    __commandList.__AddSpriteBufferToProject(_assetName, __BucketEnsureBufferDescriptor(_bufferDescriptor));
    //}
    //
    //static AddWAVBufferToBucket = function(_assetName, _bufferDescriptor)
    //{
    //    __commandList.__AddWAVBufferToBucket(_assetName, __BucketEnsureBufferDescriptor(_bufferDescriptor));
    //}
    //
    //static AddOGGBufferToBucket = function(_assetName, _bufferDescriptor)
    //{
    //    __commandList.__AddOGGBufferToBucket(_assetName, __BucketEnsureBufferDescriptor(_bufferDescriptor));
    //}
    //
    //static AddPCMBufferToBucket = function(_assetName, _bufferDescriptor)
    //{
    //    __commandList.__AddPCMBufferToBucket(_assetName, __BucketEnsureBufferDescriptor(_bufferDescriptor));
    //}
    
    
    
    
    
    static Execute = function(_fileList, _commandList)
    {
        __commandList = _commandList;
        
        var _function = __bucketWorkerFunction;
        var _fileDataArray = _fileList.__fileDataArray;
        
        var _i = 0;
        repeat(array_length(_fileDataArray))
        {
            _function(_fileDataArray[_i]);
            ++_i;
        }
        
        __commandList = undefined;
    }
}