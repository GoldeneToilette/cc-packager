# A tool for packaging computercraft projects and extracting them ingame. 

## Usage Packager:
1. You need [LuaJIT](https://github.com/LuaJIT/LuaJIT) and [luamin](https://github.com/mathiasbynens/luamin) to run the script. This runs outside of CC:T.
2. Run ``luajit packager.lua <input_folder> <output_path> <metadata>
3. The metadata argument should point to a .lua file. Example metadata table:
```lua
return {
    target = "server/client/whatever", -- who it is for, you can put anything in here
    version = "v0.1.2", -- program version 
    author = "john programmer", -- author
    cct = "1.113.1", -- string or a table. Describes what cc:t versions the program supports.
    unminified = {
        "src/lib/somelib.lua",
        ... -- blacklist for minifying
    },
    uncompressed = {
        "src/config/themes.json",
        ... -- blacklist for compression
    } 
}
```
Note: Additional metadata is included by the packager like a Adler32 checksum (LibDeflate) and the date. 

--- 

## Usage Extractor:
1. run ``pastebin get PwJne30Y``
2. If you have compressed files, you will need [LibDeflate](https://github.com/safeteeWow/LibDeflate) to decompress them again in-game. With it you can also perform file integrity checks using the checksum.
3. Example Usage:
```lua
local LibDeflate = require("LibDeflate")
local extractor = require("extractor")

local file = fs.open("package.lua", "rb")
local contents = file.readAll()

-- it extracts all the files and returns the metadata (like the checksum, author etc)
local metadata = extractor.extract(contents, "some/path")


-- once all the files are created, you can decompress it for usage.
file = fs.open("some/path/src/lib/somelib.lua", "wb")
contents = file.readAll()
local decompressed = LibDeflate:DecompressDeflate(contents)
-- Done!
```

Note: to avoid breaking any requires, the directory tree of the codebase is preserved. Its also recommended to have a helper function for loading compressed lua modules, or decompressing them once permanently during extraction. 