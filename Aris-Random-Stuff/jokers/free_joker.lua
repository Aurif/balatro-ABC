---
--- Created by Aurif.
--- DateTime: 14/03/2025 19:08
---

ABC.Joker("Free Joker")
  :description({"Gives {C:mult}+#mult#{}"})
  :variables({
    mult=2
  })
  :rarity_common()
  :calculate(function(self, card, context, ABCU)
    ABCU:on_hand_scored(function()
        ABCU:do_mult_add(ABCU.vars.mult)
    end)
  end)
  :cost(0)
  :register()