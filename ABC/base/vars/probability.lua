---
--- Created by Aurif.
--- DateTime: 04/02/2025 22:10
---
ABC.VARS.Probability = {}

function ABC.VARS.Probability:new(value)
    local o = { value = value }
    setmetatable(o, self)
    self.__index = self
    return o
end

function ABC.VARS.Probability:_localize()
    return {
        text= (G.GAME and G.GAME.probabilities.normal or 1) .. ' in ' .. self.value
    }
end

function ABC.VARS.Probability:triggers()
    return pseudorandom('probability_seed') < G.GAME.probabilities.normal / self.value
end