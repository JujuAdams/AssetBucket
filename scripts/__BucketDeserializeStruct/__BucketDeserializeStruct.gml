function __BucketDeserializeStruct(_parent, _inputStruct, _constructor)
{
    if (_inputStruct == undefined)
    {
        return undefined;
    }
    
    if (not is_struct(_inputStruct))
    {
        __BucketError("Cannot deserialize struct, value is not an struct");
        return [];
    }
    
    return new _constructor().__Deserialize(_parent, _inputStruct);
}