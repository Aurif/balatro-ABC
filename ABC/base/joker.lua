---
--- Created by Aurif.
--- DateTime: 14/01/2025 22:55
---
ABC.Joker = {}

local JOKER_DEFAULTS = {
    blueprint_compat = true,
    eternal_compat = true
}

function ABC.Joker:new(name)
    local o = { raw = copy_table(JOKER_DEFAULTS), meta = {} }
    setmetatable(o, self)
    self.__index = self
    o:__init__(name)
    return o
end

function ABC.Joker:register()
    self:_setup_default_sprite()
    self:_substitute_description_vars()
    self:_validate()
    SMODS.Joker(self.raw)
end

--
-- Localization
--
function ABC.Joker:description(description)
    if not self.raw.loc_txt then
        self.raw.loc_txt = {
            name = self.raw.name
        }
    end
    self.raw.loc_txt.text = description
    return self
end

function ABC.Joker:credit_original_art(artist)
    table.insert(self.raw.loc_txt.text, "{C:inactive}Original art by {C:green,E:1,S:1.1}" .. artist)
    return self
end

--
-- Rarities
--
function ABC.Joker:rarity_common()
    if not self.raw.cost then
        self.raw.cost = random_choice({ 3, 4, 4, 4, 5}, self.meta.full_name)
    end
    self.raw.rarity = 1

    return self
end

function ABC.Joker:rarity_uncommon()
    if not self.raw.cost then
        self.raw.cost = random_choice({ 5, 6, 7 }, self.meta.full_name)
    end
    self.raw.rarity = 2

    return self
end

function ABC.Joker:rarity_rare()
    if not self.raw.cost then
        self.raw.cost = random_choice({ 8, 8, 8, 9, 10 }, self.meta.full_name)
    end
    self.raw.rarity = 3

    return self
end

--
-- Functionality
--
function ABC.Joker:variables(vars)
    self.meta.var_wrappers = {}
    for k, v in pairs(vars) do
        if type(v) == "table" and v.value ~= nil then
            self.meta.var_wrappers[k] = getmetatable(v)
            vars[k] = v.value
        end
    end
    self.raw.config = {
        extra = vars
    }

    local var_order = {}
    for k, _ in pairs(vars) do
        table.insert(var_order, k)
    end
    self.meta.var_order = var_order
    self.raw.loc_vars = function(_, info_queue, card)
        local loc_vars = {}
        for _, k in pairs(var_order) do
            if self.meta.var_wrappers[k] and self.meta.var_wrappers[k]._localize then
                local wrapper = self.meta.var_wrappers[k]
                local localization = wrapper:new(card.ability.extra[k]):_localize()
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

function ABC.Joker:calculate(calculate)
    self.raw.calculate = function(calc_self, card, context)
        local ABCU = ABC._CalculateUtilJoker:new(card, context, self)
        return calculate(calc_self, card, context, ABCU)
    end
    return self
end

--
-- Debug functions
--
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

    return self
end

--
-- Internal
--

function ABC.Joker:__init__(name)
    self.raw.name = name
    self.raw.key = string.gsub(string.lower(name), "%W", "_")
    self.meta.full_name = "j_" .. SMODS.current_mod.prefix .. "_" .. self.raw.key
end

function ABC.Joker:_setup_default_sprite()
    self.raw.pos = { x = 0, y = 0 }
    self.raw.atlas = self.meta.full_name
    SMODS.Sprite:new(self.raw.atlas, SMODS.current_mod.path, self.raw.atlas .. ".png", 71, 95, "asset_atli"):register()
end

function ABC.Joker:_substitute_description_vars()
    if not self.raw.loc_txt or not self.raw.loc_txt.text then
        return
    end
    for i, line in pairs(self.raw.loc_txt.text) do
        for j, k in pairs(self.meta.var_order) do
            line = line:gsub("#" .. k .. "#", "#" .. j .. "#")
        end
        self.raw.loc_txt.text[i] = line
    end
end

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