local QBCore = exports['qb-core']:GetCoreObject()
local OnDutyPolices = 0
local PoliceInfo = {}
CreateThread(function() Wait(100)  TriggerServerEvent("fx-mdt:server:GetPolicesOnDuty") end)
RegisterNetEvent("fx-mdt:client:GetPolicesOnDuty",
                 function(count, PolicesOnDuty)

    OnDutyPolices = count
    PoliceInfo = PolicesOnDuty
    SendNUIMessage({
        action = "onDutyPolices",
        data = {policesOnDuty = OnDutyPolices, policesData = PoliceInfo}
    })

end)

RegisterCommand("jericofxs", function(source, args)
    local Name = QBCore.Functions.GetPlayerData().charinfo.firstname .. " " ..
                     QBCore.Functions.GetPlayerData().charinfo.lastname
    local Rank = QBCore.Functions.GetPlayerData().job.grade.name
    local OnDuty = QBCore.Functions.GetPlayerData().job.onduty
    SendNUIMessage({
        action = "openMDT",
        data = {visible = true, name = Name, onDuty = OnDuty, rank = Rank}
    })
    SetNuiFocus(true, true)
end, false)

RegisterNUICallback("exitMDT", function(cb)
    SetNuiFocus(false, false)
    cb({})
end)
RegisterNUICallback("changeDuty", function(data, cb)
    local Duty = data.Duty
    TriggerServerEvent("police:server:UpdateCurrentCops")
    TriggerServerEvent("QBCore:ToggleDuty")
    TriggerServerEvent("police:server:UpdateBlips")
    TriggerServerEvent("fx-mdt:server:GetPolicesOnDuty")
    cb({})
end)

RegisterNUICallback("getCurrentLocation", function(data, cb)
    local Coords = GetEntityCoords(PlayerPedId())
    local x, y, z = table.unpack(Coords)
    local StreetHash = GetStreetNameAtCoord(x, y, z)
    local StreetName = GetStreetNameFromHashKey(StreetHash)
    cb(StreetName)
end)

RegisterNUICallback("getClosesPlayerInfo", function(data, cb)
    local Coords = GetEntityCoords(PlayerPedId())
    local Player, distance = QBCore.Functions.GetClosestPlayer(Coords)
    local Server = GetPlayerServerId(Player)
    if distance == -1 then cb(false) end
    if distance <= 3 then
        QBCore.Functions.TriggerCallback("fx-mdt:GetPlayerClosestInfo",
                                         function(d) cb(d) end, Server)
    end
end)
RegisterNUICallback("getPlayerSearch", function(data, cb)
    local Name = tostring(data.SearchName)
    print(Name)
        QBCore.Functions.TriggerCallback("fx-mdt:GetPlayerInfo",function(d) 
            print(json.encode(d))
            cb(d) 
        end, Name)

end)
