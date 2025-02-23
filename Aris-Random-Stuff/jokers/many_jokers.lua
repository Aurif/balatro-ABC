---
--- Created by Aurif.
--- DateTime: 21/02/2025 20:00
---

ABC.Joker("Many Jokers")
  :description({"At end of round, each", "card in deck has {C:green,E:1,S:1.1}#probability#{}", "chance to give {C:attention}$#money#{}"})
  :variables({
      probability = ABC.VARS.Probability(20),
      money = 1
  })
  :rarity_uncommon()
  :calculate(function(self, card, context, ABCU)
    ABCU:on_dollar_bonus(function()
        local total = 0
        for c = 0, #G.deck.cards do
            if ABCU.vars.probability:triggers() then
                total = total + ABCU.vars.money
            end
        end
        return total
    end)
  end)
  :register()