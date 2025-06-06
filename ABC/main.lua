ABC = {}
__ABC = {}
__ABC.VARIABLE_TYPE_DEFS = {}
SMODS.load_file("utils.lua")()

SMODS.load_file("injects/balatro.lua")()

SMODS.load_file("base/vars/_common.lua")()
SMODS.load_file("base/vars/enhancement.lua")()
SMODS.load_file("base/vars/probability.lua")()
SMODS.load_file("base/vars/suit.lua")()
SMODS.load_file("base/vars/deck.lua")()
SMODS.load_file("base/vars/tag.lua")()
SMODS.load_file("base/vars/joker.lua")()
SMODS.load_file("base/vars/challenge.lua")()
SMODS.load_file("base/vars/seal.lua")()
SMODS.load_file("base/vars/rarity.lua")()
SMODS.load_file("base/vars/poker_hand.lua")()
SMODS.load_file("base/vars/edition.lua")()
SMODS.load_file("base/vars/sticker.lua")()
SMODS.load_file("base/vars/tarot.lua")()

SMODS.load_file("base/calculate/global.lua")()
SMODS.load_file("base/calculate/joker.lua")()
SMODS.load_file("base/calculate/unlock.lua")()

SMODS.load_file("base/joker.lua")()
SMODS.load_file("extensions/joker-evolution.lua")()
SMODS.load_file("extensions/cryptid.lua")()

SMODS.load_file("base/animations.lua")()