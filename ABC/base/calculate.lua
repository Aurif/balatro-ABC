---
--- Created by Aurif.
--- DateTime: 05/02/2025 22:22
---

---@class ABC.CalculateUtilJoker
---@field private joker_card any
---@field private context any
---@field private joker_definition any
ABC._CalculateUtilJoker = class()


---@private
function ABC._CalculateUtilJoker:__init__(joker_card, context, joker_definition)
    self.joker_card = joker_card
    self.context = context
    self.joker_definition = joker_definition
    self:_init_vars()
end

---@private
function ABC._CalculateUtilJoker:_init_vars()
    -- Using getters and setters instead of function calls to trick autocompletion into working
    local vars_meta = {}
    vars_meta.__index = function(_, varname)
        if self.joker_card.ability.extra[varname] == nil then
            error("Joker " ..
            self.joker_definition.meta.full_name .. " tried reading invalid variable '" .. varname .. "'")
        end
        if self.joker_definition.meta.var_wrappers[varname] then
            return self.joker_definition.meta.var_wrappers[varname](self.joker_card.ability.extra[varname])
        end
        return self.joker_card.ability.extra[varname]
    end

    self.vars = {}
    setmetatable(self.vars, vars_meta)
end