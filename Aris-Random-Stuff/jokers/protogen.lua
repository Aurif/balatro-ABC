---
--- Created by Aurif.
--- DateTime: 14/04/2025 13:43
---

ABC.Joker("Protogen")
  :description({"Every round, create", "a {C:attention}#edition#{} Tarot card"})
  :variables({
    edition=ABC.VARS.Edition("e_negative")
  })
  :rarity_epic()
  :calculate(function(self, card, context, ABCU)
    ABCU:on_round_end(function()
        ABC.VARS.Tarot:random(pseudoseed("protogen")):spawn({ABCU.vars.edition})
    end)
  end)
  :credit_art("Tachyon")
  :register()
