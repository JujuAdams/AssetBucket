function BucketIngest()
{
    static _system = __BucketSystem();
    
    var _injestStruct = new __BucketClassInjest(_system.__config);
    _system.__config.__Collect(_injestStruct);
    _injestStruct.__Injest();
    
    return _injestStruct;
}