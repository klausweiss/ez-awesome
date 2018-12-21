return {
   noop = function (...) end,
   settertable = function (setter) return setmetatable({}, {__newindex = setter}) end,
}
