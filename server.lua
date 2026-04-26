local elevatorList = {}

RegisterNetEvent('dv_elevator:server:enterElevator', function (elevator, floor)
    local src = source
    if not elevatorList[elevator] then elevatorList[elevator] = {} end
    if not elevatorList[elevator][tostring(floor)] then elevatorList[elevator][tostring(floor)] = {} end
    table.insert(elevatorList[elevator][tostring(floor)], src)
end)

local function RemoveVal(tbl, val) 
    for i,v in pairs(tbl) do
        if v == val then
            table.remove(tbl,i)
            break
        end
    end
end

RegisterNetEvent('dv_elevator:server:leaveElevator', function (elevator)
    local src = source
    for k, v in pairs(elevatorList[elevator]) do
        RemoveVal(elevatorList[elevator][k], src)
    end
end)

RegisterNetEvent('dv_elevator:server:useElevator', function (data, currentFloor)
    currentFloor = tostring(currentFloor)
    if not data or not data.currentElevator or not elevatorList[data.currentElevator] then
        TriggerClientEvent('dv_elevator:client:notify', source, 'Elevator not found', 'error')
        print('Elevator not found', json.encode(data), json.encode(elevatorList[data.currentElevator]),json.encode(elevatorList))
        return
    end
    if not elevatorList[data.currentElevator][currentFloor] then
        TriggerClientEvent('dv_elevator:client:notify', source, 'Floor not found', 'error')
        print('Floor not found', json.encode(data), currentFloor ,json.encode(elevatorList))
        return
    end
    for _, v in pairs(elevatorList[data.currentElevator][currentFloor]) do
        TriggerClientEvent('dv_elevator:client:useElevator', v, data)
    end
end)