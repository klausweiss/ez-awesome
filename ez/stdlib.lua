return {
   defaulttable = function (default)
      return setmetatable({}, {
	    __index = function (t, k)
	       v = rawget(t, k)
	       if not v then
		  v = default(k)
		  t[k] = v
	       end
	       return v
	    end,
      })
   end,

   expandhome = function (path)
      if path:sub(1, 1) == "~" then
	 return os.getenv("HOME") .. path:sub(2)
      end
      return path
   end,

   extendtable = function (t1, t2) for _, v in pairs(t2) do table.insert(t1, v) end
   end,

   fileexists = function (path)
      local f = io.open(path)
      if f then f:close() end
      return f and true or false
   end,

   getter = function (table_)
      return function (key)
	 return table_[key]
      end
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

   keys = function (table_)
      local keys = {}
      for k, _ in pairs(table_) do keys[k] = k end
      return keys
   end,

   map = function (f, table_)
      local new_table = {}
      for k, v in pairs(table_) do
	 new_table[k] = f(v)
      end
      return new_table
   end,

   noop = function (...) end,

   settertable = function (setter) return setmetatable({}, {
	    __newindex = function (t, k, v) setter(k, v) end
   }) end,

   slice = function (t, a, b) newt = {} for i=a,b do table.insert(newt, t[i]) end return newt
	   end,

   tablefactory = function () return {} end,
}
