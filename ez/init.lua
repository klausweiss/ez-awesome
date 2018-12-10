local dispatcher = require("ez.dispatcher")
local config_dispatcher = require("ez.config_dispatcher")

local config_setter = dispatcher(config_dispatcher)

return config_setter
