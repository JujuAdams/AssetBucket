function __BucketClassConfigRoot() constructor
{
    static __Collect = function()
    {
        //Remove files that look like frames of sprites
        var _fileArray = [];
        var _i = 0;
        for(var _i = 0; _i < array_length(_localPathArray); _i++)
        {
            var _localPath = _localPathArray[_i];
            if (__BucketTestStringMask(_localPath, "*_frame0.*"))
            {
                var _framesPathArray = __BucketFindSpriteFrames(_rootDirectory, _localPath);
                
                var _j = 0;
                repeat(array_length(_framesPathArray))
                {
                    var _index = array_get_index(_localPathArray, _framesPathArray[_j]);
                    if (_index >= 0) array_delete(_localPathArray, _index, 1);
                    ++_j;
                }
                
                var _spriteName = filename_change_ext(string_replace_all(filename_name(_localPath), "_frame0.", "."), "");
                array_push(_fileArray, new __BucketClassFile(_spriteName, _framesPathArray));
            }
            else
            {
                var _spriteName = filename_change_ext(filename_name(_localPath), "");
                array_push(_fileArray, new __BucketClassFile(_spriteName, _localPath));
            }
            
            --_i;
        }
        
        //Build buckets
        var _bucketsArray = __bucketsArray;
        var _i = 0;
        repeat(array_length(_bucketsArray))
        {
            _bucketsArray[_i].__Build();
            ++_i;
        }
        
        //Execute tasks
        var _tasksArray = __tasksArray;
        var _i = 0;
        repeat(array_length(_tasksArray))
        {
            _tasksArray[_i].__Execute(_fileArray);
            ++_i;
        }
    }
}