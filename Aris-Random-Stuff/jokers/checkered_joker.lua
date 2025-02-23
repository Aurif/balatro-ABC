---
--- Created by Aurif.
--- DateTime: 20/01/2025 23:00
---

ABC.Joker("Checkered Joker")
    :description({ "All scored cards become", "{V:1}#suit#{}, suit changes", "every round" })
    :variables({
        suit = ABC.VARS.Suit('Spades'),
    })
    :rarity_common()
    :calculate(function(self, card, context, ABCU)
        ABCU:on_round_start(function()
            ABCU.vars.suit = ABC.VARS.Suit:random(pseudoseed('checkered' .. G.GAME.round_resets.ante))
        end)
        ABCU:on_card_post_scored(function(scored_card)
            if not ABCU.vars.suit:card_is_exactly(scored_card) then
                ABC.Animations.modify_card(
                    function() ABCU.vars.suit:card_set(scored_card) end,
                    scored_card, card
                )
            end
        end)
    end)
    :register()
