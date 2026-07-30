/// The constructed struct has the following public read-only variables:
/// `.userData`
/// `.fromFrame`
/// `.toFrame`
/// `.loopDirection`
/// `.repeats`
/// `.name`

function __AsepriteClassTag() constructor
{
    userData = undefined;
    
    fromFrame     = undefined;
    toFrame       = undefined;
    loopDirection = undefined;
    repeats       = undefined;
    name          = undefined;
    
    static __Deserialize = function(_buffer, _fileStruct)
    {
        fromFrame     = buffer_read(_buffer, buffer_u16);
        toFrame       = buffer_read(_buffer, buffer_u16);
        loopDirection = buffer_read(_buffer, buffer_u8);
        // 0 = Forward
        // 1 = Reverse
        // 2 = Ping-pong
        // 3 = Ping-pong Reverse
        
        repeats = buffer_read(_buffer, buffer_u16);
        // 0 = Doesn't specify (plays infinite in UI, once on export,
        //     for ping-pong it plays once in each direction)
        // 1 = Plays once (for ping-pong, it plays just in one direction)
        // 2 = Plays twice (for ping-pong, it plays once in one direction,
        //     and once in reverse)
        // n = Plays N times
        
        buffer_seek(_buffer, buffer_seek_relative, 6); //Reserved
        buffer_seek(_buffer, buffer_seek_relative, 3); //Deprecated tag colour
        buffer_seek(_buffer, buffer_seek_relative, 1); //Reserved
        
        name = __AsepriteReadString(_buffer);
        
        return self;
    }
}