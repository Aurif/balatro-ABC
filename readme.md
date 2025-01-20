## Ari's Balatro (modding) Core

### If you are a player
This is a collection of various balatro mods made by me. To install them, just download the code and unzip it into your `Mods` folder (requires [Steammodded](https://github.com/Steamodded/smods/wiki)). The `ABC` mod is the core and is required for other mods to function properly, but when it comes to every other folder you can pick and choose which ones you want to keep, and which ones not.

### If you are a modder
This is a library (in very early alpha) built on top of [Steammodded](https://github.com/Steamodded/smods/wiki) that uses object-oriented approach to make modding balatro easier. The `ABC` folder is the core you are probably looking for, and all the other folders are just various examples of how to use this library.

And, just to show you that the library does help, here is an example joker evolution coded using **ABC**:
```lua
ABC.Joker:new("J-Chart")
  :description({"Gives {C:chips}+#chips#{} Chips for every", "letter {C:attention}\"#letter#\"{} in your Jokers", "Increases by {C:chips}#increment#{} for each", "scored letter"})
  :credit_original_art("Grassy")
  :variables({
      chips = 20,
      letter = "A",
      increment = 1
  })
  :calculate(function(self, card, context)
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
  end)

  :evolution_of("j_mmc_eye_chart", 5, {"letter"}, {"Have {C:attention}#2#{} Jokers with", "this letter"})
  :evolution_calculate(function(self, card, context)
      if context.before and card.ability.amount and card.ability.amount > 0 then
          card.ability.amount = 5
      end
      if tally_letters(card, context) > 0 then
          card:decrement_evo_condition()
      end
  end)
  :register()
```
Versus without it:
```lua
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
```