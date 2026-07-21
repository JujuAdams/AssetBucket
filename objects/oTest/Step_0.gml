if (keyboard_check_pressed(vk_f5))
{
    BucketIngest();
    BucketInitialize();
}

if (keyboard_check_pressed(vk_space))
{
    BucketPlaySound("sounds/snd1KHz/snd1KHz.wav");
}