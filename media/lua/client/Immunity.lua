require "Communications/QSystem"
require "Scripting/CharacterManager"

if AchievementManager then
    AchievementManager.add("sally_0", "gd_msq1_extra", nil, "Honey, I'm back", "Return to convienience store before completing your first quest", false)
    AchievementManager.add("sally_1", "gd_msq1_cleared", nil, "The story begins", "Complete your first quest", false)
    AchievementManager.add("sally_2", "gd_msq2_intro", nil, "Worthy challenge", "Go on trip with Sally", false)
    AchievementManager.add("sally_3", "gd_msq3_ending_a", nil, "It's sour...", "Complete \'Ambrosia of Undying Hope\' with ending A", false)
    AchievementManager.add("sally_4", "gd_msq3_ending_b", nil, "Psychonaut", "Complete \'Ambrosia of Undying Hope\' with ending B", false)
    AchievementManager.add("sally_5", "gd_msq3_ending_c", nil, "Sally", "Complete \'Ambrosia of Undying Hope\' with ending C", false)
    AchievementManager.add("sally_6", "gd_msq3_ending_d", nil, "Barmaid's talent", "Complete \'Ambrosia of Undying Hope\' with ending D", false)
    AchievementManager.add("sally_7", "gd_msq3_ending_e", nil, "Slacker", "Complete \'Ambrosia of Undying Hope\' with ending E", true)
    AchievementManager.add("sally_8", "gd_msq3_ending_f", nil, "Spiker", "Complete \'Ambrosia of Undying Hope\' with ending F", true)
    AchievementManager.add("sally_9", "gd_msq3_ending_g", nil, "Taste your own medicine", "Complete \'Ambrosia of Undying Hope\' with ending G", true)
    AchievementManager.add("sally_10", "gd_eq1_ending_a", nil, "I'm telling you I saw something", "Complete \'Night activities\' with ending A", true)
    AchievementManager.add("sally_11", "gd_eq1_ending_b", nil, "Pure skill, no cheating", "Complete \'Night activities\' with ending B", true)
    AchievementManager.add("sally_12", "teaser_finished", nil, "The End??", "Finish Playable Teaser 1", true)
end

Immunity = {};
local active = false;

function Immunity.onGameStart()
    TraitFactory.addTrait("immunity", "???", 0, "???", false);
end

function Immunity.onQSystemUpdate(code)
    if code == 0 or code == 4 then
        local player = getPlayer();
        if player then
            if CharacterManager.instance then
                if CharacterManager.instance:isFlag("immunity_route") then
                    if not active then
                        player:getTraits():add("immunity");
                        active = true;
                    end
                else
                    if active then
                        player:getTraits():remove("immunity");
                        active = false;
                    end
                end
            end
        end
    end
end

function Immunity.restore()
    local player = getPlayer();
    if player then
        if active then
            local bodyDamage = player:getBodyDamage();
            if bodyDamage:isInfected() then
                local bodyParts = bodyDamage:getBodyParts();
                for i=0, bodyParts:size()-1 do
                    bodyParts:get(i):SetInfected(false);
                end
                bodyDamage:setInfected(false);
                bodyDamage:setInfectionLevel(0.0);
                bodyDamage:setInfectionTime(-1.0);
                --print("Infection cured");
            end
        end
    end
end

function Immunity.onCreatePlayer()
	active = false;
    Immunity.onQSystemUpdate(4);
end

Events.OnGameStart.Add(Immunity.onGameStart);
Events.OnCreatePlayer.Add(Immunity.onCreatePlayer);
Events.OnQSystemUpdate.Add(Immunity.onQSystemUpdate);
Events.EveryOneMinute.Add(Immunity.restore);
