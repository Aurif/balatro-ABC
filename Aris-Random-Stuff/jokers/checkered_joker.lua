---
--- Created by Aurif.
--- DateTime: 20/01/2025 23:00
---

ABC.Joker:new("Checkered Joker")
  :description({"All scored cards become", "{V:1}#suit#{}, suit changes", "every round"})
  :variables({
      suit = ABC.VARS.Suit:new('Spades'),
  })
  :rarity_common()
  :calculate(function(self, card, context)
    if context.setting_blind and not self.getting_sliced then
        card.ability.extra.suit = ABC.VARS.Suit:random(pseudoseed('checkered'..G.GAME.round_resets.ante)).value
    end
    if context.individual and context.cardarea == G.play and not context.blueprint then
        context.other_card:change_suit(card.ability.extra.suit)
    end
  end)
  :register()