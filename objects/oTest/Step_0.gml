if (keyboard_check_pressed(vk_f5))
{
    AbLoad("bucketDefault");
    texturegroup_load("bucketDefault");
    
    show_debug_message(AbDatafileGetString("datafiles/localization/english.txt"));
}

if (keyboard_check_pressed(vk_backspace))
{
    AbUnload("bucketDefault");
}