---
--- Created by Aurif.
--- DateTime: 28/03/2025 21:29
---

---
--- Rarities
---

---Sets rarity of the joker to **epic**.\
---Automatically sets the default buy price.
---***
---@generic J: ABC.Joker
---@param self J
---@param downgrade_to_rare? boolean Determines behaviour when [Cryptid](https://github.com/MathIsFun0/Cryptid) is not installed. If true, will instead become a rare card, if false, won't be registered at all. True by default.
---@return J self for chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/protogen.lua)
function ABC.Joker:rarity_epic(downgrade_to_rare)
    if not self.raw.cost then
        self:cost(random_choice({ 13, 14, 14, 15, 15, 16, 16, 17, 17, 18 }, self.meta.full_name))
    end
    if #SMODS.find_mod("Cryptid") == 0 then
        if downgrade_to_rare == true or downgrade_to_rare == nil then
            self:rarity_rare()
        else
            self.meta.prevent_registration = true
        end
        return self
    end

    self.raw.rarity = "cry_epic"

    return self
end

---Sets rarity of the joker to **exotic**.\
---Exotic jokers require a two-part sprite.\
---Automatically sets the default buy price.
---***
---@generic J: ABC.Joker
---@param self J
---@param downgrade_to_legendary? boolean Determines behaviour when [Cryptid](https://github.com/MathIsFun0/Cryptid) is not installed. If true, will instead become a legendary card, if false, won't be registered at all. False by default.
---@return J self for chaining.
---***
---[Example usage](https://github.com/Aurif/balatro-ABC/blob/main/Aris-Random-Stuff/jokers/emicare_camera.lua)
function ABC.Joker:rarity_exotic(downgrade_to_legendary)
    if not self.raw.cost then
        self:cost(50)
    end
    if #SMODS.find_mod("Cryptid") == 0 then
        if downgrade_to_legendary == true then
            self:rarity_legendary()
        else
            self.meta.prevent_registration = true
        end
        return self
    end

    self.raw.rarity = "cry_exotic"
    self.raw.soul_pos = { x = 1, y = 0 }

    return self
end