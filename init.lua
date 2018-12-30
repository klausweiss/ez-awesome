-- add /ez/ subdirectory to the library load path
local this_name, this_path = ...

if not __ez_modified_path then
    local dir_path = this_path:match(".*/")
    package.path = (";"
               .. package.path .. ";"
               .. dir_path .. "?.lua;"
               .. dir_path .. "ez/init.lua;"
               )
    __ez_modified_path = true
end

return require(this_name .. ".ez")
