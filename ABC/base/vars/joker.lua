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
---@overload fun(value: string|SMODS.Joker): ABC.VARS.Joker
ABC.VARS.Joker = classABCVar("Joker")


---Returns a random joker from those present in the pool.
---***
---@param seed number Seed to use for rng.
---@return ABC.VARS.Joker joker Randomly picked joker.
function ABC.VARS.Joker:random(seed)
    local _pool, _pool_key = get_current_pool_filtered('Joker')
    local _el = pseudorandom_element(_pool, seed)
    return ABC.VARS.Joker(_el)
end

---@private
function ABC.VARS.Joker:__parse(value)
    if type(value) ~= "table" then
        return value
    end
    if value.config and value.config.center and value.config.center.key then
        return value.config.center.key
    end
end

---Spawns this joker, if there is space.
---***
---@param modifiers? (ABC.VARS.Edition|ABC.VARS.Sticker)[] A list of modifiers to aplly to the spawned joker, like edition or sticker.
---@return SMODS.Joker|nil joker The joker that was created, nil if there was no space.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/emicare_camera.lua)
function ABC.VARS.Joker:spawn(modifiers)
    local joker_count = 0
    for _, v in pairs(G.jokers.cards) do
        if not v.getting_sliced then
            joker_count = joker_count + 1
        else
            joker_count = joker_count + ((v.edition and v.edition.card_limit) or 0)
        end
    end

    local is_negative = false
    for _, mod in pairs(modifiers or {}) do
        if mod == ABC.VARS.Edition("e_negative") then
            is_negative = true
            break
        end
    end

    if joker_count < G.jokers.config.card_limit or is_negative then
        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, self.value)
        for _, mod in pairs(modifiers or {}) do
            if not mod.card_set then
                error("Invalid modifier provided to Joker:spawn - " .. tostring(mod) .. " is not a valid modifier")
            end
            mod:card_set(card)
        end

        play_sound('timpani')
        card:add_to_deck()
        G.jokers:emplace(card)

        return card
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
