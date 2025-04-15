---
--- Created by Aurif.
--- DateTime: 15/03/2025 23:11
---

---
--- Base
---

---@class ABC.VARS.Rarity : ABC.VAR
---@field value string
---A variable class representing a rarity.
---***
---\@*param* `value` — Key of the rarity.
---@overload fun(value: string): ABC.VARS.Rarity
ABC.VARS.Rarity = classABCVar("Rarity")

---Returns a random joker rarity from those present in the shop pool.
---All rarities are equally likely to be chosen.
---***
---@param seed number Seed to use for rng.
---@return ABC.VARS.Rarity rarity Randomly picked rarity.
function ABC.VARS.Rarity:random(seed)
    local _pool = SMODS.ObjectTypes["Joker"].rarities
    local _el = pseudorandom_element(_pool, seed).key
    return ABC.VARS.Rarity(_el)
end

---Returns a random joker from this rarity.
---***
---@param seed number Seed to use for rng.
---@return ABC.VARS.Joker joker Randomly picked joker.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/placeholder_joker.lua)
function ABC.VARS.Rarity:random_joker(seed)
    local _pool, _pool_key = get_current_pool_filtered('Joker', self.value)
    local _joker = pseudorandom_element(_pool, seed)
    return ABC.VARS.Joker(_joker)
end


---@private
function ABC.VARS.Rarity:_localize()
    return {
        text=localize("k_"..self.value:lower()),
        extra={
            colours=G.C.RARITY[self.value]
        }
    }
end
