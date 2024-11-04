local Basic, super = Class(Wave)

function Basic:onStart()
    -- Every 0.1 seconds...
    self.timer:every(1/(10+Game.battle.encounter:getFlag("dess_angered_dummy",0)), function()
        -- Our X position is offscreen, to the right
        local x = SCREEN_WIDTH + 20
        -- Get a random Y position between the top and the bottom of the arena
        local y = Utils.random(Game.battle.arena.top, Game.battle.arena.bottom)

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("killdessbullet", x, y, math.rad(180), 8)

        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
        self.timer:after(1, function () bullet.remove_offscreen = true end)
    end)
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic