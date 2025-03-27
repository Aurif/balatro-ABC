---
--- Created by Aurif.
--- DateTime: 17/03/2025 16:19
---

ABC.Joker("Egg Ascended")
    :description({ "Increases sell value of", "all jokers by {C:money}$#amount#{} every round", "gain a {V:1}#rarity#{} joker", "when sold" })
    :variables({
        amount = 5,
        rarity = ABC.VARS.Rarity("Legendary")
    })
    :rarity_legendary()
    :calculate(function(self, card, context, ABCU)
        ABCU:on_round_end(function()
            for _, joker in ipairs(ABCU:get_other_jokers()) do
                ABCU:do_joker_sell_value_add(joker, ABCU.vars.amount)
            end
            ABCU:do_joker_sell_value_add(card, ABCU.vars.amount)
        end)

        ABCU:on_self_destroyed(function (is_sold)
            if is_sold then
                ABCU.vars.rarity:random_joker(pseudoseed("Egg")):spawn()
            end
        end)
    end)
    :register()
