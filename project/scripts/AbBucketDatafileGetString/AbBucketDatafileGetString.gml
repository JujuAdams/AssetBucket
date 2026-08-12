/// Returns the contents of a bucket datafile as a string. The bucket must first have been both
/// loaded and fetched. If the datafile cannot be found this function will return `undefined`.
/// 
/// @param alias

function AbBucketDatafileGetString(_alias)
{
    var _ref = AbBucketDatafileGetRef(_alias);
    return (_ref == undefined)? undefined : buffer_peek(_ref.buffer, _ref.offset, buffer_string);
}