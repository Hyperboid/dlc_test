local spell, super = Class(Spell, "chainslash")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Chain Slash"
    -- Name displayed when cast (optional)
    self.cast_name = "CHAIN-SLASH"

    -- Battle description
    self.effect = "Not Power\nBounce"
    -- Menu description
    self.description = "Deals physical damage to 1 enemy until you miss the action command."

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
	local damage = ((((user.chara:getStat("attack") * 150) / 20) - 3 * (target.defense)) * 1.3)

	---@type XSlashSpell
	local spellobj = XSlashSpell(user,target)
	Game.battle:addChild(spellobj):setLayer(BATTLE_LAYERS["above_battlers"])

	spellobj.damage_callback = function(self, hit_action_command)
		local strikedmg = damage / 3
		if hit_action_command then
			Assets.playSound("dtrans_flip", 2)
            self.slashes_count = self.slashes_count + 1
			strikedmg = strikedmg * 2
		end
		target:hurt(math.floor(strikedmg), user)
	end
end

return spell
