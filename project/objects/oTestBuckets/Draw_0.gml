if (texturegroup_exists("bucketDefault") && (texturegroup_get_status("bucketDefault") == texturegroup_status_fetched))
{
    draw_sprite(asset_get_index("test"), -1, 10, 10);
    draw_sprite_ext(asset_get_index("slice_Nineslice"), -1, 10, 520, 10, 2, 0, c_white, 1);
}