function __BucketYYPInject(_yypString, _contentStruct, _string)
{
    _yypString = string_delete(_yypString, _contentStruct.__startPos, _contentStruct.__endPos - _contentStruct.__startPos);
    _yypString = string_insert(_string, _yypString, _contentStruct.__startPos);
    return _yypString;
}