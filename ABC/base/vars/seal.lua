---
--- Created by Aurif.
--- DateTime: 05/03/2025 18:21
---

---
--- Base
---

---@class ABC.VARS.Seal : ABC.VAR
---@field value string
---A variable class representing a seal.
---***
---\@*param* `value` — Key of the seal.
---@overload fun(value: string): ABC.VARS.Seal
ABC.VARS.Seal = classABCVar("Seal")


---Returns a random seal from those present in the pool.
---***
---@param seed number Seed to use for rng.
---@return ABC.VARS.Seal seal Randomly picked seal.
function ABC.VARS.Seal:random(seed)
    local seal = SMODS.poll_seal({ guaranteed = true, key = tostring(seed) }):lower() .. "_seal"
    return ABC.VARS.Seal(seal)
end

---Checks if card has given seal.
---***
---@param card Card Card to check.
---@return boolean matches True if card has this seal, false otherwise.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/evil_red_seal.lua)
function ABC.VARS.Seal:card_is_exactly(card)
    return card.seal == SMODS.Seal.badge_to_key[self.value]
end

---@private
function ABC.VARS.Seal:_localize()
    return {
        text=localize(self.value, "labels"),
        extra={
            colours=G.P_SEALS[SMODS.Seal.badge_to_key[self.value]].badge_colour
        }
    }
end
