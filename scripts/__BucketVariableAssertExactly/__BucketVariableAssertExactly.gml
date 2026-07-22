/// @param struct
/// @param variableNameArray

function __BucketVariableAssertExactly(_struct, _variableNameArray)
{
    var _namesArray = struct_get_names(_struct);
    array_sort(_namesArray, true);
    array_sort(_variableNameArray, true);
    
    if (not array_equals(_variableNameArray, _namesArray))
    {
        __BucketError($"Object must contain exactly {_variableNameArray}\nFound {_namesArray}");
    }
    
    return true;
}