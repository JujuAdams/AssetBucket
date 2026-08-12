/// @param sourceOrArray

function __AbSourceIngest(_sourceOrArray)
{
    var _sourceArray = __AbEnsureArray(_sourceOrArray);
    
    var _i = array_length(_sourceArray)-1;
    repeat(_i+1)
    {
        var _source = _sourceArray[_i];
        if (is_handle(_source) && sprite_exists(_source))
        {
            if (sprite_get_number(_source) > 1)
            {
                array_delete(_sourceArray, _i, 1);
                
                var _j = sprite_get_number(_source)-1;
                repeat(_j+1)
                {
                    array_insert(_sourceArray, _i, new __AbClassSpriteImage(_source, _j));
                    --_j;
                }
            }
        }
        
        --_i;
    }
    
    return _sourceArray;
}