function __AbSoftError(_string)
{
    if (AB_RUNNING_FROM_IDE)
    {
        __AbError(_string);
    }
    else
    {
        __AbTrace(_string);
    }
}