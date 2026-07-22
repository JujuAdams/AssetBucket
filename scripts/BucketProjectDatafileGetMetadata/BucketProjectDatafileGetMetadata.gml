/// @param localPath

function BucketProjectDatafileGetMetadata(_localPath)
{
    static _system = __BucketSystem();
    return _system.__metadataProjectDatafileDict[$ _localPath];
}