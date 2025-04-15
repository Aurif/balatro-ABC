---
--- Created by Aurif.
--- DateTime: 04/02/2025 21:33
---

---
--- Base
---

---@class ABC.VARS.Enhancement : ABC.VAR
---@field value string
---A variable class representing card enchancement.
---***
---\@*param* `value` — Key of the enhancement.
---@overload fun(value: string): ABC.VARS.Enhancement
ABC.VARS.Enhancement = classABCVar("Enhancement")


---Returns a random enhancement from those present in the pool.
---***
---@param seed number Seed to use for rng.
---@return ABC.VARS.Enhancement enhancement Randomly picked enhancement.
function ABC.VARS.Enhancement:random(seed)
    local _pool, _pool_key = get_current_pool_filtered('Enhanced')
    local _el = pseudorandom_element(_pool, seed)
    return ABC.VARS.Enhancement(_el)
end

---Sets enhancement of provided card to self.
---***
---@param card Card Card which will be changed.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/electrician.lua)
function ABC.VARS.Enhancement:card_set(card)
    card:set_ability(G.P_CENTERS[self.value])
end

---Checks if card's enhancement matches self (without including joker effects).
---***
---@param card Card Card to check.
---@return boolean matches True if card has this enhancement, false otherwise.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/electrician.lua)
function ABC.VARS.Enhancement:card_is_exactly(card)
    return card.config.center.key == self.value
end

---@private
function ABC.VARS.Enhancement:_localize()
    return {
        text=localize{ type = 'name_text', set = 'Enhanced', key = self.value }
    }
end
