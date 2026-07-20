/// @param originalPath

function BucketDatafileGetString(_originalPath)
{
    var _ref = BucketDatafileGetRef(_originalPath);
    return buffer_peek(_ref.buffer, _ref.offset, buffer_string);
}