---
--- Created by Aurif.
--- DateTime: 16/03/2025 11:20
---

ABC.Joker("Buffering Joker")
  :description({"After {C:attention}#round_count#{} rounds", "spawn {C:attention}#joker#{}", "{C:red,E:2}self destructs{}"})
  :rarity_uncommon()
  :variables({
    rarity = ABC.VARS.Rarity("Rare"),
    joker = ABC.VARS.Joker("j_blueprint"),
    round_count = 3
  })
  :calculate(function(self, card, context, ABCU)
    local function update_sprite()
        local pos = { x = 0, y = 0 }
        if ABCU.vars.round_count <= 2 then pos = { x = 0, y = 1 } end
        if ABCU.vars.round_count <= 1 then pos = { x = 0, y = 2 } end
        ABCU:do_self_sprite_change(pos)
    end

    ABCU:on_self_setup(function()
        ABCU.vars.joker = ABCU.vars.rarity:random_joker(pseudoseed("Buffering Joker"))
    end)
    ABCU:on_self_sprite_init(update_sprite)
    ABCU:on_round_end(function ()
        if ABCU.vars.round_count <= 1 then
            ABCU:do_self_destroy()
            ABCU.vars.joker:spawn()
        else
            ABCU.vars.round_count = ABCU.vars.round_count-1
            ABC.Animations.display_text(card, ABCU.vars.round_count)
            update_sprite()
        end
    end)
  end)
  :incompat_eternal()
  :incompat_perishable()
  :debug_force_in_shop()
  :register()