local BigDummy, super = Class(Encounter)

function BigDummy:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = [[* Not your usual "mad dummy" fight.]]

    -- Battle music ("battle" is rude buster)
    self.music = "goombaking"
    -- Enables the purple grid battle background
    self.background = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("bigdummy", 524, 314)

    --- Uncomment this line to add another!
    --self:addEnemy("bigdummy")
end

return BigDummy