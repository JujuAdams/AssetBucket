/// Returns a struct that describes a location in a buffer which contains the requested datafile.
/// If the datafile cannot be found this function will return `undefined`.
/// 
/// The struct has the following variables:
/// `.buffer` = Buffer that contains the datafile
/// `.offset` = Position in the buffer that the datafile starts
/// `.size`   = Number of bytes that the datafile occupies
/// 
/// N.B. You must never destroy the buffer referenced in the returned struct.
/// 
/// @param alias

function AbBucketDatafileGetRef(_alias)
{
    static _runtimeBucketDatafileMap = __AbSystem().__runtimeBucketDatafileMap;
    return _runtimeBucketDatafileMap[? _alias];
}