---
--- Created by Aurif.
--- DateTime: 05/02/2025 22:22
---

---
--- Base
---

---@class ABC.CalculateUtilJoker : ABC.CalculateUtil
---@sticker joker
---@field private joker_self any
---@field private joker_card any
---@field private context any
---@field private joker_definition any
---@overload fun(joker_self, joker_card, context, joker_definition): ABC.CalculateUtilJoker private
__ABC.CalculateUtilJoker = class(__ABC.CalculateUtil)

---
--- Events - round stages
---

--- Triggers at the beggining of a round.
---***
--- @param callback fun(): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/checkered_joker.lua)
function __ABC.CalculateUtilJoker:on_round_start(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.setting_blind and not self.joker_self.getting_sliced then
        return self:_set_return_value(callback())
    end
end

--- Triggers at the end of a round.
---***
--- @param callback fun(): nil Callback to execute
function __ABC.CalculateUtilJoker:on_round_end(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.end_of_round and not (self.context.individual or self.context.repetition) then
        return self:_set_return_value(callback())
    end
end

--- Triggers after a boss blind is defeated.
---***
--- @param callback fun(): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/voucher_joker.lua)
function __ABC.CalculateUtilJoker:on_round_boss_defeated(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.end_of_round and not (self.context.individual or self.context.repetition) and G.GAME.blind.boss then
        return self:_set_return_value(callback())
    end
end

--- Triggers during dollar bonus calculation after a blind is defeated.\
--- Return value determines dollar bonus from this joker.
---***
--- @param callback fun(): integer Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/many_jokers.lua)
function __ABC.CalculateUtilJoker:on_dollar_bonus(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.calc_dollar_bonus then
        return self:_set_return_value(callback())
    end
end

---
--- Events - cards
---


--- Triggers when a hand is played.
---***
--- @param callback fun(played_hand: Card[]): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/the_house.lua)
function __ABC.CalculateUtilJoker:on_hand_played(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.joker_main then
        return self:_set_return_value(callback(self.context.full_hand))
    end
end

--- Triggers once during scoring.\
--- This is where joker-based chips and mult bonuses can be done.
---***
--- @param callback fun(scored_hand: Card[]): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/mutually_assured_destruction.lua)
function __ABC.CalculateUtilJoker:on_hand_scored(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.joker_main then
        return self:_set_return_value(callback(self.context.scoring_hand))
    end
end

--- Triggers for each scored card during scoring.\
--- This is where card-based chips and mult bonuses can be done.
---***
--- @param callback fun(scored_card: Card): nil Callback to execute for each card
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/checkered_joker.lua)
function __ABC.CalculateUtilJoker:on_card_scored(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.individual and self.context.cardarea == G.play then
        return self:_set_return_value(callback(self.context.other_card))
    end
end

--- Triggers for each scored card after hand has been scored.\
--- This is where card modifications should be done.
---***
--- @param callback fun(scored_card: Card): nil Callback to execute for each card
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yin.lua)
function __ABC.CalculateUtilJoker:on_card_post_scored(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.after and self.context.scoring_hand then
        for i = 1, #self.context.scoring_hand do
            callback(self.context.scoring_hand[i])
        end
    end
end

--- Triggers for each scored card to determine if it should be retriggered.\
--- Only retriggering should be done in this step.
---***
--- @param callback fun(card: Card): integer Callback to execute for each card, the returned value determines the number of additional triggers
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/evil_red_seal.lua)
function __ABC.CalculateUtilJoker:on_card_should_retrigger(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.repetition and self.context.cardarea == G.play then
        local repetition_count = callback(self.context.other_card)
        if not repetition_count or repetition_count <= 0 then
            return
        end
        self:_set_return_table_prop("repetitions", repetition_count)
        self:_set_return_table_prop("card", self.joker_card)
    end
end

--- Triggers when a hand is discarded.
---***
--- @param callback fun(discarded_hand: Card[]): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/the_house.lua)
function __ABC.CalculateUtilJoker:on_hand_discarded(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.pre_discard then
        return self:_set_return_value(callback(self.context.full_hand))
    end
end

--- Triggers for each discarded card.
---***
--- @param callback fun(discarded_card: Card): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/the_house_alternative.lua)
function __ABC.CalculateUtilJoker:on_card_discarded(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.discard then
        return self:_set_return_value(callback(self.context.other_card))
    end
end

--- Triggers once per each draw.
---***
--- @param callback fun(drawn_hand: Card[]): nil Callback to execute
function __ABC.CalculateUtilJoker:on_hand_drawn(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.hand_drawn then
        return self:_set_return_value(callback(self.context.hand_drawn))
    end
end

--- Triggers for each drawn card.
---***
--- @param callback fun(drawn_card: Card): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/the_house_alternative.lua)
function __ABC.CalculateUtilJoker:on_card_drawn(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.hand_drawn then
        for i = 1, #self.context.hand_drawn do
            callback(self.context.hand_drawn[i])
        end
    end
end

---
--- Events - joker
---

--- Triggers when this joker card is destroyed or sold.
---***
--- @param callback fun(is_sold: boolean): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/mutually_assured_destruction.lua)
function __ABC.CalculateUtilJoker:on_self_destroyed(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.selling_self then
        self.joker_card._was_sold = true
    end
    if self.context.remove_from_deck then
        return self:_set_return_value(callback(self.joker_card._was_sold))
    end
end

---
--- Events - others
---

--- Triggers after player exits shop and enters blind selection.
---***
--- @param callback fun(): nil Callback to execute
function __ABC.CalculateUtilJoker:on_shop_exit(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.ending_shop then
        return self:_set_return_value(callback())
    end
end

--- Triggers when player skips a blind.
---***
--- @param callback fun(): nil Callback to execute
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/anaglyph_joker.lua)
function __ABC.CalculateUtilJoker:on_blind_skipped(callback)
	if not self:_pre_trigger_check() then return end
    if self.context.skip_blind then
        return self:_set_return_value(callback())
    end
end

---
--- Conditionals
---

--- Checks if this is the first hand of round.
---***
--- @return boolean is_first_hand True if this is the first hand of round.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yin.lua)
function __ABC.CalculateUtilJoker:is_hand_first()
    return G.GAME.current_round.hands_played == 0
end

--- Checks if this is the final hand of round.
---***
--- @return boolean is_final_hand True if this is the final hand of round.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yang.lua)
function __ABC.CalculateUtilJoker:is_hand_final()
    return G.GAME.current_round.hands_left == 0
end

---
--- Effects
---

--- Scores a given amount of chips.
---***
--- @param chips integer Amount of chips to score.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yin.lua)
function __ABC.CalculateUtilJoker:do_chips_add(chips)
    self:_set_return_table_prop("chips", chips)
    self:_set_return_table_prop("card", self.joker_card)
