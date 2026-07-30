/// The constructed struct has the following public methods:
/// `.Hide()`
/// 
/// The constructed struct has the following public read-only variables:
/// `.userData`
/// `.flags`
/// `.type`
/// `.childLevel`
/// `.blendMode`
/// `.opacity`
/// `.name`
/// `.tilesetIndex`
/// `.uuid`

function __AsepriteClassLayer() constructor
{
    userData = undefined;
    
    static Hide = function()
    {
        flags = ~((~flags) | 0b0001);
    }
    
    static __Deserialize = function(_buffer, _hasUUIDs)
    {
        flags = buffer_read(_buffer, buffer_u16);
        // 1 = Visible
        // 2 = Editable
        // 4 = Lock movement
        // 8 = Background
        //16 = Prefer linked cels
        //32 = The layer group should be displayed collapsed
        //64 = The layer is a reference layer
        
        type = buffer_read(_buffer, buffer_u16);
        // 0 = Normal (image) layer
        // 1 = Group
        // 2 = Tilemap
        
        childLevel = buffer_read(_buffer, buffer_u16);
        
        buffer_seek(_buffer, buffer_seek_relative, 4); //Two ignored parameters
        
        blendMode = buffer_read(_buffer, buffer_u16);
        //Normal         = 0
        //Multiply       = 1
        //Screen         = 2
        //Overlay        = 3
        //Darken         = 4
        //Lighten        = 5
        //Color Dodge    = 6
        //Color Burn     = 7
        //Hard Light     = 8
        //Soft Light     = 9
        //Difference     = 10
        //Exclusion      = 11
        //Hue            = 12
        //Saturation     = 13
        //Color          = 14
        //Luminosity     = 15
        //Addition       = 16
        //Subtract       = 17
        //Divide         = 18
        
        opacity = buffer_read(_buffer, buffer_u8);
        buffer_seek(_buffer, buffer_seek_relative, 3); //Reserved for the future
        
        name = __AsepriteReadString(_buffer);
        
        tilesetIndex = (type == 2)? buffer_read(_buffer, buffer_u32) : undefined;
        uuid = _hasUUIDs? __AsepriteReadUUID(_buffer) : undefined;
        
        return self;
    }
}