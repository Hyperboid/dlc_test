---@class Dummy: EnemyBattler
local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = "Big Dummy"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("bigdummy")

    -- Enemy health
    self.max_health = 2500
    self.health = self.max_health
    -- Enemy attack (determines bullet damage)
    self.attack = 4
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 100

    self.tired_percentage = 10/100

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "x/basic",
        "x/aiming",
        "x/movingarena"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "..."
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = { "Oh no!", unpack(Utils.shuffle {
        "Uh...",
        "This is bad!",
        "This should never appear!",
        "The check text is broken!",
        "Something went very wrong!",
        "Did I do something?",
        "Maybe a Kristal bug?",
    }) }

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* The dummy gives you a harsh\nglare.",
        "* The power of prickly princes is\nin the air.",
        "* Smells like a slightly-less-subtle Deltaraid reference.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The dummy looks like it's\nabout to fall over."

    -- Register act called "Smile"
    self:registerAct("Smile")
    if #Game.party == 1 and Game.party[1].id == "kris" then
        self:registerAct("X-Slash", "Physical\nDamage", {}, 25)
    end
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    self:registerAct("Tell Story", "", {"ralsei"})
end

function Dummy:onCheck(battler)
    self.checkovsgun --[[]] = {
        string.format("AT %s DF %s\n* A rotten heart and button eye.\n* The pain itself is reason why.", self.attack, self.defense),
        "No, it's not  .  .   s   , I just thought it was a cool rhyme."
    }
end

function Dummy:onAct(battler, name)
    if name == "Smile" then
        -- Give the enemy 100% mercy
        -- Change this enemy's dialogue for 1 turn
        self.dialogue_override = "... >:("
        Assets.playSound("boost")
        -- Act text (since it's a list, multiple textboxes)
        if self.attack <= 100 then
            self.attack = self.attack + 4
            self.defense = self.defense - 8
            return {
                "* You smile.[wait:5]\n* The dummy envies you.",
                "* Attack UP 4! Defense DOWN 8!"
            }
        else
            Game.battle:startCutscene(function (cutscene)
                cutscene:wait(1)
                self:explode()
                cutscene:text("* The dummy explodes from anger.")
                cutscene:after(function ()
                    Game:setTension(0)
                    Game.battle:setState("VICTORY")
                end)
            end)
        end
    elseif name == "Red Buster" then
        Game.battle:powerAct("red_buster", battler, "susie", self)
    elseif name == "X-Slash" then
        local user = "kris"
        local user_index = Game.battle:getPartyIndex(user)
        local user_battler = Game.battle:getPartyBattler(user)
        local spell = Registry.createSpell("xslash")
        local target = self
        local menu_item = {
            data = spell,
            tp = 0,
        }
        Game.battle:pushAction("SPELL", target, menu_item, user_index)
        Game.battle:markAsFinished(nil, {user})

    elseif name == "Tell Story" then
        return "* You and Ralsei told the dummy\na bedtime story.\n* The dummy is unresponsive."

    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei bowed politely.\n* The dummy is unresponsive."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            Game.battle:startActCutscene("bigdummy", "susie_punch")
            return
        elseif battler.chara.id == "dess" then
            local newmus = "berdly_battle_heartbeat_true"
            Game.battle.encounter:addFlag("dess_angered_dummy", 1)
            Game.battle.music.pitch = 1 + (.1 * (Game.battle.encounter:getFlag("dess_angered_dummy")))
            self.defense = self.defense - 2
            self.sprite:setAnimation({"angy/idle", 0.5 / Game.battle.music.pitch, true })
            self.text = {
                "* Smells like unbridled rage.",
                "* The dummy is madder than ever!",
                "* The dummy prepares an unavoidable* attack."
            }
            return {
                "* Dess does absolutely nothing. The dummy is not having it.",
                "* DEF DOWN 2! Attacks get extreme!"
            }
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." tried to straighten the\ndummy's hat, but couldn't get close enough."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function Dummy:onDefeat(damage, battler)
    Game.battle.encounter:setFlag("dess_angered_dummy", nil)
    return super.onDefeat(self,damage,battler)
end

return Dummy