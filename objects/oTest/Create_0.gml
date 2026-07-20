BucketIngest();
BucketInitialize();

BucketDatafilesLoad("bucketTest");
show_debug_message(json_stringify(BucketDatafilesGetFiles("bucketTest"), true));

show_debug_message(BucketDatafileGetString("localization/english.txt"));
sprite = BucketDatafileGetSprite("sprites/docs/DocsAnchor.png", 500, 500);