---@param name string Name of the class, for debugging purposes
function classABCVar(name)
    return class(
    function(self, value)
        self.value = value
        local meta = getmetatable(self)
        meta.__name = "ABC.Vars." .. name
        meta.__is_abc_var = true
        meta.__tostring = function ()
            return meta.__name .. "(" .. self.value .. ")"
        end
    end)
end