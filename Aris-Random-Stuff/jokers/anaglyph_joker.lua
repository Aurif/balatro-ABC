---
--- Created by Aurif.
--- DateTime: 27/02/2025 22:45
---

ABC.Joker("Anaglyph Joker")
  :description({"After skipping a blind", "gain another {C:green,E:1,S:1.1}random tag{}"})
  :rarity_uncommon()
  :calculate(function(self, card, context, ABCU)
    ABCU:on_blind_skipped(function ()
        ABC.VARS.Tag:random(pseudoseed("Anaglyph Joker")):spawn()
    end)
  end)
  :debug_force_in_shop()
  :register()