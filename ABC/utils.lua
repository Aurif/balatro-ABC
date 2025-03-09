---
--- Created by Aurif.
--- DateTime: 21/01/2025 00:37
---

function random_choice(options, seed)
    math.randomseed(pseudohash(seed))
    return options[math.random(#options)]
end

function bind(method, a)
    return function(...)
        return method(a, ...)
    end
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

function __ABC.make_localization_function(vars_definition, value_getter)
    local var_wrappers = {}
    local key_order = {}
    for k, v in pairs(vars_definition) do
        if type(v) == "table" and getmetatable(v).__is_abc_var then
            var_wrappers[k] = getmetatable(v)
        end
        table.insert(key_order, k)
    end
    table.sort(key_order)

    return function(_1, _2, _3)
        local values = value_getter(_1, _2, _3)
        local loc_vars = {}
        for _, k in ipairs(key_order) do
            if var_wrappers[k] and var_wrappers[k]._localize then
                local wrapper = var_wrappers[k]
                local localization = wrapper(values[k]):_localize()
                table.insert(loc_vars, localization.text)
                for extra_k, extra_v in pairs(localization.extra or {}) do
                    if not loc_vars[extra_k] then
                        loc_vars[extra_k] = {}
                    end
                    table.insert(loc_vars[extra_k], extra_v)
                end
            else
                table.insert(loc_vars, values[k])
            end
        end
        return { vars = loc_vars }
    end
end

function __ABC.substitute_description_vars(description, vars)
    if not description then
        return description
    end

    local key_order = {}
    for k, _ in pairs(vars) do
        table.insert(key_order, k)
    end
    table.sort(key_order)

    local new_description = {}
    for i, line in pairs(description) do
        print(line)
        for j, k in ipairs(key_order) do
            line = line:gsub("#" .. k .. "#", "#" .. j .. "#")
        end
        new_description[i] = line
    end

    return new_description
end

function __ABC.unwrap_variables(vars_definition)
    local var_wrappers = {}
    local variables = {}
    for k, v in pairs(vars_definition) do
        if type(v) == "table" and getmetatable(v).__is_abc_var then
            var_wrappers[k] = getmetatable(v)
            variables[k] = v.value
        else
            variables[k] = v
        end
    end
    return variables, var_wrappers
end