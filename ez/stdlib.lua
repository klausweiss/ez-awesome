return {
   noop = function (...) end,
   settertable = function (setter) return setmetatable({}, {
	    __newindex = function (t, k, v) setter(k, v) end
   }) end,
   extendtable = function (t1, t2) for k, v in pairs(t2) do table.insert(t1, v) end end,
}
