if (keyboard_check_pressed(vk_f5))
{
    BucketIngest();
    BucketLoadManifest();
    
    BucketLoad("bucketDefault");
    texturegroup_load("bucketDefault");
    
    show_debug_message(BucketDatafileGetString("datafiles/localization/english.txt"));
}

if (keyboard_check_pressed(vk_backspace))
{
    BucketUnload("bucketDefault");
}