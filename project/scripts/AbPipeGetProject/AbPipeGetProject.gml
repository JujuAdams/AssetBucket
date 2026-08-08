function AbPipeGetProject()
{
    static _builderStack = __AbSystem().__builderStack;
    
    var _builder = array_last(_builderStack);
    return (_builder == undefined)? undefined : _builder.__project;
}