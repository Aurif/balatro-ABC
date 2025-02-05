---
--- Created by Aurif.
--- DateTime: 05/02/2025 22:22
---

ABC._CalculateUtilJoker = {}

function ABC._CalculateUtilJoker:new(joker_card, context, joker_definition)
    local o = {
        joker_card = joker_card,
        context = context,
        joker_definition = joker_definition
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function ABC._CalculateUtilJoker:var_get(varname)
    if self.joker_card.ability.extra[varname] == nil then
        error("Joker " .. self.joker_definition.meta.full_name .. " tried reading invalid variable '" .. varname .. "'")
    end
    if self.joker_definition.meta.var_wrappers[varname] then
        return self.joker_definition.meta.var_wrappers[varname]:new(self.joker_card.ability.extra[varname])
    end
    return self.joker_card.ability.extra[varname]
end