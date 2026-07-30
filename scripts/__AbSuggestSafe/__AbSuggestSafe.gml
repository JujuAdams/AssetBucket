function __AbSuggestSafe(_path)
{
    var _assetName = filename_change_ext(filename_name(_path), "");
        _assetName = AsciiTransliterateNoSymbols(_assetName);
    return _assetName;
}