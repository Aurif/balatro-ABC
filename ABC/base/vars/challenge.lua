---
--- Created by Aurif.
--- DateTime: 04/03/2025 16:05
---

---
--- Base
---

---@class ABC.VARS.Challenge : ABC.VAR
---@field value string
---A variable class representing statistics of a challenge. Mostly useful for unlock checks.
---***
---\@*param* `value` — Key of the challenge.
---@overload fun(value: string): ABC.VARS.Challenge
ABC.VARS.Challenge = classABCVar("Challenge")

---Checks if this challenge was completed.
---***
---@return boolean completed True if the challenge was completed, false otherwise.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/mutually_assured_destruction.lua)
function ABC.VARS.Challenge:is_completed()
    return G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[self.value]
end

---@private
function ABC.VARS.Challenge:_localize()
    return {
        text=localize(self.value, 'challenge_names')
    }
end