---
--- Created by Aurif.
--- DateTime: 04/02/2025 21:00
---

ABC.Joker("Electrician")
  :description({"Scored cards have {C:green,E:1,S:1.1}#probability#{}", "chance to become a {C:attention}#enhancement#{}", "{s:0.8}(replaces current enhancement){}"})
  :variables({
    enhancement=ABC.VARS.Enhancement("m_snow_platinum_card"),
    probability=ABC.VARS.Probability(4)
  })
  :rarity_rare()
  :calculate(function(_, card, context, ABCU)
    if context.after and context.scoring_hand and not context.blueprint then
        for i = 1, #context.scoring_hand do
            local other_card = context.scoring_hand[i]
            if not ABCU.vars.enhancement:card_is(other_card) and ABCU.vars.probability:triggers() then
                ABC.Animations.modify_card(
                    function()
                        ABCU.vars.enhancement:card_set(other_card)
                    end,
                    other_card, card
                )
            end
        end
    end
  end)
  :register()
