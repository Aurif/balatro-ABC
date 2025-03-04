---
--- Created by Aurif.
--- DateTime: 14/01/2025 22:55
---
local JOKER_DEFAULTS = {
    perishable_compat = true,
    blueprint_compat = true,
    eternal_compat = true,
    discovered = false
}

---
--- Base
---

---@class ABC.Joker
---@field private raw any
---Starts definition of a new joker.\
---Must be ended with `:register()` to have any effect. Sprites for the joker must be placed in `assets/1x/j_<mod_prefix>_<name>.png` and `assets/2x/j_<mod_prefix>_<name>.png` (so, if joker's name is "Checkered Joker" and mod's prefix is "ari_rand", the path will be `assets/1x/j_ari_rand_checkered_joker.png`).
---***
---\@*param* `name` — In-game name of the joker.
---
---\@*return* `joker` — start of chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/checkered_joker.lua)
---@overload fun(name: string): ABC.Joker
ABC.Joker = class()

---Defines joker's variable types and initial values.
---***
---@generic V : {[string]: string|number|ABC.VAR}
---@param variables V A dictionary, with keys being variable names, and values being their initial values. When dealing with variables that aren't numbers or strings it is <u>highly recommended</u> to use ABC's variable classes.
---@return ABC.Joker|{__shadow_var_types: V} self for chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/electrician.lua)
function ABC.Joker:variables(variables)
    self.meta.var_wrappers = {}
    for k, v in pairs(variables) do
        if type(v) == "table" and getmetatable(v).__is_abc_var then
            self.meta.var_wrappers[k] = getmetatable(v)
            variables[k] = v.value
        end
    end
    self.raw.config = {
        extra = variables
    }

    local var_order = {}
    for k, _ in pairs(variables) do
        table.insert(var_order, k)
    end
    self.meta.var_order = var_order
    self.raw.loc_vars = function(_, info_queue, card)
        local loc_vars = {}
        for _, k in pairs(var_order) do
            if self.meta.var_wrappers[k] and self.meta.var_wrappers[k]._localize then
                local wrapper = self.meta.var_wrappers[k]
                local localization = wrapper(card.ability.extra[k]):_localize()
                table.insert(loc_vars, localization.text)
                for extra_k, extra_v in pairs(localization.extra or {}) do
                    if not loc_vars[extra_k] then
                        loc_vars[extra_k] = {}
                    end
                    table.insert(loc_vars[extra_k], extra_v)
                end
            else
                table.insert(loc_vars, card.ability.extra[k])
            end
        end
        return { vars = loc_vars }
    end
    return self
end

---Sets joker's in-game description.
---***
---@generic J: ABC.Joker
---@param self J
---@param description string[] In-game description, with each list element being a new line. Variable values can be inserted by using `#variable_name#`.
---@return J self for chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/electrician.lua)
function ABC.Joker:description(description)
    if not self.raw.loc_txt then
        self.raw.loc_txt = {
            name = self.raw.name
        }
    end
    self.raw.loc_txt.text = description
    return self
end

---Defines the calculate function responsible for effects of the joker.\
---See [Steamodded API](https://github.com/Steamodded/smods/wiki/calculate_functions) for more details on calculate functions.
---***
---@generic V
---@param self ABC.Joker|{__shadow_var_types: V}
---@param calculate fun(self, card, context, ABCU: ABC.CalculateUtil|{vars: V}): any The calculate function. First three parameters (`self`, `card`, `context`) correspond to the definitions from [Steamodded API](https://github.com/Steamodded/smods/wiki/calculate_functions). The fourth parameter is the [CalculateUtil class](https://github.com/Aurif/balatro-ABC/wiki/CalculateUtil) provided by ABC.
---@return ABC.Joker|{__shadow_var_types: V} self for chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/electrician.lua)
function ABC.Joker:calculate(calculate)
    self.raw.calculate = function(calc_self, card, context)
        local ABCU = __ABC.CalculateUtil(calc_self, card, context, self)
        ABCU:_set_return_value(calculate(calc_self, card, context, ABCU))
        return ABCU._return_value
    end
    self.raw.calc_dollar_bonus = function(calc_self, card)
        return self.raw.calculate(calc_self, card, {calc_dollar_bonus=true})
    end
    self.raw.remove_from_deck = function(calc_self, card)
        return self.raw.calculate(calc_self, card, {remove_from_deck=true})
    end

    return self
end

---Actually creates the joker.\
---Must be used at the end of very joker definition.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/electrician.lua)
function ABC.Joker:register()
    if self.meta.prevent_registration then
        return
    end
    self:_setup_default_sprite()
    self:_substitute_description_vars()
    self:_validate()
    SMODS.Joker(self.raw)

    for _, callback in pairs(self.listeners["register"] or {}) do
        G.E_MANAGER:add_event(Event({ trigger = 'after',
            func = function()
                callback()
                return true
            end
        }))
    end
