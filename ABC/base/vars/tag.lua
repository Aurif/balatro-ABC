---
--- Created by Aurif.
--- DateTime: 27/02/2025 21:37
---

---
--- Base
---

---@class ABC.VARS.Tag : ABC.VAR
---@field value string
---A variable class representing a tag.
---***
---\@*param* `value` — Key of the tag.
---@overload fun(value: string): ABC.VARS.Tag
ABC.VARS.Tag = classABCVar("Tag")


---Returns a random tag from those present in the pool.
---***
---@param seed number Seed to use for rng.
---@return ABC.VARS.Tag tag Randomly picked tag.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/anaglyph_joker.lua)
function ABC.VARS.Tag:random(seed)
    local _pool, _pool_key = get_current_pool('Tag')
    local _real_pool = {}
    for k, v in pairs(_pool) do
        if v ~= "UNAVAILABLE" then
            table.insert(_real_pool, v)
        end
    end
    local _tag = pseudorandom_element(_real_pool, seed)
    return ABC.VARS.Tag(_tag)
end

---Gives this tag to the player.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/voucher_joker.lua)
function ABC.VARS.Tag:spawn()
    add_tag(Tag(self.value))
    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
end

---@private
function ABC.VARS.Tag:_localize()
    return {
        text=localize{ type = 'name_text', set = 'Tag', key = self.value }
    }
end

