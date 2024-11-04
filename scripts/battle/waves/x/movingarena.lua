local MovingArena, super = Class(Wave)

function MovingArena:init()
    super.init(self)

    -- Initialize timer
    self.siner = 0
    self.speed = 0
end

function MovingArena:onStart()
    -- Get the arena object
    local arena = Game.battle.arena

    -- Spawn spikes on top of arena
    self:spawnBulletTo(Game.battle.arena, "arenahazard", arena.width/2, 0, math.rad(0))

    -- Spawn spikes on bottom of arena (rotated 180 degrees)
    self:spawnBulletTo(Game.battle.arena, "arenahazard", arena.width/2, arena.height, math.rad(180))
    self:spawnBulletTo(Game.battle.arena, "arenahazard", 0, arena.height/2, math.rad(-90))
    self:spawnBulletTo(Game.battle.arena, "arenahazard", arena.width, arena.height/2, math.rad(90))

    -- Store starting arena position
    self.arena_start_x = arena.x
    self.arena_start_y = arena.y
end

local function sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end
local a = 2
function MovingArena:update()
    -- Increment timer for arena movement
    self.siner = self.siner + (DT * self.speed)
    self.speed = math.min(1 + (Game.battle.encounter:getFlag("dess_angered_dummy",0) / 20), self.speed + (DT * 1))

    -- Calculate the arena Y offset
    local x_offset = a*math.sin(self.siner * 1.2) * 60
    local y_offset = a*((math.sin(self.siner*1.2) * math.cos(self.siner * 1.2)) * 60)

    -- Move the arena
    Game.battle.arena:setPosition(self.arena_start_x + x_offset, self.arena_start_y + y_offset)

    super.update(self)
end

return MovingArena