---
--- Created by Aurif.
--- DateTime: 04/02/2025 21:33
---

ABC.VARS.Enhancement = {}

function ABC.VARS.Enhancement:new(value)
    local o = { value = value }
    setmetatable(o, self)
    self.__index = self
    return o
end

function ABC.VARS.Enhancement:_localize()
    return {
        text=localize{ type = 'name_text', set = 'Enhanced', key = self.value }
    }
end

function ABC.VARS.Enhancement:card_set(card)
    card:set_ability(G.P_CENTERS[self.value])
end