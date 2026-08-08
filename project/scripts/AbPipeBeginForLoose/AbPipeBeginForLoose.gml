/// @param bucketDirectory

function AbPipeBeginForLoose(_bucketDirectory)
{
    static _builderStack = __AbSystem().__builderStack;
    array_push(_builderStack, new __AbClassBuilder(undefined, _bucketDirectory));
}