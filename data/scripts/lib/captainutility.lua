local oldClassProperties = CaptainUtility.ClassProperties
local oldGetCaptainClassSummary = CaptainUtility.getCaptainClassSummary
local oldGetTravelCommandCaptainClassDescription = CaptainUtility.getTravelCommandCaptainClassDescription
local oldGetScoutCommandCaptainClassDescription = CaptainUtility.getScoutCommandCaptainClassDescription
local oldGetMineCommandCaptainClassDescription = CaptainUtility.getMineCommandCaptainClassDescription
local oldGetSalvageCommandCaptainClassDescription = CaptainUtility.getSalvageCommandCaptainClassDescription
local oldGetRefineCommandCaptainClassDescription = CaptainUtility.getRefineCommandCaptainClassDescription
local oldGetTradeCommandCaptainClassDescription = CaptainUtility.getTradeCommandCaptainClassDescription
local oldGetProcureCommandCaptainClassDescription = CaptainUtility.getProcureCommandCaptainClassDescription
local oldGetSellCommandCaptainClassDescription = CaptainUtility.getSellCommandCaptainClassDescription
local oldGetSupplyCommandCaptainClassDescription = CaptainUtility.getSupplyCommandCaptainClassDescription
local oldGetExpeditionCommandCaptainClassDescription = CaptainUtility.getExpeditionCommandCaptainClassDescription
local oldGetMaintenanceCommandCaptainClassDescription = CaptainUtility.getMaintenanceCommandCaptainClassDescription
local oldMakeTooltip = CaptainUtility.makeTooltip

local function isCarrierCommander(class)
    return CaptainUtility.ClassType and class == CaptainUtility.ClassType.CarrierCommander
end

local function carrierSummary()
    return "+1 Fighter Squad, +12 Pilots, +20% Fighter Cargo Pickup, +5% Velocity"%_t
end

local function hasCarrierCommander(captain)
    if not captain then return false end

    if captain.hasClass and CaptainUtility.ClassType and CaptainUtility.ClassType.CarrierCommander then
        local ok, hasClass = pcall(function() return captain:hasClass(CaptainUtility.ClassType.CarrierCommander) end)
        if ok and hasClass then
            return true
        end
    end

    return isCarrierCommander(captain.primaryClass) or isCarrierCommander(captain.secondaryClass)
end

function CaptainUtility.ClassProperties()
    local properties = oldClassProperties()

    local classType = CaptainUtility.ClassType and CaptainUtility.ClassType.CarrierCommander
    if classType and not properties[classType] then
        properties[classType] =
        {
            displayName = "Carrier Commander /* Captain Class of a male captain */"%_t,
            displayNameFemale = "Carrier Commander /* Captain Class of a female captain */"%_t,
            untranslatedName = "Carrier Commander /* Captain Class of a male captain */"%_T,
            untranslatedNameFemale = "Carrier Commander /* Captain Class of a female captain */"%_T,
            description = "This captain is a specialist in carrier operations. He is accompanied by a skilled squadron of ace pilots who also help in the training of other pilots. /* sentence referring to a male captain */"%_t,
            descriptionFemale = "This captain is a specialist in carrier operations. She is accompanied by a skilled squadron of ace pilots who also help in the training of other pilots. /* sentence referring to a female captain */"%_t,

            icon = "data/textures/ui/captain/symbol-commodore.png",
            tooltipIcon = "data/textures/ui/captain/symbol-commodore-black-bg.png",
            center = "data/textures/ui/captain/center-turquoise-shaded.png",
            ring = "data/textures/ui/captain/ring-turquoise-shaded.png",

            centerColor = ColorRGB(1.0, 1.0, 1.0),
            ringColor = ColorRGB(1.0, 1.0, 1.0),
            primaryColor = ColorRGB(0.0, 0.75, 0.75),
            secondaryColor = ColorRGB(0.6, 0.75, 0.75),
        }
    end

    return properties
end

function CaptainUtility.getCaptainClassSummary(class, commandType)
    if isCarrierCommander(class) then
        return carrierSummary()
    end

    return oldGetCaptainClassSummary(class, commandType)
end

function CaptainUtility.getTravelCommandCaptainClassDescription(class)
    if isCarrierCommander(class) then return carrierSummary() end
    return oldGetTravelCommandCaptainClassDescription(class)
end

function CaptainUtility.getScoutCommandCaptainClassDescription(class)
    if isCarrierCommander(class) then return carrierSummary() end
    return oldGetScoutCommandCaptainClassDescription(class)
