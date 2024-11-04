---@class MyQuest : Quest
local MyQuest, super = Class(Quest, "mycoolquest")

function MyQuest:init()
    super.init(self)
    self.name = "My Cool Quest!!"
	self.progress = 0
    self.progress_max = 10000000000
end

return MyQuest

