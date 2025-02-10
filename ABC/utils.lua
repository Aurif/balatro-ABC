---
--- Created by Aurif.
--- DateTime: 21/01/2025 00:37
---

function random_choice(options, seed)
    math.randomseed(pseudohash(seed))
    return options[math.random(#options)]
end

-- Compatible with Lua 5.1 (not 5.0).
function class(base, init)
    local c = {}    -- a new class instance
    if not init and type(base) == 'function' then
        init = base
        base = nil
    elseif type(base) == 'table' then
        -- our new class is a shallow copy of the base class!
        for i, v in pairs(base) do
            c[i] = v
        end
        c._base = base
    end
    -- the class will be the metatable for all its objects,
    -- and they will look up their methods in it.
    c.__index = c

    if init and not c.__init__ then
        c.__init__ = init
    end

    -- expose a constructor which can be called by <classname>(<args>)
    local mt = {}
    mt.__call = function(class_tbl, ...)
        local obj = {}
        setmetatable(obj, c)
        if obj.__init__ then
            obj:__init__(...)
        else
            -- make sure that any stuff from the base class is initialized!
            if base and base.__init__ then
                base.__init__(obj, ...)
            end
        end
        return obj
    end
    setmetatable(c, mt)
    return c
end