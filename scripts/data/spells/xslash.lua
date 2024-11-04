local spell, super = Class(Spell, "xslash")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "X-Slash"
    -- Name displayed when cast (optional)
    self.cast_name = "X-SLASH"

    -- Battle description
    self.effect = "Physical\nDamage"
    -- Menu description
    self.description = "Deals large physical damage to 1 enemy."

    -- TP cost
    self.cost = 40

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"Damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
	local damage = math.floor((((user.chara:getStat("attack") * 150) / 20) - 3 * (target.defense)) * 1.3)

	---@type XSlashSpell
	local spellobj = XSlashSpell(user,target)
	Game.battle:addChild(spellobj):setLayer(BATTLE_LAYERS["above_battlers"])

	local function dealDamage()
		local strikedmg = damage
		if Input.pressed("confirm") then
			Assets.playSound("backattack")
			strikedmg = strikedmg * 2
		end
		target:hurt(strikedmg, user)
	end
	Game.battle.timer:after(0.1/2, function()
		dealDamage()
		spellobj:generateSlash(1)
		Game.battle.timer:after(1/2, function()
			spellobj:generateSlash(-1)
			dealDamage()
		end)
	end)
end

return spell
