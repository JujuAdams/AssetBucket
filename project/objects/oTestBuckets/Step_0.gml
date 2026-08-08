if (keyboard_check_pressed(vk_f5))
{
    AbBucketLoadAndFetchFromManifest(AbGetIncludedFilesPath(AB_MANIFEST_FILENAME));
    AbBucketTextureGroupsFetch("bucketDefault");
}