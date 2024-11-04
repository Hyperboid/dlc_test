return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene BattleCutscene
    susie_punch = function(cutscene, battler, enemy)
        -- Open textbox and wait for completion
        cutscene:text("* Susie threw a barrage of punches at\nthe dummy!")

        -- Hurt the target enemy for 1 damage
        for i=1,4 do
            Assets.stopAndPlaySound("damage")
            enemy:hurt(1 - enemy.defense, battler)
            if enemy.health <= 1 then break end
            if not Input.down("menu") then
                cutscene:wait(Utils.random(0.01, 0.2))
            end
        end
        -- Wait 1 second
        cutscene:wait(1)

        -- Susie text
        local sussy = Utils.pick{
            {"* Yeah! Take THAT,[wait:5] you,[wait:15] [face:nervous_side]... big...[wait:10] weenie...", "teeth_b"},
            {"* Why the hell is it so firm!??", "teeth_b"},
            {"* So...[wait:5] uh,[wait:5] why exactly are we beating up this thing?[wait:40]\n* Yeah, didn't think so.", "nervous_side"},
        }
        cutscene:text(sussy[1], sussy[2], "susie")

        if cutscene:getCharacter("ralsei") then
            -- Ralsei text, if he's in the party
            cutscene:text("* Aww,[wait:5] Susie!", "blush_pleased", "ralsei")
        end
    end
}