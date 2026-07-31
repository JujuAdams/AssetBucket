/// @param originalPath

function AbBucketDatafileGetString(_originalPath)
{
    var _ref = AbBucketDatafileGetRef(_originalPath);
    return buffer_peek(_ref.buffer, _ref.offset, buffer_string);
}