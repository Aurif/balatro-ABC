---
--- Created by Aurif.
--- DateTime: 16/03/2025 19:10
---

---
--- Base
---

---@class ABC.VARS.PokerHand : ABC.VAR
---@field value string
---A variable class representing a poker hand (like `Two Pair` or `High Card`).
---***
---\@*param* `value` — Key of the poker hand.
---@overload fun(value: string): ABC.VARS.PokerHand
ABC.VARS.PokerHand = classABCVar("PokerHand")


---Returns true if provided set of cards contains this poker hand.\
---Example: `Two Pair` contains `Two Pair`, `Pair`, and `High Card`.
---***
---@param cards Card[] List of cards to check against.
---@return boolean contains True if cards contain this poker hand.
function ABC.VARS.PokerHand:cards_contain(cards)
    local _,_,poker_hands,_,_ = G.FUNCS.get_poker_hand_info(cards)
    return #poker_hands[self.value] > 0
end

---Returns true if provided set of cards scores as this poker hand.
---***
---@param cards Card[] List of cards to check against.
---@return boolean match True if cards are scored as this poker hand.
function ABC.VARS.PokerHand:cards_is(cards)
    local hand_name,_,_,_,_ = G.FUNCS.get_poker_hand_info(cards)
    return hand_name == self.value
end

---Returns true if played hand contains this poker hand.\
---Example: `Two Pair` contains `Two Pair`, `Pair`, and `High Card`.
---***
---@return boolean contains True if cards contain this poker hand.
function ABC.VARS.PokerHand:played_hand_contains()
    return self:cards_contain(G.play.cards)
end

---Returns true if played hand scores as this poker hand.
---***
---@return boolean match True if cards are scored as this poker hand.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/leveling_joker.lua)
function ABC.VARS.PokerHand:played_hand_is()
    return self:cards_is(G.play.cards)
end

---Returns the poker hand that is "one above" this one.
---***
---@return ABC.VARS.PokerHand|nil hand Poker hand that is "one above" this one, or nil if this is the last one.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/leveling_joker.lua)
function ABC.VARS.PokerHand:get_next_in_line()
    local hands = {}
    for k, v in pairs(G.GAME.hands) do
        table.insert(hands, {k, v})
    end
    table.sort(hands, function(a, b) return a[2].order < b[2].order end)
    local i = nil
    for k, v in pairs(hands) do
        if v[1] == self.value then
            i = k
            break
        end
    end
    if i == nil or i == 1 then
        return nil
    end
    return ABC.VARS.PokerHand(hands[i-1][1])
end

---Returns the poker hand that is "one below" this one.
---***
---@return ABC.VARS.PokerHand|nil hand Poker hand that is "one below" this one, or nil if this is the first one.
function ABC.VARS.PokerHand:get_previous_in_line()
    local hands = {}
    for k, v in pairs(G.GAME.hands) do
        table.insert(hands, {k, v})
    end
    table.sort(hands, function(a, b) return a[2].order < b[2].order end)
    local i = nil
    for k, v in pairs(hands) do
        if v[1] == self.value then
            i = k
            break
        end
    end
    if i == nil or i == #hands then
        return nil
    end
    return ABC.VARS.PokerHand(hands[i+1][1])
end


---@private
function ABC.VARS.PokerHand:_localize()
    return {
        text=localize(self.value, "poker_hands")
    }
end

