---
--- Created by Aurif.
--- DateTime: 02/03/2025 01:46
---

ABC.Joker("Yin")
  :description({"Scored cards give {C:chips}+#chips#{} Chips", "on the {C:attention}first hand{} of round."})
  :variables({
    chips = 20
  })
  :rarity_common()
  :calculate(function(self, card, context, ABCU)
    ABCU:on_card_scored(function()
      if ABCU:is_hand_first() then
        ABCU:do_chips_add(ABCU.vars.chips)
      end
    end)
  end)
  :register()