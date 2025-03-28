---
--- Created by Aurif.
--- DateTime: 28/03/2025 19:23
---

---
--- Base
---

---@class ABC.VARS.Sticker : ABC.VAR
---@field value string
---A variable class representing card sticker.
---***
---\@*param* `value` — Key of the sticker.
---@overload fun(value: string): ABC.VARS.Sticker
ABC.VARS.Sticker = classABCVar("Sticker")


---Sets sticker of provided card to self, only if the card is compatible with it.
---***
---@param card SMODS.Joker Card which will be changed.
---@return boolean applied Returns true if the sticker was actually applied, false otherwise.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/emicare_camera.lua)
function ABC.VARS.Sticker:card_set(card)
    local sticker = SMODS.Stickers[self.value]
    if card.config.center[self.value .. "_compat"] == false then
        return false
    end

    sticker:apply(card, true)
    return true
end


---@private
function ABC.VARS.Sticker:_localize()
    return {
        text=localize(self.value, "labels"),
        extra={
            colours=SMODS.Stickers[self.value].badge_colour
        }
    }
end
