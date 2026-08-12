/// Returns whether a datafile with the given alias has been loaded and fetched.
/// 
/// @param alias

function AbBucketDatafileExists(_alias)
{
    static _runtimeBucketDatafileMap = __AbSystem().__runtimeBucketDatafileMap;
    return ds_map_exists(_runtimeBucketDatafileMap, _alias);
}