function __BucketSoftError(_string)
{
    if (BUCKET_RUNNING_FROM_IDE)
    {
        __BucketError(_string);
    }
    else
    {
        __BucketTrace(_string);
    }
}