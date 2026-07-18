function __BucketSaveString(_string, _path)
{
    static _buffer = buffer_create(1024, buffer_grow, 1);
    
    buffer_seek(_buffer, buffer_seek_start, 0);
    buffer_write(_buffer, buffer_text, _string);
    
    buffer_save_ext(_buffer, _path, 0, buffer_tell(_buffer));
}