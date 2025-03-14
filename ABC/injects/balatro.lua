---
--- Created by Aurif.
--- DateTime: 14/03/2025 20:07
---

local sc = Card.set_cost
function Card:set_cost()
    sc(self)
    if self.base_cost <= 0 then
        self.cost = self.base_cost
        self.sell_cost = self.ability.extra_value or 0
        self.sell_cost_label = (self.facing == 'back' and '?') or (G.GAME.modifiers.cry_no_sell_value and 0) or self.sell_cost
    end
end