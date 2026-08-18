# AssetBucket

AssetBucket is a scriptable asset manager for GameMaker. It has three modes which can be used together or separately:

1. Automated asset importer for datafiles, sounds, and sprites
2. Runtime texture packing
3. Custom asset compiler

> [!NOTE]
> AssetBucket is currently in development. This introduction is incomplete.

&nbsp;

## Existing Flaws

When a GameMaker game is built, the majority of the time taken is reviewing and repacking assets. Sounds and sprites take the most time. Sounds generally have large filesizes and may need recompressing. Sprites are often numerous and require repacking onto textures (repacking is a variation of the knapsack problem and is thus computationally expensive).

Furthermore, GameMaker assets must exist in the project directory itself. Project assets must be added to the GameMaker project via the IDE. For example, to add audio to your game you must add the audio file as a "sound asset" which causes GameMaker to create a copy of the source audio file in the project alongside some metadata (compression settings, mono/stereo, etc.). Manually adding files to the IDE is time-consuming especially when you are unconcerned with tuning fine details as is often the case for sound effects and textures for use in 3D.

GameMaker also doesn't support "asset packs" where a player can download additional assets that are displayable in the game. This is important for DLC and modding sprites and sounds. The mentality of GameMaker developers is typically to pack all that content in the project and then turn it off and on using DLC checks. This has a lot of downsides. It leads to inflated file sizes, poor management of patch sizes, and isn't helpful for modding sprites and sounds.

GameMaker's asset management is clumsy. AssetBucket seeks to fix these problems.

&nbsp;

## Runtime Texture Packing

> [!NOTE]
> This section will be filled out at a later date.

1. Create a project struct by calling `new AbProject(...)`
2. Call `AbPipeBeginForProject()`
3. Call `AbPipeProjectSprite()` or `AbPipeProjectSound()` or `AbPipeProjectDatafile()` to add content to your project
4. To make it easier in ingest files from disk, use `AbForeachFile()` or `AbForeachFileFiltered()` to iterate over particular directories
5. Call `AbPipeEnd()`. This will finalise the changes and start saving content to the project files on disk

See `oTestImport` in the repo project for an example of use.

&nbsp;

## Automated Asset Importer

> [!NOTE]
> This section will be filled out at a later date.

1. Create an array of packable sprite structs by calling `new AbPackableSprite(...)`
2. Call `AbPackSprites()` using that array
3. Using the returned struct, call `texturegroup_add()`

Please see notes in documentation for `AbPackableSprite` `AbPackSprites` for more details.

&nbsp;

## Custom Asset Compiler

> [!NOTE]
> This section will be filled out at a later date.

When compiling assets, GameMaker builds a file that the game executable reads. If you look at a compiled Windows game made with GameMaker you'll see a `data.win` file which is where most game content is stored.  AssetBucket has its own data storage format that's optimised for fast loading. These are called "buckets".

Buckets can store sprites, .wav sounds, .ogg sounds, and generic datafiles.

1. Create a project struct by calling `new AbProject(...)`
2. Call `AbPipeBeginForProject()`
3. Call `AbPipeBucketSprite()` or `AbPipeBucketSound()` or `AbPipeBucketDatafile()` to add content to a bucket in your project
4. To make it easier in ingest files from disk, use `AbForeachFile()` or `AbForeachFileFiltered()` to iterate over particular directories
5. Call `AbPipeEnd()`. This will finalise the changes and start saving content to the project files on disk

See `oTestBuckets` in the repo project for an example of use.

### Bucket Structure

Buckets are made from a single "header" JSON file that describes the bucket's contents and then one or more binary blob files that contains the raw data. There will always be one binary blob file which is called the "core" file.

- The header contains the contents of the bucket as a plaintext JSON. This includes the names of datafiles, the names of sounds and their format (.wav or .ogg), and the names and properites of sprites

- The core binary blob contains all datafiles and .wav sounds. The core blob itself contains no layout information and is pure appended data. The blob layout is stored in the header JSON

- Separate binary blob files will be created for each sprite texture page and for each .ogg sound

The name of the header JSON is named `ab_<xyz>.json` where `<xyz>` is the name of the bucket specified when calling `AbPipeBucketSprite()` etc.  Each binary blob file will be called `ab_<hash>_<index>.json` where `<hash>` is the MD5 hash of the bucket name and `<index>` is the zero-indexed ordinal number of the blob.