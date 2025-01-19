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
    local o = { raw = JOKER_DEFAULTS, meta = {} }
    setmetatable(o, self)
    self.__index = self
    o:__init__(name)
    return o
end

function ABC.Joker:register()
    self:_setup_default_sprite()
    self:_substitute_description_vars()
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
-- Functionality
--
function ABC.Joker:variables(vars)
    self.raw.config = {
        extra = vars
    }

    local var_order = {}
    for k, _ in pairs(vars) do
        table.insert(var_order, k)
    end
    self.meta.var_order = var_order
    self.raw.loc_vars = function(self, info_queue, card)
        local loc_vars = {}
        for _, k in pairs(var_order) do
            table.insert(loc_vars, card.ability.extra[k])
        end
        return { vars = loc_vars }
    end
    return self
end

function ABC.Joker:calculate(calculate)
    self.raw.calculate = calculate
    return self
end

--
-- Utilities
--
function ABC.Joker:get_full_name()
    return "j_" .. SMODS.current_mod.prefix .. "_" .. self.raw.key
end

--
-- Internal
--

function ABC.Joker:__init__(name)
    self.raw.name = name
    self.raw.key = string.gsub(string.lower(name), "%W", "_")
end

function ABC.Joker:_setup_default_sprite()
    self.raw.pos = { x = 0, y = 0 }
    self.raw.atlas = self:get_full_name()
    SMODS.Sprite:new(self.raw.atlas, SMODS.current_mod.path, self.raw.atlas .. ".png", 71, 95, "asset_atli"):register()
end

function ABC.Joker:_substitute_description_vars()
    for i, line in pairs(self.raw.loc_txt.text) do
        for j, k in pairs(self.meta.var_order) do
            line = line:gsub("#" .. k .. "#", "#" .. j .. "#")
        end
        self.raw.loc_txt.text[i] = line
    end
end