end

---
--- Rarities
---

---Sets rarity of the joker to **common**.\
---If no buy price was set, sets it randomly in range [3-5].
---***
---@generic J: ABC.Joker
---@param self J
---@return J self for chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/checkered_joker.lua)
function ABC.Joker:rarity_common()
    if not self.raw.cost then
        self.raw.cost = random_choice({ 3, 4, 4, 4, 5}, self.meta.full_name)
    end
    self.raw.rarity = 1

    return self
end

---Sets rarity of the joker to **uncommon**.\
---If no buy price was set, sets it randomly in range [5-7].
---***
---@generic J: ABC.Joker
---@param self J
---@return J self for chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/many_jokers.lua)
function ABC.Joker:rarity_uncommon()
    if not self.raw.cost then
        self.raw.cost = random_choice({ 5, 6, 7 }, self.meta.full_name)
    end
    self.raw.rarity = 2

    return self
end

---Sets rarity of the joker to **rare**.\
---If no buy price was set, sets it randomly in range [8-10].
---***
---@generic J: ABC.Joker
---@param self J
---@return J self for chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/electrician.lua)
function ABC.Joker:rarity_rare()
    if not self.raw.cost then
        self.raw.cost = random_choice({ 8, 8, 8, 9, 10 }, self.meta.full_name)
    end
    self.raw.rarity = 3

    return self
end

---
--- Advanced
---

---Makes the Joker require unlocking and defines the unlock condition.
---@generic J: ABC.Joker
---@param self J
---@param description string[] In-game description of the unlock condition, with each list element being a new line. Has analogical structure to [joker description](https://github.com/Aurif/balatro-ABC/wiki/Joker#descriptiondescription).
---@param check_for_unlock fun(self, args): nil|boolean The check_for_unlock function. The second parameter (`args`) is the context of the check. If this function returns `true`, the card will become unlocked.
---@return J self for chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/checkered_joker.lua)
function ABC.Joker:unlock_condition(description, check_for_unlock)
    self.raw.unlocked = false
    self.raw.loc_txt.unlock = description
    self.raw.check_for_unlock = function(card_self, args)
        local should_unlock = check_for_unlock(card_self, args)
        if should_unlock then
            unlock_card(card_self)
        end
    end
    return self
end

---Adds other mods as dependency for this joker.\
---(Joker won't be created if those mods aren't present.)
---@generic J: ABC.Joker
---@param self J
---@param dependencies string[] List of mod ids to set as dependencies.
---@return J self for chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/electrician.lua)
function ABC.Joker:depends_on(dependencies)
    self.raw.dependencies = dependencies
    return self
end

---
--- Notes
---

---Adds a note crediting the artist of the joker's original sprite.
---***
---@generic J: ABC.Joker
---@param self J
---@param artist string Name of the artist to credit
---@return J self for chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Evolutions/jokers/j_chart.lua)
function ABC.Joker:credit_original_art(artist)
    table.insert(self.raw.loc_txt.text, "{C:inactive}Original art by {C:green,E:1,S:1.1}" .. artist)
    return self
end

---
--- Debug functions
---

