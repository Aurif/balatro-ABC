---
--- Created by Aurif.
--- DateTime: 05/03/2025 18:04
---

ABC.Joker("Evil Red Seal")
    :description({ "Retrigger cards without", "{V:1}#seal#{}" })
    :variables({
        seal = ABC.VARS.Seal("red_seal")
    })
    :rarity_rare()
    :calculate(function(self, card, context, ABCU)
        ABCU:on_card_should_retrigger(function(scored_card)
            if not ABCU.vars.seal:card_is_exactly(scored_card) then
                return 1
            end
            return 0
        end)
    end)
    :unlock_condition(
        {"Have at least 10 cards", "with {V:1}#seal#{} in deck"},
        { seal = ABC.VARS.Seal("red_seal") },
        function(self, args, ABCU)
            if args.type == "modify_deck" then
                return ABCU:get_count_in_deck(bind(ABCU.vars.seal.card_is_exactly, ABCU.vars.seal)) > 10
            end
        end
    )
    :register()
