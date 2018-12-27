return {
   extendtable = function (t1, t2) for _, v in pairs(t2) do table.insert(t1, v) end
   end,
   jointables = function (...)
      args = { ... }
      local newtable = {}
      for _, t in pairs(args) do
	 for _, v in pairs(t) do
	    table.insert(newtable, v)
	 end
      end
      return newtable
   end,
   joindicts = function (...)
      args = { ... }
      local newdict = {}
      for _, t in pairs(args) do
	 for k, v in pairs(t) do
	    newdict[k] = v
	 end
      end
      return newdict
   end,
   noop = function (...) end,
   settertable = function (setter) return setmetatable({}, {
	    __newindex = function (t, k, v) setter(k, v) end
   }) end,
   slice = function (t, a, b) newt = {} for i=a,b do table.insert(newt, t[i]) end return newt end,
}
