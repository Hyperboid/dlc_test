---@class NoWave : Wave
local NoWave, super = Class(Wave)

function NoWave:onStart()
    Game.battle.wave_timer = 10
end


return NoWave