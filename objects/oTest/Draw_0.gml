if (texturegroup_exists("bucketDefault") && (texturegroup_get_status("bucketDefault") == texturegroup_status_fetched))
{
    draw_sprite(asset_get_index("test"), -1, 10, 10);
}