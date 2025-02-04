---
--- Created by Aurif.
--- DateTime: 04/02/2025 21:00
---

ABC.Joker:new("Electrician")
  :description({"Scored cards have {C:green,E:1,S:1.1}#probability#{}", "chance to become a {C:attention}#enhancement#{}", "(replaces current enhancement)"})
  :variables({
    enhancement=ABC.VARS.Enhancement:new("m_snow_platinum_card"),
    probability=ABC.VARS.Probability:new(8)
  })
  :rarity_rare()
  :calculate(function(self, card, context)
    if context.after and context.scoring_hand and not context.blueprint then
        for i = 1, #context.scoring_hand do
            local other_card = context.scoring_hand[i]
            if ABC.VARS.Probability:new(card.ability.extra.probability):triggers() then
                ABC.Animations.modify_card(
                    function()
                        ABC.VARS.Enhancement:new(card.ability.extra.enhancement):card_set(other_card)
                    end,
                    other_card, card
                )
            end
        end
    end
  end)
  :register()