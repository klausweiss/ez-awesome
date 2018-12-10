local dispatcher = function (key, value)
   print("Setting " .. key .. " to " .. value)
end


local constants = {
   name = "config dispatcher"
}

return {dispatcher, constants}
