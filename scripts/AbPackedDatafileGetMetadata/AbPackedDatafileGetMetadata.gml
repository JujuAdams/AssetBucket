/// @param alias

function AbPackedDatafileGetMetadata(_alias)
{
    static _system = __AbSystem();
    return _system.__metadataBucketDatafileDict[$ _alias];
}