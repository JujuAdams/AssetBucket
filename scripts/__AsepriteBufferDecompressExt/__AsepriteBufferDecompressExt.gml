function __AsepriteBufferDecompressExt(_buffer, _start, _end)
{
	var _size = _end - _start;
	var _compressedBuffer = buffer_create(_size, buffer_fixed, 1);
	buffer_copy(_buffer, _start, _end - _start, _compressedBuffer, 0);
	var _decompressedBuffer = buffer_decompress(_compressedBuffer);
	buffer_delete(_compressedBuffer);
	return _decompressedBuffer;
}