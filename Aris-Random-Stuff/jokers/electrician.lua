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
    ABCU:on_card_post_scored(function(scored_card)
        if not ABCU.vars.enhancement:card_is_exactly(scored_card) and ABCU.vars.probability:triggers() then
            ABC.Animations.modify_card(
                function() ABCU.vars.enhancement:card_set(scored_card) end,
                scored_card, card
            )
        end
    end)
  end)
  :register()
