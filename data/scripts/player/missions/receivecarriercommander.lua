package.path = package.path .. ";data/scripts/lib/?.lua"
package.path = package.path .. ";data/scripts/?.lua"

include("randomext")
include("utility")

local MissionUT = include("missionutility")
local CaptainGenerator = include("captaingenerator")
local CaptainUtility = include("captainutility")

local function calculateReward(salary)
    local reward = (salary or 50000)

    if reward > 10000 then
        reward = round(reward / 10000) * 10000
    elseif reward > 1000 then
        reward = round(reward / 1000) * 1000
    elseif reward > 100 then
        reward = round(reward / 100) * 100
    end

    return reward
end

function getBulletin(station)
    if not station or station.title ~= "Fighter Factory" then
        return nil
    end

    local classType = CaptainUtility.ClassType and CaptainUtility.ClassType.CarrierCommander
    if not classType then
        return nil
    end

    local x, y = Sector():getCoordinates()
    local giverInsideBarrier = MissionUT.checkSectorInsideBarrier(x, y)
    local targetX, targetY = MissionUT.getSector(x, y, 15, 17, false, false, false, false)

    if not targetX or not targetY then
        return nil
    end

    if giverInsideBarrier ~= MissionUT.checkSectorInsideBarrier(targetX, targetY) then
        return nil
    end

    local language = Language(random():createSeed())
    local client = language:getName()

    local seed = Seed(client)
    local captain = CaptainGenerator(seed):generate(3, nil, classType, nil)
    if not captain then
        return nil
    end

    if captain.name == client then
        return nil
    end

    local credits = calculateReward(captain.salary)

    local classProperties = CaptainUtility.ClassProperties()[captain.primaryClass]
    if not classProperties then
        return nil
    end

    local genderedClass = classProperties.untranslatedName
    if captain.genderId == CaptainGenderId.Female then
        genderedClass = classProperties.untranslatedNameFemale
    end

    local age = math.random(35, 120)

    local missionDescription
    if captain.genderId == CaptainGenderId.Male then
        missionDescription = "Missing:\nName: ${displayName}\nProfession: ${class}\nAge: ${age}\nLast Known Location: (${x}:${y})\n\nIt's been a while since I've last had word from my good friend ${displayName}. Usually he checks in with me regularly. I'm worried that something bad might have happened to him. The only clue I have to go on is his last message that he was on his way to sector (${x}:${y}). Please help me find my friend!\n\nAnyone who can lead me towards him will receive a reward of ${reward}¢!\n\n${client}"%_t
    else
        missionDescription = "Missing:\nName: ${displayName}\nProfession: ${class}\nAge: ${age}\nLast Known Location: (${x}:${y})\n\nIt's been a while since I've last had word from my good friend ${displayName}. Usually she checks in with me regularly. I'm worried that something bad might have happened to her. The only clue I have to go on is her last message that she was on her way to sector (${x}:${y}). Please help me find my friend!\n\nAnyone who can lead me towards her will receive a reward of ${reward}¢!\n\n${client}"%_t
    end

    local bulletin =
    {
        brief = "A Lost Friend"%_t,
        title = "A Lost Friend"%_t,
        icon = "data/textures/icons/captain.png",
        description = missionDescription,
        difficulty = "Difficult /*difficulty*/"%_T,
        reward = "¢${reward}"%_T,
        script = "missions/receivecaptainmission.lua",
        formatArguments = {
            displayName = captain.displayName,
            class = genderedClass,
            age = age,
            client = client,
            x = targetX,
            y = targetY,
            reward = createMonetaryString(credits)
        },
        msg = "Check the last known location of the missing person in \\s(%2%:%3%)."%_T,
        onAccept = [[
            local self, player = ...
            player:sendChatMessage(Entity(self.arguments[1].giver), 0, self.msg, self.formatArguments.displayName, self.formatArguments.x, self.formatArguments.y)
        ]],

        arguments = {{
            giver = station.id,
            location = {x = targetX, y = targetY},
            reward = credits,
            client = client,
            captain = {
                name = captain.displayName,
                genderId = captain.genderId,
                className = genderedClass,
                tier = 3,
                level = captain.level,
                primaryClass = classType,
                secondaryClass = captain.secondaryClass
            }
        }},
    }

    return bulletin
end
