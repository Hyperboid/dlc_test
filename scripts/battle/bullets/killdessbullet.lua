local KillDessBullet, super = Class(Bullet)

function KillDessBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/smallbullet")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    if Game.battle.encounter:getFlag("dess_angered_dummy",0) > Utils.random(0, 10) then
        self.mhp_damage = 70
    end
end

function KillDessBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return KillDessBullet