---
--- Created by Aurif.
--- DateTime: 05/03/2025 16:59
---

ABC.Joker("High Contrast Joker")
  :description({"Gives {X:blue,C:white}X#x_chips#{} chips and {X:red,C:white}X#x_mult#{} mult"})
  :variables({
    x_chips=0.5,
    x_mult=2
  })
  :rarity_common()
  :calculate(function(self, card, context, ABCU)
    ABCU:on_hand_scored(function()
        ABCU:do_chips_multiply(ABCU.vars.x_chips)
        ABCU:do_mult_multiply(ABCU.vars.x_mult)
    end)
  end)
  :register()