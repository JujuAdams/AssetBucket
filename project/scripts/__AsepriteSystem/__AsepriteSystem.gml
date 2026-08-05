#macro ASEPRITE_READER_VERSION  "0.0.2"
#macro ASEPRITE_READER_DATE     "2026-08-05"

#macro __ASEPRITE_BUFFER_BYTE    buffer_u8
#macro __ASEPRITE_BUFFER_WORD    buffer_u16
#macro __ASEPRITE_BUFFER_SHORT   buffer_s16
#macro __ASEPRITE_BUFFER_DWORD   buffer_u32
#macro __ASEPRITE_BUFFER_LONG    buffer_s32
#macro __ASEPRITE_BUFFER_FLOAT   buffer_f32
#macro __ASEPRITE_BUFFER_DOUBLE  buffer_f64
#macro __ASEPRITE_BUFFER_QWORD   buffer_u64
#macro __ASEPRITE_BUFFER_LONG64  buffer_u64

function __AsepriteSystem()
{
    static _once = (function()
    {
        with({})
        {
            __AsepriteTrace($"Welcome to Aseprite Reader by Juju Adams! This is version {ASEPRITE_READER_VERSION}, {ASEPRITE_READER_DATE}");
            
            __writePaletteIndex  = 0;
            __userDataToTagIndex = 0;
            
            return self;
        }
    })();
    
    return _once;
}