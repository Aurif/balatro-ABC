---
--- Created by Aurif.
--- DateTime: 28/03/2025 19:04
---

---
--- Base
---

---@class ABC.VARS.Edition : ABC.VAR
---@field value string
---A variable class representing card edition.
---***
---\@*param* `value` — Key of the edition.
---@overload fun(value: string): ABC.VARS.Edition
ABC.VARS.Edition = classABCVar("Edition")

---Returns a random edition from those present in the pool.
---***
---@param seed number Seed to use for rng.
---@return ABC.VARS.Edition edition Randomly picked edition.
function ABC.VARS.Edition:random(seed)
    local _pool, _pool_key = get_current_pool_filtered('Edition')
    local _el = pseudorandom_element(_pool, seed)
    return ABC.VARS.Edition(_el)
end

---Sets edition of provided card to self.
---***
---@param card Card|SMODS.Joker Card which will be changed.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/emicare_camera.lua)
function ABC.VARS.Edition:card_set(card)
    card:set_edition(self.value)
end


---@private
function ABC.VARS.Edition:_localize()
    return {
        text=localize{ type = 'name_text', set = 'Edition', key = self.value },
        info_queue=G.P_CENTERS[self.value]
    }
end
