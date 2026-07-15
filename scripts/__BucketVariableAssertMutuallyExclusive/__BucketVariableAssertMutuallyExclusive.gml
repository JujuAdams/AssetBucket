/// @param struct
/// @param variableName
/// @param ...

function __BucketVariableAssertMutuallyExclusive()
{
    var _struct = argument[0];
    
    var _lastSeen = undefined;
    var _i = 1;
    repeat(argument_count-1)
    {
        if (struct_exists(_struct, argument[_i]))
        {
            if (_lastSeen == undefined)
            {
                _lastSeen = argument[_i];
            }
            else
            {
                __BucketError($".{_lastSeen} is mutually exclusive with .{argument[_i]}");
            }
        }
        
        ++_i;
    }
}