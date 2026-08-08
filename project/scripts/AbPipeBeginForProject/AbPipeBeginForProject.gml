/// @param projectStruct

function AbPipeBeginForProject(_projectStruct)
{
    static _builderStack = __AbSystem().__builderStack;
    array_push(_builderStack, new __AbClassBuilder(_projectStruct, _projectStruct.__datafilesDirectory));
}