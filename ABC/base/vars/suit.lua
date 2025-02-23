---
--- Created by Aurif.
--- DateTime: 30/01/2025 22:08
---

---
--- Base
---

---@class ABC.VARS.Suit : ABC.VAR
---@field value string
---A variable class representing card suit.
---***
---\@*param* `value` — Key of the suit. For default suits it should be `Hearts`, `Clubs`, `Diamonds`, or `Spades`.
---@overload fun(value: string): ABC.VARS.Suit
ABC.VARS.Suit = classABCVar("Suit")

---Returns a random suit from those present in the pool.
---***
---@param seed number Seed to use for rng.
---@return ABC.VARS.Suit suit Randomly picked suit.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/checkered_joker.lua)
function ABC.VARS.Suit:random(seed)
    local valid_suits = {}
    for _, v in pairs(SMODS.Card.SUITS) do
        if not v.disabled and (not v.in_pool or v.in_pool({})) then
            table.insert(valid_suits, v.name)
        end
    end
    return ABC.VARS.Suit(pseudorandom_element(valid_suits, seed))
end

---Sets suit of provided card to self.
---***
---@param card Card Card which will be changed.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/checkered_joker.lua)
function ABC.VARS.Suit:card_set(card)
    card:change_suit(self.value)
end

---Checks if card's base suit matches self (without including effects like wildcard).
---***
---@param card Card Card to check.
---@return boolean matches True if base card has this suit, false otherwise.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/checkered_joker.lua)
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
