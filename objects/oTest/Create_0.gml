BucketIngest();
BucketInitialize();

BucketLoad("bucketDefault");
texturegroup_load("bucketDefault");

show_debug_message(BucketDatafileGetString("datafiles/localization/english.txt"));