return {
   noop = function (...) end,
   settertable = function (setter) return setmetatable({}, {
	    __newindex = function (t, k, v) setter(k, v) end
   }) end,
   extendtable = function (t1, t2) for _, v in pairs(t2) do table.insert(t1, v) end end,
   slice = function (t, a, b) newt = {} for i=a,b do table.insert(newt, t[i]) end return newt end,
}
