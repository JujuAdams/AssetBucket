if (keyboard_check_pressed(vk_f5))
{
    BucketIngest();
    BucketInitialize();
    
    show_debug_message(BucketDatafileGetString("datafiles/localization/english.txt"));
}