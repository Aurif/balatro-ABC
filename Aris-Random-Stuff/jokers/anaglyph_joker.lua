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
  :unlock_condition(
    {"Win a run with", "{C:attention}#deck#{}"},
    { deck = ABC.VARS.Deck("b_anaglyph") },
    function(self, args, ABCU)
        if args.type == 'discover_amount' or args.type == 'win_deck' then
            return ABCU.vars.deck:get_win_max_stake() > 0
        end
    end
  )
  :register()