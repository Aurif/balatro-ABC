---
--- Created by Aurif.
--- DateTime: 16/03/2025 18:52
---

ABC.Joker("Leveling Joker")
  :description({"If scored hand is {C:attention}#hand#{}", "gain {X:red,C:white}+X#extra_x_mult#{} mult,", "hand changes afterwards", "Currently {X:red,C:white}X#x_mult#{}"})
  :rarity_uncommon()
  :variables({
    hand = ABC.VARS.PokerHand("High Card"),
    x_mult = 1,
    extra_x_mult = 0.5
  })
  :calculate(function(self, card, context, ABCU)
    ABCU:on_hand_scored(function ()
        if ABCU.vars.hand:played_hand_is() then
            ABCU.vars.x_mult = ABCU.vars.x_mult + ABCU.vars.extra_x_mult
            ABC.Animations.display_text(card, "Level Up!", G.C.MULT)
            local next_hand = ABCU.vars.hand:get_next_in_line()
            if next_hand ~= nil then
                ABCU.vars.hand = next_hand
            end
        end
        ABCU:do_mult_multiply(ABCU.vars.x_mult)
    end)
  end)
  :register()
