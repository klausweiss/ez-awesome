-- add /ez/ subdirectory to the library load path
local _, this_path = ...
local dir_path = this_path:match(".*/")
package.path = (";"
		   .. package.path .. ";"
		   .. dir_path .. "?.lua;"
		   .. dir_path .. "ez/init.lua;"
	       )

return require("ez")
