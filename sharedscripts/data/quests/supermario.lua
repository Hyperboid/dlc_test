---@class Quest.supermario : Quest
local quest, super = Class(Quest, "supermario")

function quest:init()
    super.init(self)
    self.name = "supermario"
    self.description = "shoutouts to super fucking mario"
end

function quest:getProgress()
    if Game:hasUnlockedPartyMember("mario") then
        return 1
    else
        return 0
    end
end

return quest