---
--- Created by Aurif.
--- DateTime: 04/02/2025 21:33
---

---@class ABC.VARS.Enhancement
---@field value string
---@overload fun(value: string): ABC.VARS.Enhancement
ABC.VARS.Enhancement = classABCVar()

function ABC.VARS.Enhancement:card_set(card)
    card:set_ability(G.P_CENTERS[self.value])
end

function ABC.VARS.Enhancement:card_is(card)
    return card.config.center.key == self.value
end

---@private
function ABC.VARS.Enhancement:_localize()
    return {
        text=localize{ type = 'name_text', set = 'Enhanced', key = self.value }
    }
end
