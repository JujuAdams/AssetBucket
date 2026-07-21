function __BucketGetDatafilesName(_alias)
{
    return $"ab_{md5_string_utf8(_alias)}";
}