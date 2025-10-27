Config = {}
Config.debug = false;

Config.Core = "auto" -- auto, qb-core, esx, ox_core

Config.CoreObject = function()
    if Config.Core == "qb-core" then
        return exports['qb-core']:GetCoreObject()
    elseif Config.Core == "esx" then
        return exports['es_extended']:getSharedObject()
    elseif Config.Core == "ox_core" then
        return exports.ox_core:object()
    else -- auto-detect
        if GetResourceState('qb-core') == 'started' then
            Config.Core = "qb-core"
            return exports['qb-core']:GetCoreObject()
        elseif GetResourceState('es_extended') == 'started' then
            Config.Core = "esx"
            return exports['es_extended']:getSharedObject()
        elseif GetResourceState('ox_core') == 'started' then
            Config.Core = "ox_core"
            return exports.ox_core:object()
        else
            error('[dv-elevator] No supported core framework detected (qb-core, esx, ox_core). Please set Config.Core manually.')
        end
    end
end

Config.UseOffDutyJobs = false  -- Set to true if you want to allow off-duty jobs (as example off_police) access to elevators
Config.OffDutyJobSuffix = "off_"  -- Suffix to identify off-duty jobs

Config.target = "qb-target"

Config.ElevatorTime = 3000
Config.elevators = {
    ["vpd"] = {
        label = 'Vespucci PD',
        job = 'police',
        levels = {
            {
                id = 1,
                label = '-2',
                center = vector4(-1093.94, -848.03, 7.71 + 0.5, 39.55),
                size = vec3(2.7, 3.5, 3),
                target = {
                    coords = vector4(-1095.61, -847.63, 8.2, 35.01),
                    radius = .75,
                }
            },
            {
                id = 2,
                label = '-1',
                center = vector4(-1093.94, -848.03, 15.72 + 0.5, 39.55),
                size = vec3(2.7, 3.5, 3),
                target = {
                    coords = vector4(-1095.61, -847.63, 15.72 + 0.5, 35.01),
                    radius = .75,
                }
            },
            {
                id = 3,
                label = 'EG',
                center = vector4(-1094.09, -847.95, 19.33, 37.65),
                size = vec3(2.7, 3.5, 3),
                target = {
                    coords = vector4(-1095.52, -847.66, 19.33, 51.09),
                    radius = .75,
                }
            },
            {
                id = 4,
                label = '1',
                center = vector4(-1093.89, -848.07, 22.79, 41.84),
                size = vec3(2.7, 3.5, 3),
                target = {
                    coords = vector4(-1095.51, -847.65, 22.79, 45.33),
                    radius = .75,
                }
            },
            {
                id = 5,
                label = '2',
                center = vector4(-1093.84, -848.21, 27.06, 38.44),
                size = vec3(2.7, 3.5, 3),
                target = {
                    coords = vector4(-1095.51, -847.67, 27.06, 61.02),
                    radius = .75,
                }
            },
            {
                id = 6,
                label = '3',
                center = vector4(-1093.87, -848.06, 30.77, 35.5),
                size = vec3(2.7, 3.5, 3),
                target = {
                    coords = vector4(-1095.56, -847.65, 30.77, 37.98),
                    radius = .75,
                }
            },
            {
                id = 7,
                label = '4',
                mingrade = 10,
                center = vector4(-1093.85, -848.05, 34.27, 39.81),
                size = vec3(2.7, 3.5, 3),
                target = {
                    coords = vector4(-1095.52, -847.61, 34.27, 50.47),
                    radius = .75,
                }
            },
        }
    }
}

Config.CL = {}
Config.CL.Notify = function(type, message)
    if Config.Core == "ox_core" then
        exports.ox_lib:notify({
            type = type,
            description = message,
            position = "top-right",
            duration = 5000,
        })
        return
    elseif Config.Core == "esx" then
        ESX.ShowNotification(message)
        return
    elseif Config.Core == "qb-core" then
        QBCore.Functions.Notify(message, type)
        return
    end
    -- Here you can Add your custom notification implementation if needed
end

Config.SV = {}

