BucketInitialize();
BucketIngest();
BucketDatafilesLoad("bucketBackgrounds");
show_debug_message(json_stringify(BucketDatafileGetRef("localization/english.txt"), true));