---
--- Created by Aurif.
--- DateTime: 03/02/2025 20:52
---

---@class ABC.Animations
ABC.Animations = class()

--
-- Utilities
--
local function event(config)
    local e = Event(config)
    G.E_MANAGER:add_event(e)
    return e
end

--
-- Animations
--
function ABC.Animations.modify_card(callback, card, joker_card)
    event({ trigger = 'after', delay = 0.15,
        func = function()
            card:flip();
            play_sound('card1', 1);
            card:juice_up(0.3, 0.3);
            return true
        end
    })
    event({ trigger = 'after', delay = 0.1,
        func = function()
            callback()
            return true
        end
    })
    event({ trigger = 'after', delay = 0.15,
        func = function()
            card:flip();
            play_sound('tarot2', 1, 0.6);
            if joker_card then
                joker_card:juice_up(0.7);
            end
            card:juice_up(0.3, 0.3);
            return true
        end
    })
end

function ABC.Animations.jiggle_card(callback, card, joker_card)
    event({ trigger = 'after', delay = 0.25,
        func = function()
            callback()
            if joker_card then
                joker_card:juice_up(0.7);
            end
            card:juice_up(0.3, 0.3);
            play_sound('tarot2', 1, 0.6);
            return true
        end
    })
end

function ABC.Animations.display_text(card, message, colour)
    card_eval_status_text(card, 'extra', nil, nil, nil, {message = message, colour = colour})
end