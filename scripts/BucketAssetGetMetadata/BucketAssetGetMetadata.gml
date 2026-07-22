/// @param assetName

function BucketAssetGetMetadata(_assetName)
{
    static _system = __BucketSystem();
    return _system.__metadataAssetDict[$ _assetName];
}