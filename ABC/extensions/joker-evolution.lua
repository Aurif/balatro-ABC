---
--- Created by Aurif.
--- DateTime: 15/01/2025 22:35
---

---@generic J: ABC.Joker
---@param self J
---@return J self for chaining
function ABC.Joker:evolution_of(other_joker, max_amount, carryover, description)
    if not SMODS.Mods['joker_evolution'] then
        sendDebugMessage('Installing "Joker Evolution" mod will provide additional content')
        self.meta.prevent_registration = true
        return self
    end
    JokerEvolution.evolutions:add_evolution(other_joker, self.meta.full_name, max_amount, carryover)
    self.meta.evolution_of = other_joker
    self.raw.rarity = "evo"
    if SMODS.Centers[other_joker] and SMODS.Centers[other_joker].cost then
        self.raw.cost = SMODS.Centers[other_joker].cost * 2
    else
        self.raw.cost = 8
    end

    table.insert(description, "{C:inactive}({C:attention}#1#{C:inactive}/#2#)")
    local process_loc_textref = JokerEvolution_Mod.process_loc_text
    local other_joker_key = "je_"..other_joker
    function JokerEvolution_Mod.process_loc_text()
        process_loc_textref()
        G.localization.descriptions.Other[other_joker_key] = {
            name = "Evolution",
            text = description
        }
    end
    return self
end

---@generic J: ABC.Joker
---@param self J
---@return J self for chaining
function ABC.Joker:evolution_calculate(calculate)
    if not SMODS.Mods['joker_evolution'] then
        return self
    end
    if not self.meta.evolution_of then
        error("Tried adding evolution calculate to a Joker without evolution (use 'evolution_of' first)")
    end
    self.raw.calculate_evo = calculate
    return self
end

