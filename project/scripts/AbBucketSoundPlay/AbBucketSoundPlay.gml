/// Plays a sound from a bucket. The bucket must first have been both loaded and fetched.
/// 
/// @param soundAlias
/// @param [loop=false]

function AbBucketSoundPlay(_soundAlias, _loop = false)
{
   return audio_play_sound(AbBucketSoundGet(_soundAlias), 0, _loop);
}