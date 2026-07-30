function __AsepriteReadUserData(_buffer)
{
    var _userDataStruct = new __AsepriteClassUserData();
    _userDataStruct.__Deserialize(_buffer);
    return _userDataStruct;
}