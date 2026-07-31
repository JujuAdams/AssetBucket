/// @param soundAlias
/// @param [loop=false]

function AbBucketSoundPlay(_soundAlias, _loop = false)
{
   return audio_play_sound(AbBucketSoundGet(_soundAlias), 0, _loop);
}