function BucketIngest()
{
    static _system = __BucketSystem();
    
    var _processStruct = new __BucketClassProcess(_system.__config);
    _system.__config.__Collect(_processStruct);
    _processStruct.__Process();
    
    return _processStruct;
}