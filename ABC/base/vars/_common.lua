ABC.VARS = {}

---@class ABC.VAR
__ABC.VAR = class()

---@param name string Name of the class, for debugging purposes
function classABCVar(name)
    return class(
    function(self, value)
        local meta = getmetatable(self)
        if meta.__parse then
            self.value = self:__parse(value)
        else
            self.value = value
        end
        meta.__name = "ABC.VARS." .. name
        meta.__is_abc_var = true
        meta.__tostring = function (slf)
            return getmetatable(slf).__name .. "(" .. slf.value .. ")"
        end
        meta.__eq = function(a, b)
            local am = getmetatable(a)
            local bm = getmetatable(b)
            if not bm.__is_abc_var or am.__name ~= bm.__name then
                return false
            end
            return a.value == b.value
        end
    end)
end