/// The constructed struct has the following public read-only variables:
/// 
/// `.entryID`
/// `.type`
/// `.name`

function __AsepriteClassExternalFile() constructor
{
    static __Deserialize = function(_buffer)
    {
        entryID = buffer_read(_buffer, buffer_u32);
        type    = buffer_read(_buffer, buffer_u8);
        buffer_seek(_buffer, buffer_seek_relative, 7); //Reserved
        name    = __AsepriteReadString(_buffer);
    }
}