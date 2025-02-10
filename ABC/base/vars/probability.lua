---
--- Created by Aurif.
--- DateTime: 04/02/2025 22:10
---

---@class ABC.VARS.Probability
local Probability = classABCVar()
ABC.VARS.Probability = Probability

function ABC.VARS.Probability:triggers()
    return pseudorandom('probability_seed') < G.GAME.probabilities.normal / self.value
end

---@private
function ABC.VARS.Probability:_localize()
    return {
        text= (G.GAME and G.GAME.probabilities.normal or 1) .. ' in ' .. self.value
    }
end