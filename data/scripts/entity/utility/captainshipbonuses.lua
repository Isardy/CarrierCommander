local oldOnCaptainChanged = CaptainShipBonuses.onCaptainChanged

function CaptainShipBonuses.onCaptainChanged(entityId, captain)
    oldOnCaptainChanged(entityId, captain)

    if not captain then return end
    if not CaptainClass or not CaptainClass.CarrierCommander then return end
    if not captain:hasClass(CaptainClass.CarrierCommander) then return end

    local entity = Entity()

    entity:addMultiplyableBias(StatsBonuses.FighterSquads, 1)
    entity:addMultiplyableBias(StatsBonuses.Pilots, 12)
    entity:addBaseMultiplier(StatsBonuses.FighterCargoPickup, 0.20)
    entity:addBaseMultiplier(StatsBonuses.Velocity, 0.05)
end
