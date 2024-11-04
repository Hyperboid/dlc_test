---@class XSlashSpell: Object
---@overload fun(...): XSlashSpell
local XSlashSpell, super = Class(Object)

function XSlashSpell:init(user,target)
    super.init(self)
    self.user = user
    self.target = target
end

function XSlashSpell:generateSlash(scale_x)
    local cutAnim = Sprite("effects/attack/cut")
    Assets.playSound("scytheburst")
    Assets.playSound("criticalswing", 1.2, 1.3)
    self.user.overlay_sprite:setAnimation("battle/attack") -- Makes the afterimages use the first frame of the attack animation
    self.user:toggleOverlay(true)
    local afterimage1 = AfterImage(self.user, 0.5)
    local afterimage2 = AfterImage(self.user, 0.6)
    self.user:toggleOverlay(false)
    afterimage1.physics.speed_x = 2.5
    afterimage2.physics.speed_x = 5
    afterimage2:setLayer(afterimage1.layer - 1)
    self.user:setAnimation("battle/attack", function()
        self.user:setAnimation("battle/idle")
    end)
    self.user:flash()
    cutAnim:setOrigin(0.5, 0.5)
    cutAnim:setScale(2.5 * scale_x, 2.5)
    cutAnim:setPosition(self.target:getRelativePos(self.target.width/2, self.target.height/2))
    cutAnim.layer = self.target.layer + 0.01
    cutAnim:play(1/15, false, function(s) s:remove() end)
    self:addChild(cutAnim)
    self:addChild(afterimage1)
    self:addChild(afterimage2)
end

return XSlashSpell