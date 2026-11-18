local extractor = {}

-- in case the extractor is included within a package and non-compressed/minified
local seperator = "%-%-%[%[__" .. "BLOB" .. "_START__%]%]%-%-"

-- package file should be read in binary mode
function extractor.extract(str, output)
    local split_start, split_end = str:find(seperator)
    local lua_part = str:sub(1, split_start - 1)
    local blob = str:sub(split_end + 1)
    local chunk, err = load(lua_part, "tbl", "t", _G)
    if not chunk then error("failed to extract package:" .. tostring(err)) end
    local package = chunk()
    local indexed = {}
    for k,v in pairs(package.files) do
        indexed[v.index + 1] = {info = v, path = k}
    end
    local pos = 1
    for i = 1, #indexed do
        local entry = indexed[i]
        if entry then
            local v,k = entry.info, entry.path
            local file_path = output .. "/" .. k
            local dir = file_path:match("(.*/)")
            if dir then fs.makeDir(dir) end

            local f = fs.open(file_path, "wb")
            if v.compression then
                f.write(v.str) 
            else
                f.write(blob:sub(pos + 1, pos + v.length))
                pos = pos + v.length
            end
            f.close()
        end
    end
end

return extractor