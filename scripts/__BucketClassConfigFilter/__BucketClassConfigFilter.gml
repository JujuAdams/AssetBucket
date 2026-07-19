function __BucketClassConfigFilter() constructor
{
    static __Deserialize = function(_parent, _struct)
    {
        __parent = _parent;
        
        __pathMask = __BucketVariableDefault(_struct, "path", "");
        __bytes    = __BucketVariableDefaultUndefined(_struct, "size");
        
        __width  = undefined;
        __height = undefined;
        __length = undefined;
        
        if (is_instanceof(_parent, __BucketClassConfigSprites))
        {
            __BucketVariableAssertOnly(_struct, ["path", "bytes", "width", "height"]);
            __width  = __BucketVariableDefaultUndefined(_struct, "width");
            __height = __BucketVariableDefaultUndefined(_struct, "height");
        }
        else if (is_instanceof(_parent, __BucketClassConfigSounds))
        {
            __BucketVariableAssertOnly(_struct, ["path", "bytes", "length"]);
            __length = __BucketVariableDefaultUndefined(_struct, "length");
        }
        else
        {
            __BucketVariableAssertOnly(_struct, ["path", "bytes"]);
        }
        
        return self;
    }
    
    static __TestFilter = function(_processStruct, _filePath)
    {
        if (not __BucketTestStringMaskAny(_filePath, __pathMask))
        {
            return false;
        }
        
        if (__bytes != undefined)
        {
            var _fileBytes = __BucketEnsureProcessFileInfo(_processStruct, _filePath).__GetBytes();
            if (not __BucketTestNumber(_fileBytes, __bytes)) return false;
        }
        
        if (__width != undefined)
        {
            var _fileWidth = __BucketEnsureProcessFileInfo(_processStruct, _filePath).__GetWidth();
            if (not __BucketTestNumber(_fileWidth, __width)) return false;
        }
        
        if (__height != undefined)
        {
            var _fileHeight = __BucketEnsureProcessFileInfo(_processStruct, _filePath).__GetWidth();
            if (not __BucketTestNumber(_fileHeight, __height)) return false;
        }
        
        if (__length != undefined)
        {
            var _fileLength = __BucketEnsureProcessFileInfo(_processStruct, _filePath).__GetLength();
            if (not __BucketTestNumber(_fileLength, __length)) return false;
        }
        
        return true;
    }
}