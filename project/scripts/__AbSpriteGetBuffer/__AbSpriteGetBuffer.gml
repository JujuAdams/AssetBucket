/// @param sprite
/// @param image

function __AbSpriteGetBuffer(_sprite, _image)
{
    var _surface = surface_create(sprite_get_width(_sprite), sprite_get_height(_sprite));
    surface_set_target(_surface);
    gpu_set_blendmode_ext(bm_one, bm_zero);
    draw_sprite(_sprite, _image, sprite_get_xoffset(_sprite), sprite_get_yoffset(_sprite));
    surface_reset_target();
    
    var _buffer = __AbSurfaceGetBuffer(_surface);
    surface_free(_surface);
    
    return _buffer;
}