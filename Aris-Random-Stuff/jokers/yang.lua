---
--- Created by Aurif.
--- DateTime: 02/03/2025 01:46
---

ABC.Joker("Yang")
  :description({"Scored cards give {C:mult}+#mult#{} Mult", "on the {C:attention}final hand{} of round"})
  :variables({
    mult = 3
  })
  :rarity_common()
  :calculate(function(self, card, context, ABCU)
    ABCU:on_card_scored(function()
      if ABCU:is_hand_final() then
        ABCU:do_mult_add(ABCU.vars.mult)
      end
    end)
  end)
  :unlock_condition(
      {"Discover the","{C:attention}#other_joker#{} joker."},
      { other_joker = ABC.VARS.Joker("j_ari_rand_yin") },
      function (self, args, vars)
        if args.type == 'discover_amount' then
            return vars.other_joker:is_discovered()
        end
      end
  )
  :register()