end

--- Scores a given amount of mult.
---***
--- @param mult integer Amount of mult to score.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yang.lua)
function __ABC.CalculateUtilJoker:do_mult_add(mult)
    self:_set_return_table_prop("mult", mult)
    self:_set_return_table_prop("card", self.joker_card)
end

--- Applies a mult multiplier.
---***
--- @param x_mult number Amount to multiply mult by.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/mutually_assured_destruction.lua)
function __ABC.CalculateUtilJoker:do_mult_multiply(x_mult)
    self:_set_return_table_prop("x_mult", x_mult)
    self:_set_return_table_prop("card", self.joker_card)
end

--- Applies a chip multiplier.
---***
--- @param x_chips number Amount to multiply chips by.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/high_contrast_joker.lua)
function __ABC.CalculateUtilJoker:do_chips_multiply(x_chips)
    self:_set_return_table_prop("x_chips", x_chips)
    self:_set_return_table_prop("card", self.joker_card)
end

--- Destroys a given joker.
---***
--- @param joker SMODS.Joker Joker to destroy.
--- @param force? boolean If true, will destroy the joker even if it's eternal.
--- @return boolean was_destroyed True if the joker was succesfully destroyed, false otherwise (for example, it was eternal or it was already being destroyed)
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/mutually_assured_destruction.lua)
function __ABC.CalculateUtilJoker:do_joker_destroy(joker, force)
    if joker.getting_sliced or (joker.ability.eternal and not force) then
        return false
    end

    joker.getting_sliced = true
    G.E_MANAGER:add_event(Event({func = function()
        joker:start_dissolve({G.C.RED}, nil, 1.6)
    return true end }))
    return true
