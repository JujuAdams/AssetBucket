#macro ASEPRITE_READER_VERSION  "1.0.0"
#macro ASEPRITE_READER_DATE     "2026-07-30"

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