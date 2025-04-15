---
--- Created by Aurif.
--- DateTime: 14/04/2025 16:24
---

local orig_misprintize_tbl = Cryptid.misprintize_tbl
function Cryptid.misprintize_tbl(name, ref_tbl, ref_value, clear, override, stack, big)
    local result = orig_misprintize_tbl(name, ref_tbl, ref_value, clear, override, stack, big)
    if clear or ref_value ~= "ability" then return result end
    if (override and override.min or G.GAME.modifiers.cry_misprint_min) == 1 and (override and override.max or G.GAME.modifiers.cry_misprint_max) == 1 then
        return result
    end
    if not __ABC.VARIABLE_TYPE_DEFS[name] then
        return result
    end

    for key, def in pairs(__ABC.VARIABLE_TYPE_DEFS[name]) do
        if def.random then
            ref_tbl.ability.extra[key] = def(ref_tbl.ability.extra[key]):random(pseudoseed("misprintize")).value
        end
    end

    return result
end

return {}