createSphereZoneTarget = function(coords, radius, options, distance, name)
    return exports[Config.target]:AddBoxZone(name, coords, radius, radius, 
    { 
        debugPoly = Config.debug, 
        name = name, 
        minZ = coords.z-radius, 
        maxZ = coords.z+radius,
        heading = coords.w,
    }, { 
        options = options, 
        distance = distance 
    })
end

local currentfloor = nil

createBoxZoneElevators = function (id, level, center, size)
    local data = {
        coords = center,
        size = size,
        rotation = center.w,
        onEnter = function(self)
            currentfloor = level
            TriggerServerEvent("dv_elevator:server:enterElevator", id, level)
        end,
        onExit = function(self)
            currentfloor = nil
            TriggerServerEvent("dv_elevator:server:leaveElevator", id)
        end,
        debug = Config.debug,
    }
    lib.zones.box(data)

end

RegisterNuiCallback('hideFrame', function(data, cb)
    SendNUIMessage({ action = 'setVisibleElevator', data = false })
    SetNuiFocus(false, false)
    cb(true)
end)

RegisterNuiCallback('useElevator', function(data, cb)
    SendNUIMessage({ action = 'setVisibleElevator', data = false })
    SetNuiFocus(false, false)
    if Config.Core == "qb-core" then
        Config.CoreObject.Functions.GetPlayerData(function(playerData)
            local reqjob = Config.elevators[data.currentElevator].job
            if reqjob and playerData.job.name ~= reqjob and (Config.UseOffDutyJobs and playerJob ~= Config.OffDutyJobSuffix .. reqjob or true) then
                Config.CL.Notify("Du hast nicht die ausreichenden Berechtigungen für diesen Aufzug.", "error")
                return
            end

            local reqgrade = Config.elevators[data.currentElevator].levels[data.id].mingrade
            if reqgrade and playerData.job.grade.level < reqgrade then
                Config.CL.Notify("Du hast nicht die ausreichenden Berechtigungen für das Stockwerk.", "error")
                return
            end
            TriggerServerEvent("dv_elevator:server:useElevator", data, currentfloor)
        end)
    elseif Config.Core == "esx" then
        local xPlayer = Config.CoreObject.GetPlayerData()
        local playerJob = xPlayer.job.name
        local jobGrade = xPlayer.job.grade

        local reqjob = Config.elevators[data.currentElevator].job
        if reqjob and playerJob ~= reqjob and (Config.UseOffDutyJobs and playerJob ~= Config.OffDutyJobSuffix .. reqjob or true) then
            Config.CL.Notify("Du hast nicht die ausreichenden Berechtigungen für diesen Aufzug.", "error")
            return
        end

        local reqgrade = Config.elevators[data.currentElevator].levels[data.id].mingrade
        if reqgrade and jobGrade < reqgrade then
            Config.CL.Notify("Du hast nicht die ausreichenden Berechtigungen für das Stockwerk.", "error")
            return
        end
        TriggerServerEvent("dv_elevator:server:useElevator", data, currentfloor)
    elseif Config.Core == "ox_core" then
        local xPlayer = Config.CoreObject.GetPlayer()
        local playerJob = xPlayer.job.name
        local jobGrade = xPlayer.job.grade

        local reqjob = Config.elevators[data.currentElevator].job
        if reqjob and playerJob ~= reqjob and (Config.UseOffDutyJobs and playerJob ~= Config.OffDutyJobSuffix .. reqjob or true) then
            Config.CL.Notify("Du hast nicht die ausreichenden Berechtigungen für diesen Aufzug.", "error")
            return
        end

        local reqgrade = Config.elevators[data.currentElevator].levels[data.id].mingrade
        if reqgrade and jobGrade < reqgrade then
            Config.CL.Notify("Du hast nicht die ausreichenden Berechtigungen für das Stockwerk.", "error")
            return
        end
        TriggerServerEvent("dv_elevator:server:useElevator", data, currentfloor)
    end
    
    cb(true)
end)

RegisterNetEvent('dv_elevator:client:useElevator', function (data)
    local coords = Config.elevators[data.currentElevator].levels[currentfloor].center
    local newCoords = Config.elevators[data.currentElevator].levels[data.id].center
    local playerCoords = GetEntityCoords(PlayerPedId())
    DoScreenFadeOut(500)
    local diff = currentfloor - data.id
    if diff < 0 then
        diff = diff * -1
    end
    if not Config.debug then 
        Wait(Config.ElevatorTime * diff)
    end
    --TriggerServerEvent("InteractSound_SV:PlayOnSource", "dv_elevator", 0.5)
    local offsetX, offsetY = playerCoords.x - coords.x, playerCoords.y - coords.y
    SetEntityCoords(PlayerPedId(), newCoords.x + offsetX, newCoords.y + offsetY, newCoords.z, true, false, false, false)
    --SetEntityHeading(PlayerPedId(), coords.w) -- Not Turning
    Wait(1000)
    DoScreenFadeIn(500)
end)    

RegisterNetEvent('dv_elevator:client:notify', function (message, type)
    Config.CL.Notify(message, type)
end)

CreateThread(function()
    for k, v in pairs(Config.elevators) do
        for _, v2 in pairs(v.levels) do
            createSphereZoneTarget(v2.target.coords, v2.target.radius, {
                {
                    label = "Use elevator",
                    icon = 'fas fa-angle-up',
                    action = function()
                        if currentfloor == nil then
                            return
                        end
                        SendNUIMessage({
                            action = 'updateElevator',
                            data = {
                                currentElevator = k,
                                elevatorLabel = v.label,
                                elevatorLevels = v.levels,
                                currentLevel = v2.id
                            }
                        })
                        SendNUIMessage({ action = 'setVisibleElevator', data = true })
                        SetNuiFocus(true, true)
                    end
                }
            }, 2.5, 'elevator_'..k..v2.id)
            createBoxZoneElevators(k, v2.id, v2.center, v2.size)
        end
    end
end)
