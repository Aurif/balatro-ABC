---
--- Created by Aurif.
--- DateTime: 26/02/2025 20:21
---

---
--- Base
---

---@class ABC.VARS.Deck : ABC.VAR
---@field value string
---A variable class representing a deck. Mostly useful for unlock checks.
---***
---\@*param* `value` — Key of the deck.
---@overload fun(value: string): ABC.VARS.Deck
ABC.VARS.Deck = classABCVar("Deck")

---Returns highest stake that was won with this deck.
---***
---@return integer stake Highest stake that was won with this deck.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/checkered_joker.lua)
function ABC.VARS.Deck:get_win_max_stake()
    return get_deck_win_stake(self.value)
end