---Forces the card to always appear in the shop for the price of 0.\
---For debugging purposes only.
---***
---@generic J: ABC.Joker
---@param self J
---@return J self for chaining.
function ABC.Joker:debug_force_in_shop()
    local joker_key = self.meta.full_name
    local old_Controller_snap_to = Controller.snap_to
    function Controller:snap_to(args)
        local in_shop_load = G["shop"] and args["node"] and
                             (args.node == G.shop:get_UIE_by_ID('next_round_button') or
                              args.node["area"] and args.node.area["config"] and args.node.area.config.type == "shop")
        if in_shop_load then
            local joker_already_in_shop = false
            for _, card in pairs(G.shop_vouchers.cards) do
                if card.config.center_key == joker_key then
                    joker_already_in_shop = true
                end
            end

            if not joker_already_in_shop then
                local card = create_card('Joker', G.shop_vouchers, nil, 1, nil, nil, joker_key, nil)
                card.base_cost = 0
                card.cost = 0
                create_shop_card_ui(card, 'Joker', G.shop_vouchers)
                card.states.visible = nil
                G.shop_vouchers:emplace(card)
                G.shop_vouchers.config.card_limit = #G.shop_vouchers.cards
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_materialize({ HEX("2a004b") })
                        return true
                    end
                }))
            end
        end
        return old_Controller_snap_to(self, args)
    end

    ---@cast self J
    return self
end


---Resets the unlock and discovery state whenever profile is loaded.\
---For debugging purposes only.
---***
---@generic J: ABC.Joker
---@param self J
---@return J self for chaining.
function ABC.Joker:debug_reset_unlock()
    local joker_key = self.meta.full_name
    local function reset_unlock()
        G.P_CENTERS[joker_key].discovered = false
        if (G.P_CENTERS[joker_key].unlock_condition ~= nil or G.P_CENTERS[joker_key].check_for_unlock ~= nil) and G.P_CENTERS[joker_key].unlocked then
            G.P_CENTERS[joker_key].unlocked = false
            G.P_LOCKED[#G.P_LOCKED + 1] = G.P_CENTERS[joker_key]
        end
    end

    local old_Game_init_item_prototypes = Game.init_item_prototypes
    function Game:init_item_prototypes()
        local result = old_Game_init_item_prototypes(self)
        reset_unlock()
        return result
    end
    self:_add_listener("register", reset_unlock)

    return self
end

---
--- Last resort functions
---

---Directly sets value of given property.\
---Should only be used if given functionality is missing in ABC. When using, please [report a feature request for the missing functionality](https://github.com/Aurif/balatro-ABC/issues).
---***
---@generic J: ABC.Joker
---@param key string Key of the property to set.
---@param value any Value to set the property to.
---@param self J
---@return J self for chaining.
function ABC.Joker:raw_set(key, value)
    self.raw[key] = value

    return self
end

---
--- Internal
---

---@private
function ABC.Joker:__init__(name)
    self.raw = copy_table(JOKER_DEFAULTS)
    self.meta = {}
    self.listeners = {}
    self.raw.name = name
    self.raw.key = string.gsub(string.lower(name), "%W", "_")
    self.meta.full_name = "j_" .. SMODS.current_mod.prefix .. "_" .. self.raw.key
end

---@private
function ABC.Joker:_setup_default_sprite()
    self.raw.pos = { x = 0, y = 0 }
    self.raw.atlas = self.meta.full_name
    SMODS.Atlas {
      key = self.raw.atlas,
      path = self.raw.atlas .. ".png",
      px = 71,
      py = 95
    }
end

---@private
function ABC.Joker:_substitute_description_vars()
    if not self.raw.loc_txt or not self.raw.loc_txt.text then
        return
    end
    for i, line in pairs(self.raw.loc_txt.text) do
        for j, k in pairs(self.meta.var_order or {}) do
            line = line:gsub("#" .. k .. "#", "#" .. j .. "#")
        end
        self.raw.loc_txt.text[i] = line
    end
end

---@private
function ABC.Joker:_validate()
    local errors = {  }
    if not self.raw.rarity then table.insert(errors, "missing rarity") end
    if not self.raw.cost then table.insert(errors, "missing cost") end
    --if self.raw.loc_txt == nil or self.raw.loc_txt.text == nil then table.insert(errors, "missing description") end
    if #errors > 0 then
        local register_traceback = debug.traceback():match("^[^\n]*\n[^\n]*\n[^\n]*\n%s*([^\n]*)")
        local error_message = register_traceback .. "\nTried registering invalid joker"
        for _, err in pairs(errors) do
            error_message = error_message .. "\n  - " .. err
        end
        error(error_message)
    end
end

---@private
function ABC.Joker:_add_listener(key, callback)
    if not self.listeners[key] then
        self.listeners[key] = {}
    end
    table.insert(self.listeners[key], callback)
end