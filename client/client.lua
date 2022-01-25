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
function OpenData()
    local Name = QBCore.Functions.GetPlayerData().charinfo.firstname .. " " ..
                     QBCore.Functions.GetPlayerData().charinfo.lastname
    local Rank = QBCore.Functions.GetPlayerData().job.grade.name
    local OnDuty = QBCore.Functions.GetPlayerData().job.onduty
    SendNUIMessage({
        action = "openMDT",
        data = {visible = true, name = Name, onDuty = OnDuty, rank = Rank}
    })
    SetNuiFocus(true, true)
end

RegisterCommand("jericofxs", function(source, args)
    OpenData()
end, false)


RegisterNUICallback("sendVehicleData", function(data,cb)
    local Datos = data.Info
    TriggerServerEvent("fx-mdt:server:InsertReport",Datos)
    cb({})
end)
RegisterNUICallback("TakePhoto", function(data,cb)
    SetNuiFocus(false, false)
    takePhoto = true
    while takePhoto do

        if IsControlJustPressed(1, 177) then -- CANCEL
            OpenData()
            cb(json.encode({ url = nil }))
            takePhoto = false

            break
        elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
            QBCore.Functions.TriggerCallback("fx-mdt:server:GetWebhook",function(hook)
                if hook then
                    exports['screenshot-basic']:requestScreenshotUpload(tostring(hook), "files[]", function(data)
                        local image = json.decode(data)
                        cb(json.encode(image.attachments[1].proxy_url))
                    end)
                else
                    return
                end
            end)
            takePhoto = false
        end
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
        EnableAllControlActions(0)
        Wait(0)
    end

end)

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
