---
--- Created by Aurif.
--- DateTime: 04/02/2025 22:10
---

---
--- Base
---

---@class ABC.VARS.Probability : ABC.VAR
---@field value number
---A variable class representing a chance of an event occuring.
---***
---\@*param* `value` — Chance for event to occur. For example, value of 20 means "1 in 20" probability of happening.
---@overload fun(value: number): ABC.VARS.Probability
ABC.VARS.Probability = classABCVar("Probability")

---Check if the random event should occur.\
---This should be the preffered way of handling probability-based events.
---***
---@return boolean occurs True if probability check passed, false otherwise.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/electrician.lua)
function ABC.VARS.Probability:triggers()
    return pseudorandom('probability_seed') < G.GAME.probabilities.normal / self.value
end

---@private
function ABC.VARS.Probability:_localize()
    return {
        text= (G.GAME and G.GAME.probabilities.normal or 1) .. ' in ' .. self.value
    }
end