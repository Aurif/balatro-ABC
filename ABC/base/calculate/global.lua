---
--- Created by Aurif.
--- DateTime: 05/03/2025 20:19
---

---
--- Base
---

---@class ABC.CalculateUtil
---@field vars any Allows access to defined variables.<br/>This is a table-like property, variables can be read with `ABCU.vars.suit` and set with `ABCU.vars.suit = ...`.
---@overload fun(): ABC.CalculateUtil private
__ABC.CalculateUtil = class()

---
--- Getters
---

--- Returns number of elements in table that match provided criteria.
---***
--- @param target table Target table to count in.
--- @param condition? fun(el): boolean Condition to use during counting. If not provided, will return size of the table.
--- @return integer count Number of elements that match the criteria.
function __ABC.CalculateUtil:get_count_in(target, condition)
    if condition == nil then
        return #target
    end
    local count = 0
    for k, el in pairs(target) do
        if condition(el) then
            count = count + 1
        end
    end
    return count
end

--- Returns number of cards in the undrawn deck that match provided criteria.
---***
--- @param condition? fun(el: Card): boolean Condition to use during counting. If not provided, will return the number of cards.
--- @return integer count Number of elements that match the criteria.
function __ABC.CalculateUtil:get_count_in_undrawn(condition)
    return self:get_count_in(G.deck.cards, condition)
end

--- Returns number of cards in player's hand that match provided criteria.
---***
--- @param condition? fun(el: Card): boolean Condition to use during counting. If not provided, will return the number of cards.
--- @return integer count Number of elements that match the criteria.
function __ABC.CalculateUtil:get_count_in_hand(condition)
    return self:get_count_in(G.hand.cards, condition)
end

--- Returns number of cards from discarded cards that match provided criteria.
---***
--- @param condition? fun(el: Card): boolean Condition to use during counting. If not provided, will return the number of cards.
--- @return integer count Number of elements that match the criteria.
function __ABC.CalculateUtil:get_count_in_discard(condition)
    return self:get_count_in(G.discard.cards, condition)
end

--- Returns number of cards in the whole deck that match provided criteria.
---***
--- @param condition? fun(el: Card): boolean Condition to use during counting. If not provided, will return the number of cards.
--- @return integer count Number of elements that match the criteria.
function __ABC.CalculateUtil:get_count_in_deck(condition)
    return self:get_count_in_undrawn(condition)
     + self:get_count_in_hand(condition)
     + self:get_count_in_discard(condition)
end


---
--- Internal
---


---@private
function __ABC.CalculateUtil:_pre_trigger_check()
    return true
end