---
--- Created by Aurif.
--- DateTime: 21/01/2025 00:37
---

function random_choice(options, seed)
    math.randomseed(pseudohash(seed))
    return options[ math.random( #options ) ]
end