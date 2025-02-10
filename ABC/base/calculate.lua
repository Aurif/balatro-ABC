---
--- Created by Aurif.
--- DateTime: 05/02/2025 22:22
---

---@class ABC.CalculateUtilJoker
local CalculateUtilJoker = class()
ABC._CalculateUtilJoker = CalculateUtilJoker

function ABC._CalculateUtilJoker:__init__(joker_card, context, joker_definition)
    self.joker_card = joker_card
    self.context = context
    self.joker_definition = joker_definition
end

function ABC._CalculateUtilJoker:var_get(varname)
    if self.joker_card.ability.extra[varname] == nil then
        error("Joker " .. self.joker_definition.meta.full_name .. " tried reading invalid variable '" .. varname .. "'")
    end
    if self.joker_definition.meta.var_wrappers[varname] then
        return self.joker_definition.meta.var_wrappers[varname](self.joker_card.ability.extra[varname])
    end
    return self.joker_card.ability.extra[varname]
end