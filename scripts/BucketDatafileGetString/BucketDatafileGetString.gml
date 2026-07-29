/// @param originalPath

function AbDatafileGetString(_originalPath)
{
    var _ref = AbDatafileGetRef(_originalPath);
    return buffer_peek(_ref.buffer, _ref.offset, buffer_string);
}