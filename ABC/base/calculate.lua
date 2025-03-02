---
--- Created by Aurif.
--- DateTime: 05/02/2025 22:22
---

---
--- Base
---

---@class ABC.CalculateUtil
---@field vars any Allows access to joker's variables.<br/>This is a table-like property, variables can be read with `ABCU.vars.suit` and set with `ABCU.vars.suit = ...`.
---@field private joker_self any
---@field private joker_card any
---@field private context any
---@field private joker_definition any
---@overload fun(joker_self, joker_card, context, joker_definition): ABC.CalculateUtil private
__ABC.CalculateUtil = class()

---
--- Events - round stages
---

--- Triggers at the beggining of a round.
--- @param callback fun(): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/checkered_joker.lua)
function __ABC.CalculateUtil:on_round_start(callback)
    if self.context.setting_blind and not self.joker_self.getting_sliced then
        return self:_set_return_value(callback())
    end
end

--- Triggers at the end of a round.
--- @param callback fun(): nil Callback to execute
function __ABC.CalculateUtil:on_round_end(callback)
    if self.context.end_of_round and not (self.context.individual or self.context.repetition) then
        return self:_set_return_value(callback())
    end
end

--- Triggers after a boss blind is defeated.
--- @param callback fun(): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/voucher_joker.lua)
function __ABC.CalculateUtil:on_round_boss_defeated(callback)
    if self.context.end_of_round and not (self.context.individual or self.context.repetition) and G.GAME.blind.boss then
        return self:_set_return_value(callback())
    end
end

--- Triggers during dollar bonus calculation after a blind is defeated.\
--- Return value determines dollar bonus from this joker.
--- @param callback fun(): integer Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/many_jokers.lua)
function __ABC.CalculateUtil:on_dollar_bonus(callback)
    if self.context.calc_dollar_bonus then
        return self:_set_return_value(callback())
    end
end

---
--- Events - cards
---

--- Triggers for each scored card during scoring.\
--- This is where card-based chips and mult bonuses can be done.
--- @param callback fun(scored_card: Card): nil Callback to execute for each card
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/checkered_joker.lua)
function __ABC.CalculateUtil:on_card_scored(callback)
    if self.context.individual and self.context.cardarea == G.play then
        return self:_set_return_value(callback(self.context.other_card))
    end
end

--- Triggers for each scored card after hand has been scored.\
--- This is where card modifications should be done.
--- @param callback fun(scored_card: Card): nil Callback to execute for each card
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yin.lua)
function __ABC.CalculateUtil:on_card_post_scored(callback)
    if self.context.after and self.context.scoring_hand and not self.context.blueprint then
        for i = 1, #self.context.scoring_hand do
            callback(self.context.scoring_hand[i])
        end
    end
end

---
--- Events - others
---

--- Triggers after player exits shop and enters blind selection.
--- @param callback fun(): nil Callback to execute
function __ABC.CalculateUtil:on_shop_exit(callback)
    if self.context.ending_shop then
        return self:_set_return_value(callback())
    end
end

--- Triggers when player skips a blind.
--- @param callback fun(): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/anaglyph_joker.lua)
function __ABC.CalculateUtil:on_blind_skipped(callback)
    if self.context.skip_blind then
        return self:_set_return_value(callback())
    end
end

---
--- Conditionals
---

--- Checks if this is the first hand of round.
--- @return boolean is_first_hand True if this is the first hand of round.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yin.lua)
function __ABC.CalculateUtil:is_hand_first()
    return G.GAME.current_round.hands_played == 0
end

--- Checks if this is the final hand of round.
--- @return boolean is_final_hand True if this is the final hand of round.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yang.lua)
function __ABC.CalculateUtil:is_hand_final()
    return G.GAME.current_round.hands_left == 0
end

---
--- Effects
---

--- Scores a given amount of chips.
--- @param chips integer Amount of chips to score.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yin.lua)
function __ABC.CalculateUtil:do_chips_add(chips)
    self:_set_return_table_prop("chips", chips)
    self:_set_return_table_prop("card", self.joker_card)
end

--- Scores a given amount of mult.
--- @param mult integer Amount of mult to score.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yang.lua)
function __ABC.CalculateUtil:do_mult_add(mult)
    self:_set_return_table_prop("mult", mult)
    self:_set_return_table_prop("card", self.joker_card)
end

---
--- Internal
---

---@private
function __ABC.CalculateUtil:__init__(joker_self, joker_card, context, joker_definition)
    self.joker_self = joker_self
    self.joker_card = joker_card
    self.context = context
    self.joker_definition = joker_definition
    self:_init_vars()
end

---@private
function __ABC.CalculateUtil:_init_vars()
    -- Using getters and setters instead of function calls to trick autocompletion into working
    local vars_meta = {}
    vars_meta.__index = function(_, varname)
        if self.joker_card.ability.extra[varname] == nil then
            error("Joker " ..
                self.joker_definition.meta.full_name .. " tried reading invalid variable '" .. varname .. "'")
        end
        if self.joker_definition.meta.var_wrappers[varname] then
            return self.joker_definition.meta.var_wrappers[varname](self.joker_card.ability.extra[varname])
        end
        return self.joker_card.ability.extra[varname]
    end
    vars_meta.__newindex = function(_, varname, value)
        if self.joker_card.ability.extra[varname] == nil then
            error("Joker " ..
                self.joker_definition.meta.full_name .. " tried setting unregistered variable '" .. varname .. "'")
        end
        local var_wrapper = self.joker_definition.meta.var_wrappers[varname]
        if var_wrapper and getmetatable(value) ~= var_wrapper then
            error(
                "Joker " .. self.joker_definition.meta.full_name
                .. " tried setting variable '" .. varname .. "' to a wrong type,"
                .. " expected " .. var_wrapper.__name
                .. " but got " .. tostring(value)
            )
        end
        if value.value then
            value = value.value
        end
        self.joker_card.ability.extra[varname] = value
    end

    self.vars = {}
    setmetatable(self.vars, vars_meta)
end

---@private
function __ABC.CalculateUtil:_set_return_value(val)
    if val ~= nil and self._return_value == nil then
        self._return_value = val
    end
    return val
end

---@private
function __ABC.CalculateUtil:_set_return_table_prop(prop, val)
    if self._return_value == nil then
        self._return_value = {}
    end
    if type(self._return_value) ~= "table" then
        error("Couldn't modify return prop \"" .. prop .. "\", a conflicting return value has already been specified earlier")
    end
    self._return_value[prop] = val
end