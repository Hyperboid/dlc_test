return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `WorldCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    wall = function(cutscene, event)
        -- Open textbox and wait for completion
        cutscene:text("* The wall seems cracked.")

        -- If we have Susie, play a cutscene
        local susie = cutscene:getCharacter("susie")
        if susie then
            -- Detach camera and followers (since characters will be moved)
            cutscene:detachCamera()
            cutscene:detachFollowers()

            -- All text from now is spoken by Susie
            cutscene:setSpeaker(susie)
            cutscene:text("* Hey,[wait:5] think I can break\nthis wall?", "smile")

            -- Get the bottom-center of the broken wall
            local x = event.x + event.width/2
            local y = event.y + event.height/2

            -- Move Susie up to the wall over 0.75 seconds
            cutscene:walkTo(susie, x, y + 40, 0.75, "up")
            -- Move other party members behind Susie
            cutscene:walkTo(Game.world.player, x, y + 100, 0.75, "up")
            if cutscene:getCharacter("ralsei") then
                cutscene:walkTo("ralsei", x + 60, y + 100, 0.75, "up")
            end
            if cutscene:getCharacter("noelle") then
                cutscene:walkTo("noelle", x - 60, y + 100, 0.75, "up")
            end

            -- Wait 1.5 seconds
            cutscene:wait(1.5)

            -- Walk back,
            cutscene:wait(cutscene:walkTo(susie, x, y + 60, 0.5, "up", true))
            -- and run forward!
            cutscene:wait(cutscene:walkTo(susie, x, y + 20, 0.2))

            -- Slam!!
            Assets.playSound("impact")
            susie:shake(4)
            susie:setSprite("shock_up")

            -- Slide back a bit
            cutscene:slideTo(susie, x, y + 40, 0.1)
            cutscene:wait(1.5)

            -- owie
            susie:setAnimation({"away_scratch", 0.25, true})
            susie:shake(4)
            Assets.playSound("wing")

            cutscene:wait(1)
            cutscene:text("* Guess not.", "nervous")

            -- Reset Susie's sprite
            susie:resetSprite()

            -- Reattach the camera
            cutscene:attachCamera()

            -- Align the follower positions behind Kris's current position
            cutscene:alignFollowers()
            -- And reattach them, making them return to their target positions
            cutscene:attachFollowers()
            Game:setFlag("wall_hit", true)
        end
    end,

    ---@param cutscene WorldCutscene
    ---@param event NPC
    starw = function(cutscene,event)
        local is_dpr = (Kristal.Mods.data.dpr_main ~= nil)
        if is_dpr then
            local choice = cutscene:textChoicer(
                "* Is this [color:yellow]WORLD[color:reset]   [wait:30]   [color:yellow]Pissing[color:reset] you off?",
                {"Yes", "    No"}
            )
            if choice == 1 then
                Assets.playSound("kristal_intro")
                Game.fader:fadeOut(function ()
                    Game:swapIntoMod("dpr_main", false, "main_hub")
                end, {
                    color = COLORS.white,
                    speed = 2
                })
                cutscene:text("* [noskip][speed:0.4]I'm the original   [color:yellow]Starwalker[color:reset]")
            else
                cutscene:text("* I'm the original   [color:yellow]Starwalker[color:reset]")
            end
        else
            cutscene:text("* These [color:yellow]stairs[color:reset] are [color:yellow]Pissing[color:reset] me\noff...")
            cutscene:text("* I'm the original   [color:yellow]Starwalker[color:reset]")
        end
    end,

    ---@param cutscene WorldCutscene
    ---@param event NPC
    test = function (cutscene, event)
        event:facePlayer()
        local txt = Text("SET ACTOR")
        txt:setParallax(0,0)
        Game.world:spawnObject(txt)
        local actor_id = Game:getFlag("testactor") or (cutscene:getUserText(16)):lower()
        txt:remove()
        local ok,actor = pcall(Registry.createActor, actor_id)
        if not ok then
            cutscene:text("* who tf is "..actor_id.."???")
            return
        end
        if actor_id ~=event.actor.id then
            event:setActor(actor)
        end
        Game.world:addChild(txt):setText("SET FACE")
        local face = Game:getFlag("testface") or (cutscene:getUserText(16)):lower()
        txt:remove()
        if face == "" then face = nil end
        cutscene:text(
            Game:getFlag("testtext", "* This is some text for testing actors.[wait:10]\n* Is it working?"),
            face,
            event
        )
        return false
    end,
}
