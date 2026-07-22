/// @param alias

function BucketPackedDatafileGetMetadata(_alias)
{
    static _system = __BucketSystem();
    return _system.__metadataBucketDatafileDict[$ _alias];
}