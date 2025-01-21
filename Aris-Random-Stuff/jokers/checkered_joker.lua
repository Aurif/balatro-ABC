---
--- Created by Aurif.
--- DateTime: 20/01/2025 23:00
---

ABC.Joker:new("Checkered Joker")
  :description({"All scored cards become", "{C:attention}#suit#{}, suit changes", "every round"})
  :variables({
      suit = 'Spades',
  })
  :rarity_common()
  :calculate(function(self, card, context)
    if context.setting_blind and not self.getting_sliced then
        local valid_suits = {}
        for _, v in pairs(SMODS.Card.SUITS) do
            if not v.disabled and (not v.in_pool or v.in_pool({})) then
                table.insert(valid_suits, v.name)
            end
        end
        card.ability.extra.suit = pseudorandom_element(valid_suits, pseudoseed('checkered'..G.GAME.round_resets.ante))
    end
    if context.individual and context.cardarea == G.play and not context.blueprint then
        context.other_card:change_suit(card.ability.extra.suit)
    end
  end)
  :register()