end

--- Adds a given value to all probabilities.
---***
--- @param prob number Value to add to the probabilities.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/the_house_alternative.lua)
function __ABC.CalculateUtilJoker:do_probability_add(prob)
    for k, v in pairs(G.GAME.probabilities) do
        G.GAME.probabilities[k] = math.floor((v+prob)*1000+0.5)/1000
    end
end

--- Multiplies all probabilities by a given value.
---***
--- @param x_prob number Value to multiply the probabilities by.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/the_house.lua)
function __ABC.CalculateUtilJoker:do_probability_multiply(x_prob)
    for k, v in pairs(G.GAME.probabilities) do
        G.GAME.probabilities[k] = math.floor((v*x_prob)*1000+0.5)/1000
    end
end

---@alias EnumPermaBonus
---| '"chips_add"'
---| '"mult_add"'
---| '"chips_multiply"'
---| '"mult_multiply"'
---| '"chips_add_when_held"'
---| '"mult_add_when_held"'
---| '"chips_multiply_when_held"'
---| '"mult_multiply_when_held"'

local PERMA_BONUS = {
	chips_add = {key="perma_bonus", default=0},
    mult_add = {key="perma_mult", default=0},
    chips_multiply = {key="perma_x_chips", default=1},
    mult_multiply = {key="perma_x_mult", default=1},

    chips_add_when_held = {key="perma_h_chips", default=0},
    mult_add_when_held = {key="perma_h_mult", default=0},
    chips_multiply_when_held = {key="perma_h_x_chips", default=1},
    mult_multiply_when_held = {key="perma_h_x_mult", default=1},
}

--- Adds a permanent bonus to a given card.
---***
--- @param card Card Card to apply the bonus to.
--- @param bonus EnumPermaBonus Type of bonus to add, possible values are: `chips_add`, `mult_add`, `chips_multiply`, `mult_multiply`, `chips_add_when_held`, `mult_add_when_held`, `chips_multiply_when_held`, `mult_multiply_when_held`.
--- @param value number Value to add to the specified permanent bonus.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/rainbow_joker.lua)
function __ABC.CalculateUtilJoker:do_card_bonus_permanent_add(card, bonus, value)
    local bonus_data = PERMA_BONUS[bonus]
    local previous_bonus = card.ability[bonus_data.key]
    if previous_bonus == nil then previous_bonus = bonus_data.default end
    card.ability[bonus_data.key] = previous_bonus + value
end

---
--- Getters
---

--- Returns other joker cards the player currently has.
---***
--- @return SMODS.Joker[] other_jokers List of other jo,kers
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/mutually_assured_destruction.lua)
function __ABC.CalculateUtilJoker:get_other_jokers()
    local other_jokers = {}
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] ~= self.joker_card and not G.jokers.cards[i].getting_sliced then other_jokers[#other_jokers+1] = G.jokers.cards[i] end
    end
    return other_jokers
end


---
--- Internal
---

---@private
function __ABC.CalculateUtilJoker:__init__(joker_self, joker_card, context, joker_definition)
    self.joker_self = joker_self
    self.joker_card = joker_card
    self.context = context
    self.joker_definition = joker_definition
    self:_init_vars()
end

---@private
function __ABC.CalculateUtilJoker:_init_vars()
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
function __ABC.CalculateUtilJoker:_set_return_value(val)
    if val ~= nil and self._return_value == nil then
        self._return_value = val
    end
    return val
end

---@private
function __ABC.CalculateUtilJoker:_set_return_table_prop(prop, val)
    if self._return_value == nil then
        self._return_value = {}
    end
    if type(self._return_value) ~= "table" then
        error("Couldn't modify return prop \"" .. prop .. "\", a conflicting return value has already been specified earlier")
    end
    self._return_value[prop] = val
end

---@private
function __ABC.CalculateUtilJoker:_pre_trigger_check()
    if self.context.blueprint and not self.joker_self.blueprint_compat then return false end
    return true
end