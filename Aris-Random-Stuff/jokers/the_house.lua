---
--- Created by Aurif.
--- DateTime: 12/03/2025 16:32
---

ABC.Joker("The House")
  :description({"On hand played", "probabilities {C:green,E:1,S:1.1}x#prob_increase#{},", "on hand discarded", "probabilities {C:green,E:1,S:1.1}x#prob_decrease#{}"})
  :rarity_rare()
  :variables({
    prob_increase = 1.5,
    prob_decrease = 0.5
  })
  :calculate(function(self, card, context, ABCU)
    ABCU:on_hand_played(function ()
        ABCU:do_probability_multiply(ABCU.vars.prob_increase)
        ABC.Animations.display_text(card, "x" .. tostring(ABCU.vars.prob_increase), G.C.GREEN)
    end)
    ABCU:on_hand_discarded(function ()
        ABCU:do_probability_multiply(ABCU.vars.prob_decrease)
        ABC.Animations.display_text(card, "x" .. tostring(ABCU.vars.prob_decrease), G.C.GREEN)
    end)
  end)
  :register()