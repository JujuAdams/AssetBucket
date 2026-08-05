function __AbStringifyYYFolderPath(_yyPath)
{
    if (string_copy(_yyPath, 1, 8) == "folders/")
    {
        var _folder = string_delete(_yyPath, 1, 8);
        
        if (string_copy(_yyPath, string_length(_yyPath)-2, 3) == ".yy")
        {
            _folder = string_copy(_folder, 1, string_length(_folder)-3);
        }
    }
    else
    {
        _folder = "";
    }
    
    return _folder;
}