end

function CaptainUtility.getMineCommandCaptainClassDescription(class)
    if isCarrierCommander(class) then return carrierSummary() end
    return oldGetMineCommandCaptainClassDescription(class)
end

function CaptainUtility.getSalvageCommandCaptainClassDescription(class)
    if isCarrierCommander(class) then return carrierSummary() end
    return oldGetSalvageCommandCaptainClassDescription(class)
end

function CaptainUtility.getRefineCommandCaptainClassDescription(class)
    if isCarrierCommander(class) then return carrierSummary() end
    return oldGetRefineCommandCaptainClassDescription(class)
end

function CaptainUtility.getTradeCommandCaptainClassDescription(class)
    if isCarrierCommander(class) then return carrierSummary() end
    return oldGetTradeCommandCaptainClassDescription(class)
end

function CaptainUtility.getProcureCommandCaptainClassDescription(class)
    if isCarrierCommander(class) then return carrierSummary() end
    return oldGetProcureCommandCaptainClassDescription(class)
end

function CaptainUtility.getSellCommandCaptainClassDescription(class)
    if isCarrierCommander(class) then return carrierSummary() end
    return oldGetSellCommandCaptainClassDescription(class)
end

function CaptainUtility.getSupplyCommandCaptainClassDescription(class)
    if isCarrierCommander(class) then return carrierSummary() end
    return oldGetSupplyCommandCaptainClassDescription(class)
end

function CaptainUtility.getExpeditionCommandCaptainClassDescription(class)
    if isCarrierCommander(class) then return carrierSummary() end
    return oldGetExpeditionCommandCaptainClassDescription(class)
end

function CaptainUtility.getMaintenanceCommandCaptainClassDescription(class)
    if isCarrierCommander(class) then return carrierSummary() end
    return oldGetMaintenanceCommandCaptainClassDescription(class)
end

function CaptainUtility.makeTooltip(captain, commandType)
    local tooltip = oldMakeTooltip(captain, commandType)

    if not tooltip or commandType or not hasCarrierCommander(captain) then
        return tooltip
    end

    local lines = {tooltip:getLines()}
    local insertionLine = nil

    for i, line in ipairs(lines) do
        if line and line.ltext == "Level"%_t then
            insertionLine = i
            break
        end
    end

    if not insertionLine then
        return tooltip
    end

    local blankBeforeLevel = lines[insertionLine - 1]
    if blankBeforeLevel and not blankBeforeLevel.ltext and not blankBeforeLevel.rtext and not blankBeforeLevel.ctext then
        insertionLine = insertionLine - 1
    end

    local addLine1 = TooltipLine(16, 13)
    addLine1.ltext = "Fighter Squads"%_t
    addLine1.rtext = "+1"
    addLine1.icon = "data/textures/icons/captain.png"
    addLine1.iconColor = ColorRGB(0.5, 0.5, 0.5)

    local addLine2 = TooltipLine(16, 13)
    addLine2.ltext = "Pilots"%_t
    addLine2.rtext = "+12"
    addLine2.icon = "data/textures/icons/captain.png"
    addLine2.iconColor = ColorRGB(0.5, 0.5, 0.5)

    local addLine3 = TooltipLine(16, 13)
    addLine3.ltext = "Fighter Cargo Pickup"%_t
    addLine3.rtext = "+20%"
    addLine3.icon = "data/textures/icons/captain.png"
    addLine3.iconColor = ColorRGB(0.5, 0.5, 0.5)

    local addLine4 = TooltipLine(16, 13)
    addLine4.ltext = "Velocity"%_t
    addLine4.rtext = "+5%"
    addLine4.icon = "data/textures/icons/captain.png"
    addLine4.iconColor = ColorRGB(0.5, 0.5, 0.5)

    local shifted = pcall(function()
        for i = #lines, insertionLine, -1 do
            tooltip:setLine(i + 3, lines[i])
        end
        tooltip:setLine(insertionLine - 1, addLine1)
        tooltip:setLine(insertionLine, addLine2)
        tooltip:setLine(insertionLine + 1, addLine3)
        tooltip:setLine(insertionLine + 2, addLine4)
    end)

    if not shifted then
        tooltip:addLine(TooltipLine(8, 8))
        tooltip:addLine(addLine1)
        tooltip:addLine(addLine2)
        tooltip:addLine(addLine3)
        tooltip:addLine(addLine4)
    end

    return tooltip
end
