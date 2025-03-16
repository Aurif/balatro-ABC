---
--- Created by Aurif.
--- DateTime: 02/03/2025 03:50
---

---
--- Base
---

---@class ABC.VARS.Joker : ABC.VAR
---@field value string
---A variable class representing a joker.\
---If you want to create your own joker, use [ABC.Joker](https://github.com/Aurif/balatro-ABC/wiki/Joker) instead.
---***
---\@*param* `value` — Key of the joker.
---@overload fun(value: string): ABC.VARS.Joker
ABC.VARS.Joker = classABCVar("Joker")

---Spawns this joker, if there is space.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/placeholder_joker.lua)
function ABC.VARS.Joker:spawn()
    local joker_count = 0
    for _, v in pairs(G.jokers.cards) do
        if not v.getting_sliced then
            joker_count = joker_count + 1
        end
    end

    if joker_count < G.jokers.config.card_limit then
        play_sound('timpani')
        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, self.value)
        card:add_to_deck()
        G.jokers:emplace(card)
    else
        card_eval_status_text(G.jokers, 'extra', nil, nil, nil, { message = localize("k_no_room_ex") })
    end
end

---Checks if joker has been discovered.
---***
---@return boolean is_discovered True if joker has been discovered.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yang.lua)
function ABC.VARS.Joker:is_discovered()
    return G.P_CENTERS[self.value].discovered
end

---@private
function ABC.VARS.Joker:_localize()
    return {
        text=localize{ type = 'name_text', set = 'Joker', key = self.value }
    }
end
