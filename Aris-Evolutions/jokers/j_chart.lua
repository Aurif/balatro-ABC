local function remove_prefix(name, prefix)
    local start_pos, end_pos = string.find(name, prefix)
    if start_pos == 1 then
        return string.sub(name, end_pos + 1)
    else
        return name
    end
end

local function count_letters(str, letter)
    local count = 0
    for _ in str:gmatch(letter) do
        count = count + 1
    end
    return count
end

function tally_letters(card, context)
	-- Check if Joker name contains letter and apply chips
	if context.other_joker and context.other_joker.ability.set == "Joker" and not context.other_context then
		-- FOR OTHER MODS:
		-- If your mod uses ability names with a prefix and you want it to be compatible with this Joker,
		-- Send me a message on Discord and I will add your prefix here so that it will work correctly!

		-- Remove prefix from ability names
		local ability_name = context.other_joker.ability.name:lower()
		ability_name = remove_prefix(ability_name, "mmc")

		-- Count letters
		local letter_tally = count_letters(ability_name, card.ability.extra.letter:lower())
		return letter_tally
	end
	return 0
end
  

--- Create the evolved joker using SMODS.Joker (documentation for SMODS.Joker available on the Steamodded wiki)
SMODS.Joker{
	key = "j_chart",
	name = "J-Chart",
	rarity = "evo", -- New rarity for evolved jokers
	blueprint_compat = false,
	eternal_compat = true,
	pos = {x = 0, y = 0},
	atlas = "j_ari_evo_j_chart",
	cost = 8,	--Rule of thumb: double the original joker cost
	config = {
		extra = {
			chips = 20,
			letter = "A",
			increment = 1
		}
	},

	loc_vars = function(self, info_queue, card)
		return {vars = { card.ability.extra.chips, card.ability.extra.letter, card.ability.extra.increment }}
	end,
	loc_txt = {
		name = "J-Chart",
		text = {
			"Gives {C:chips}+#1#{} Chips for every",
			"letter {C:attention}\"#2#\"{} in your Jokers",
			"Increases by {C:chips}#3#{} for each",
			"scored letter",
			"{C:inactive}Original art by {C:green,E:1,S:1.1}Grassy" }
	},
	
	calculate = function(self, card, context)
		local letter_tally = tally_letters(card, context)
		if letter_tally > 0 then
			-- Animate other Joker
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			}))
			-- Increase chips
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.increment * letter_tally
			-- Apply chips
			return {
				message = localize {
					type = "variable",
					key = "a_chips",
					vars = { card.ability.extra.chips * letter_tally }
				},
				chip_mod = card.ability.extra.chips * letter_tally
			}
		end
	end,
	calculate_evo = function(self, card, context)
		if context.before and card.ability.amount and card.ability.amount > 0 then
			card.ability.amount = 5
		end
		if tally_letters(card, context) > 0 then
			card:decrement_evo_condition()
		end
	end
}

SMODS.Sprite:new("j_ari_evo_j_chart", SMODS.findModByID("ari_evolutions").path, "j_ari_evo_j_chart.png", 71, 95, "asset_atli"):register()

--- Add the evolution condition tooltip to the original joker,
--- you can also write it in your localization folder
local process_loc_textref = JokerEvolution_Mod.process_loc_text
function JokerEvolution_Mod.process_loc_text()
	process_loc_textref()
    G.localization.descriptions.Other.je_j_mmc_eye_chart = {
        name = "Evolution",
        text = {
			-- #1#: Current requirement count
			-- #2#: Evolution requirement count
			"Have {C:attention}#2#{} Jokers with", 
			"this letter",
			"{C:inactive}({C:attention}#1#{C:inactive}/#2#)" -- This line is important to keep track of the count
		}
    }
end

--- Add the mod check to make sure the mod is installed
if SMODS.Mods['joker_evolution'] then
    JokerEvolution.evolutions:add_evolution("j_mmc_eye_chart", "j_ari_evo_j_chart", 5, {'letter'})
else
	sendDebugMessage('Please install the "Joker Evolution" mod') -- You can also add the mod as a dependency in your mod header
end