---
--- Created by Aurif.
--- DateTime: 27/03/2025 16:51
---

ABC.Joker("Emicare Camera")
    :description({ "When destroyed, create a", "{C:dark_edition}#edition#{} and {V:1}#sticker#{} copy", "of all other jokers" })
    :variables({
        edition = ABC.VARS.Edition("e_negative"),
        sticker = ABC.VARS.Sticker("eternal"),
    })
    :rarity_exotic()
    :calculate(function(self, card, context, ABCU)
        ABCU:on_self_destroyed(function ()
            for _, joker in pairs(ABCU:get_other_jokers()) do
                ABC.VARS.Joker(joker):spawn({ABCU.vars.edition, ABCU.vars.sticker})
            end
        end)
    end)
    :register()
