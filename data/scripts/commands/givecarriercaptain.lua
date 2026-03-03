package.path = package.path .. ";data/scripts/lib/?.lua"

local CaptainClass = include("captainclass")
local CaptainGenerator = include("captaingenerator")

local function getCarrierCommanderClassId()
    if CaptainClass and CaptainClass.CarrierCommander then
        return CaptainClass.CarrierCommander
    end

    return 10
end

local function clamp(value, minValue, maxValue)
    if value < minValue then return minValue end
    if value > maxValue then return maxValue end
    return value
end

function execute(sender, commandName, ...)
    local args = {...}

    local targetPlayer
    local targetArg = args[1]

    if targetArg and targetArg ~= "" then
        targetPlayer = Galaxy():findPlayer(targetArg)
        if not targetPlayer then
            return 1, "", "Player '" .. tostring(targetArg) .. "' not found."
        end
    else
        targetPlayer = Player(sender)
        if not targetPlayer then
            return 1, "", "No target player. Usage: /givecarriercaptain [player] [tier] [level]"
        end
    end

    local carrierCommanderClassId = getCarrierCommanderClassId()

    local tier = tonumber(args[2]) or 3
    local level = tonumber(args[3]) or 2

    tier = clamp(math.floor(tier), 0, 3)
    level = clamp(math.floor(level), 0, 5)

    local craft = targetPlayer.craft
    if not craft then
        return 1, "", "Target player has no active craft."
    end

    local crew = craft.crew
    if not crew then
        return 1, "", "Target player's active craft has no crew."
    end

    local generator = CaptainGenerator()
    local captain = generator:generate(tier, level, carrierCommanderClassId)
    if not captain then
        return 1, "", "Failed to generate captain."
    end

    crew:setCaptain(captain)
    craft.crew = crew

    targetPlayer:sendChatMessage("Server", ChatMessageType.Normal, "A Carrier Commander captain was assigned to your current craft.")

    return 0, "", "Assigned Carrier Commander (tier " .. tostring(tier) .. ", level " .. tostring(level) .. ") to " .. targetPlayer.name .. "."
end

function getDescription()
    return "Assigns a Carrier Commander captain to a player's active craft."
end

function getHelp()
    return "Usage: /givecarriercaptain [player] [tier] [level] (tier: 0-3, level: 0-5). If player is omitted, targets yourself."
end
