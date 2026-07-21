/// @param function
/// @param scope
/// @param [ownedBuffer]

function __BucketClassDeferredFunction(_function, _scope, _buffer = undefined) constructor
{
    __function = method(_scope, _function);
    __scope    = _scope;
    __buffer   = _buffer;
    
    static __Execute = function()
    {
        __function();
        __Destroy();
    }
    
    static __Destroy = function()
    {
        var _buffer = __scope[$ "__buffer"];
        if (buffer_exists(_buffer))
        {
            buffer_delete(_buffer);
            __scope.__buffer = undefined;
        }
    }
}