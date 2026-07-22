/// @param alias

function BucketBucketDatafileGetMetadata(_alias)
{
    static _system = __BucketSystem();
    return _system.__metadataBucketDatafileDict[$ _alias];
}