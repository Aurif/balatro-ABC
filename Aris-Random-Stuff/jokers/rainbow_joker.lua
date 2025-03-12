---
--- Created by Aurif.
--- DateTime: 12/03/2025 21:12
---

ABC.Joker("Rainbow Joker")
    :description({ "All scored {V:1}#suit#{} cards", "permanently gain {X:red,C:white}+X#x_mult#{} mult,", "suit changes every round" })
    :variables({
        suit = ABC.VARS.Suit('Spades'),
        x_mult = 0.1
    })
    :rarity_legendary()
    :calculate(function(self, card, context, ABCU)
        ABCU:on_round_start(function()
            ABCU.vars.suit = ABC.VARS.Suit:random(pseudoseed('rainbow' .. G.GAME.round_resets.ante))
        end)
        ABCU:on_card_post_scored(function(scored_card)
            if ABCU.vars.suit:card_is(scored_card) then
                ABC.Animations.jiggle_card(
                    function() ABCU:do_card_bonus_permanent_add(scored_card, "mult_multiply", ABCU.vars.x_mult) end,
                    scored_card, card
                )
            end
        end)
    end)
    :register()
