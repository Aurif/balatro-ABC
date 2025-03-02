---
--- Created by Aurif.
--- DateTime: 02/03/2025 03:50
---

---
--- Base
---

---@class ABC.VARS.Joker : ABC.VAR
---@field value string
---A variable class representing statistics of a joker. Mostly useful for unlock checks.\
---If you want to create your own joker, use [ABC.Joker](https://github.com/Aurif/balatro-ABC/wiki/Joker) instead.
---***
---\@*param* `value` — Key of the joker.
---@overload fun(value: string): ABC.VARS.Joker
ABC.VARS.Joker = classABCVar("Joker")

---Checks if joker has been discovered.
---***
---@return boolean is_discovered True if joker has been discovered.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/yang.lua)
function ABC.VARS.Joker:is_discovered()
    return G.P_CENTERS[self.value].discovered
end
