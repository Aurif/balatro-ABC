---
--- Created by Aurif.
--- DateTime: 14/04/2025 13:46
---

---
--- Base
---

---@class ABC.VARS.Tarot : ABC.VAR
---@field value string
---A variable class representing a tarot card.
---***
---\@*param* `value` — Key of the tarot card.
---@overload fun(value: string): ABC.VARS.Tarot
ABC.VARS.Tarot = classABCVar("Tarot")

---Returns a random tarot card from those present in the pool.
---***
---@param seed number Seed to use for rng.
---@return ABC.VARS.Tarot tag Randomly picked tag.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/protogen.lua)
function ABC.VARS.Tarot:random(seed)
    local _pool, _pool_key = get_current_pool_filtered('Tarot')
    local _card = pseudorandom_element(_pool, seed)
    return ABC.VARS.Tarot(_card)
end

---Spawns this tarot card, if there is space.
---***
---@param modifiers? (ABC.VARS.Edition)[] A list of modifiers to aplly to the spawned tarot card, like edition.
---@return SMODS.Consumable|nil tarot The card that was created, nil if there was no space.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/protogen.lua)
function ABC.VARS.Tarot:spawn(modifiers)
    local is_negative = false
    for _, mod in pairs(modifiers or {}) do
        if mod == ABC.VARS.Edition("e_negative") then
            is_negative = true
            break
        end
    end

    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit or is_negative then
        if not is_negative then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = (function()
                local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, self.value)
                for _, mod in pairs(modifiers or {}) do
                    if not mod.card_set then
                        error("Invalid modifier provided to Tarot:spawn - " .. tostring(mod) .. " is not a valid modifier")
                    end
                    mod:card_set(card)
                end

                card:add_to_deck()
                G.consumeables:emplace(card)

                if not is_negative then
                    G.GAME.consumeable_buffer = max(0, G.GAME.consumeable_buffer-1)
                end

                return true
            end)
        }))

        return card
    end
end

---@private
function ABC.VARS.Tarot:_localize()
    return {
        text=localize{ type = 'name_text', set = 'Tarot', key = self.value }
    }
end

