function __AsepriteReadImageBuffer(_sourceBuffer, _count, _colorDepth)
{
    if (_colorDepth == 32) //RGBA
    {
        var _outputBuffer = buffer_create(4*_count, buffer_fixed, 1);
        
        buffer_copy(_sourceBuffer, buffer_tell(_sourceBuffer), 4*_count, _outputBuffer, 0);
        buffer_seek(_sourceBuffer, buffer_seek_relative, 4*_count);
    }
    else if (_colorDepth == 16) //Greyscale (value, alpha)
    {
        var _outputBuffer = buffer_create(4*_count, buffer_fixed, 1);
        
        var _bufferStart = buffer_tell(_sourceBuffer);
        buffer_copy_stride(_sourceBuffer, _bufferStart+1, 1, 2, _count, _outputBuffer, 0, 4);
        buffer_copy_stride(_sourceBuffer, _bufferStart,   1, 2, _count, _outputBuffer, 1, 4);
        buffer_copy_stride(_sourceBuffer, _bufferStart,   1, 2, _count, _outputBuffer, 2, 4);
        buffer_copy_stride(_sourceBuffer, _bufferStart,   1, 2, _count, _outputBuffer, 3, 4);
        
        buffer_seek(_sourceBuffer, buffer_seek_relative, 2*_count);
    }
    else if (_colorDepth == 8) //Palette
    {
        var _outputBuffer = buffer_create(_count, buffer_fixed, 1);
        
        buffer_copy(_sourceBuffer, buffer_tell(_sourceBuffer), _count, _outputBuffer, 0);
        buffer_seek(_sourceBuffer, buffer_seek_relative, _count);
    }
    
    return _outputBuffer;
}