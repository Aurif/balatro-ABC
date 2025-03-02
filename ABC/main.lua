ABC = {}
__ABC = {}
SMODS.load_file("utils.lua")()

SMODS.load_file("base/vars/_common.lua")()
SMODS.load_file("base/vars/enhancement.lua")()
SMODS.load_file("base/vars/probability.lua")()
SMODS.load_file("base/vars/suit.lua")()
SMODS.load_file("base/vars/deck.lua")()
SMODS.load_file("base/vars/tag.lua")()
SMODS.load_file("base/vars/joker.lua")()

SMODS.load_file("base/calculate.lua")()
SMODS.load_file("base/joker.lua")()
SMODS.load_file("extensions/joker-evolution.lua")()

SMODS.load_file("base/animations.lua")()