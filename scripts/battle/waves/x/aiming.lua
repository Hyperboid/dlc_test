local Aiming, super = Class(Wave)
function Aiming:shootstream(attacker) self.timer:script(function(wait)
        
    -- Get all enemies that selected this wave as their attack
    local attackers = self:getAttackers()
    
    for i=1,5+(Game.battle.encounter:getFlag("dess_angered_dummy",0)) do
        wait(0.03)
        -- Loop through all attackers
        for _, attacker in ipairs(attackers) do
            
            -- Get the attacker's center position
            local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)
            
            -- Get the angle between the bullet position and the soul's position
            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
            
            -- Spawn smallbullet angled towards the player with speed 8 (see scripts/battle/bullets/smallbullet.lua)
            self:spawnBullet("killdessbullet", x, y, angle, 8)
            Assets.stopAndPlaySound("noise")
        end
    end
end)end
function Aiming:onStart()
    -- Every 0.5 seconds...
    -- self:shootstream()
    self.timer:every(0.7, function ()
        self:shootstream()
    end)
end

function Aiming:update()
    -- Code here gets called every frame

    super.update(self)
end

return Aiming