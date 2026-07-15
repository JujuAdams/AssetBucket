/// @param struct
/// @param variableNameArray

function __BucketVariableAssertOnly(_struct, _variableNameArray)
{
    var _nameArray = struct_get_names(_struct);
    var _i = 0;
    repeat(array_length(_nameArray))
    {
        if (array_get_index(_variableNameArray, _nameArray[_i]) < 0)
        {
            __BucketError($".{_nameArray[_i]} is not a valid variable name");
        }
        
        ++_i;
    }
}