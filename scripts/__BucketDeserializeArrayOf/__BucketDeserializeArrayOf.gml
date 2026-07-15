function __BucketDeserializeArrayOf(_parent, _inputArray, _constructor)
{
    if (_inputArray == undefined)
    {
        return [];
    }
    
    if (not is_array(_inputArray))
    {
        __BucketError("Cannot deserialize array, value is not an array");
        return [];
    }
    
    var _length = array_length(_inputArray);
    var _outputArray = array_create(_length, undefined);
    
    var _i = 0;
    repeat(_length)
    {
        _outputArray[@ _i] = new _constructor().__Deserialize(_parent, _inputArray[_i]);
        ++_i;
    }
    
    return _outputArray;
}