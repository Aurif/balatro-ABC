---
--- Created by Aurif.
--- DateTime: 03/03/2025 22:40
---

ABC.Joker("Mutually Assured Destruction")
  :description({"Gives {X:red,C:white}X#x_mult#{} mult, when this joker is", "destroyed {C:attention}destroy all jokers{},", "if it's sold {C:attention}destroy a random{}", "{C:attention}joker{} instead"})
  :variables({
    x_mult=3
  })
  :rarity_uncommon()
  :calculate(function(self, card, context, ABCU)
    ABCU:on_self_destroyed(function(was_sold)
        local other_jokers = ABCU:get_other_jokers()
        pseudoshuffle(other_jokers, pseudoseed("M.A.D."))
        for _, j in pairs(other_jokers) do
            local did_destroy = ABCU:do_joker_destroy(j)
            if did_destroy and was_sold then
                break
            end
        end
    end)
    ABCU:on_hand_scored(function()
        ABCU:do_mult_multiply(ABCU.vars.x_mult)
    end)
  end)
  :unlock_condition(
    {"Complete the", "{C:attention}#challenge#{}", "challenge"},
    { challenge = ABC.VARS.Challenge('c_knife_1') },
    function (self, args, vars)
        if args.win_challenge then
            return vars.challenge:is_completed()
        end
    end
  )
  :register()