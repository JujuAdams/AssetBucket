function __AbSuggestSafe(_path)
{
    var _assetName = filename_change_ext(filename_name(_path), "");
        _assetName = AbTransliterateNoSymbols(_assetName);
    return _assetName;
}