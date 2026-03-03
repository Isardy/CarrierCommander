local oldGetPossibleMissions = MissionBulletins.getPossibleMissions

function MissionBulletins.getPossibleMissions()
    local scripts = oldGetPossibleMissions()

    local station = Entity()
    if station and station.title == "Fighter Factory" then
        table.insert(scripts, {path = "data/scripts/player/missions/receivecarriercommander.lua", prob = 2})
    end

    return scripts
end
