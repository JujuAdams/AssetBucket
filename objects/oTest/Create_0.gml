BucketIngest();
BucketInitialize();

BucketDatafilesLoad("bucketDefault");
show_debug_message(json_stringify(BucketDatafilesGetFiles("bucketDefault"), true));

show_debug_message(BucketDatafileGetString("datafiles/localization/english.txt"));