/// @param struct
/// @param variableNameArray

function __BucketVariableAssertExactly(_struct, _variableNameArray)
{
    var _namesArray = struct_get_names(_struct);
    array_sort(_namesArray, true);
    array_sort(_variableNameArray, true);
    return array_equals(_variableNameArray, _namesArray);
}