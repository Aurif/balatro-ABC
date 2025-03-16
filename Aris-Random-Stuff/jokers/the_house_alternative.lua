---
--- Created by Aurif.
--- DateTime: 12/03/2025 17:52
---

ABC.Joker("The House?")
  :key("the_house_alternative")
  :description({"On card drawn", "probabilities {C:green,E:1,S:1.1}+#prob_increase#{},", "on card discarded", "probabilities {C:green,E:1,S:1.1}-#prob_decrease#{}"})
  :rarity_rare()
  :variables({
    prob_increase = 0.1,
    prob_decrease = 0.2
  })
  :calculate(function(self, card, context, ABCU)
    ABCU:on_card_drawn(function ()
        ABCU:do_probability_add(ABCU.vars.prob_increase)
    end)
    ABCU:on_card_discarded(function ()
        ABCU:do_probability_add(-ABCU.vars.prob_decrease)
    end)
  end)
  :register()