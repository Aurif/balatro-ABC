---
--- Created by Aurif.
--- DateTime: 30/01/2025 22:08
---

---@class ABC.VARS.Suit
---@field value string
---@overload fun(value: string): ABC.VARS.Suit
ABC.VARS.Suit = classABCVar()

function ABC.VARS.Suit:random(seed)
    local valid_suits = {}
    for _, v in pairs(SMODS.Card.SUITS) do
        if not v.disabled and (not v.in_pool or v.in_pool({})) then
            table.insert(valid_suits, v.name)
        end
    end
    return ABC.VARS.Suit(pseudorandom_element(valid_suits, seed))
end

function ABC.VARS.Suit:card_set(card)
    card:change_suit(self.value)
end

function ABC.VARS.Suit:card_is_exactly(card)
    return card.base.suit == self.value
end

---@private
function ABC.VARS.Suit:_localize()
    return {
        text=localize(self.value, 'suits_plural'),
        extra={
            colours=G.C.SUITS[self.value]
        }
    }
end
