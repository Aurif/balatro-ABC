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
	if context.other_joker and context.other_joker.ability.set == "Joker" and not context.other_context then
		local ability_name = context.other_joker.ability.name:lower()
		ability_name = remove_prefix(ability_name, "mmc")
		return count_letters(ability_name, card.ability.extra.letter:lower())
	end
	return 0
end
  

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