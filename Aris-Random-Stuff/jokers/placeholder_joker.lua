---
--- Created by Aurif.
--- DateTime: 15/03/2025 22:58
---

ABC.Joker("Placeholder Joker")
  :description({"When sold or destroyed", "spawn a random {V:1}#rarity#{} joker"})
  :rarity_common()
  :variables({
    rarity = ABC.VARS.Rarity("Uncommon")
  })
  :calculate(function(self, card, context, ABCU)
    ABCU:on_self_destroyed(function ()
        local joker = ABCU.vars.rarity:random_joker(pseudoseed("Placeholder Joker"))
        joker:spawn()
    end)
  end)
  :incompat_eternal()
  :register()