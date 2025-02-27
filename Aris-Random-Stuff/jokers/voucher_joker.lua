---
--- Created by Aurif.
--- DateTime: 27/02/2025 21:25
---

ABC.Joker("Voucher Joker")
  :description({"After defeating a boss blind", "gain a {C:attention}#tag#{}"})
  :variables({
      tag = ABC.VARS.Tag("tag_voucher"),
  })
  :rarity_uncommon()
  :calculate(function(self, card, context, ABCU)
    ABCU:on_round_boss_defeated(function ()
        ABCU.vars.tag:spawn()
    end)
  end)
  :register()