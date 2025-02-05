--- STEAMODDED HEADER
--- MOD_NAME: Ari's Balatro (modding) Core
--- MOD_ID: ari_core
--- MOD_AUTHOR: [Aurif]
--- MOD_DESCRIPTION: A library for an object-oriented approach to modding balatro
--- BADGE_COLOUR: 2a004b
--- DISPLAY_NAME: Ari's Balatro (modding) Core
--- PREFIX: ari_core
--- VERSION: 0.0.1
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-1030f]

----------------------------------------------
------------MOD CODE -------------------------

SMODS.load_file("utils.lua")()

ABC = {}
ABC.VARS = {}
SMODS.load_file("base/vars/enhancement.lua")()
SMODS.load_file("base/vars/probability.lua")()
SMODS.load_file("base/vars/suit.lua")()

SMODS.load_file("base/calculate.lua")()
SMODS.load_file("base/joker.lua")()
SMODS.load_file("extensions/joker-evolution.lua")()

SMODS.load_file("base/animations.lua")()

----------------------------------------------
------------MOD CODE END----------------------