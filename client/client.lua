local QBCore = exports['qb-core']:GetCoreObject()
local OnDutyPolices = 0
local PoliceReports = {}
CreateThread(function()
    Wait(100)
    TriggerServerEvent("fx-mdt:server:GetPolicesOnDuty")
end)
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
    local PlayerData = QBCore.Functions.GetPlayerData()
    local Name = PlayerData.charinfo.firstname .. " " ..
                     PlayerData.charinfo.lastname
    local Rank = PlayerData.job.grade.name
    local OnDuty = PlayerData.job.onduty
    local isboss = PlayerData.job.isboss
    print(isboss)
    SendNUIMessage({
        action = "openMDT",
        data = {visible = true, name = Name, onDuty = OnDuty, rank = Rank,isboss = isboss}
    })
    SetNuiFocus(true, true)
end

RegisterCommand("jericofxs", function(source, args) OpenData() end, false)

RegisterNUICallback("sendReport", function(data, cb)
    local Datos = data.Info
    TriggerServerEvent("fx-mdt:server:InsertReport", Datos)
    cb({})
end)
RegisterNUICallback("TakePhoto", function(data, cb)
    SetNuiFocus(false, false)
    takePhoto = true
    while takePhoto do
        if IsControlJustPressed(1, 177) then -- CANCEL
            OpenData()
            cb(json.encode({url = nil}))
            takePhoto = false
            break
        elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
            QBCore.Functions.TriggerCallback("fx-mdt:server:GetWebhook",
                                             function(hook)
                if hook then
                    exports['screenshot-basic']:requestScreenshotUpload(
                        tostring(hook), "files[]", function(data)
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
    Wait(100)
    SetNuiFocus(true, true)
end) --MISSING CANCEL ALL ACTIONS ON PICTURE

RegisterNUICallback("exitMDT", function(data, cb)
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
    QBCore.Functions.TriggerCallback("fx-mdt:GetPlayerInfo",
                                     function(d)
                                        cb(d) end, Name)
end)
RegisterNUICallback("getReports", function(data, cb)
    QBCore.Functions.TriggerCallback("fx-mdt:server:GetReports",
                                     function(d) cb(d) end, data.ID)
end)
RegisterNetEvent("fx-mdt:client:onCreatedReport",function(data)
   
    SendNUIMessage({
        action="sendReport",
        data = {
            reports = data
        }
    })

end)
RegisterNUICallback("getEvidence", function(data, cb)
    QBCore.Functions.TriggerCallback("fx-mdt:server:GetEvidence",
                                     function(d) cb(d) end)
end)

RegisterNUICallback("getVehicleData", function(data, cb)
    local Plate = tostring(data.Placa)
    QBCore.Functions.TriggerCallback("fx-mdt:server:GetVehicleData",
                                     function(d) cb(d) end, Plate)
end)
RegisterNUICallback("getPolices", function(data, cb)
    QBCore.Functions.TriggerCallback("fx-mdt:server:GetPolices",
                                     function(d) cb(d) end)
end)

RegisterNUICallback("saveVehicleBolo", function(data, cb)
    local Data = data.Vehiculo

    TriggerServerEvent("fx-mdt:server:SaveVehicleBolo",Data)
    -- QBCore.Functions.TriggerCallback("fx-mdt:server:SaveVehicleBolo",
    --                                  function(d) cb(d) end, Data)
    cb(true)
end)

RegisterNetEvent("fx-mdt:client:SaveVehicleBolo",function(data) 
  SendNUIMessage({
    action="addVehicleBolo",
    data={
        vehicleBolos = data
    }
  })

end)

RegisterNUICallback("getVehicleBolos", function(data, cb)
    QBCore.Functions.TriggerCallback("fx-mdt:server:GetVehicleBolos",
                                     function(d) cb(d) end)
end)

-- RegisterNetEvent("fx-mdt:client:SendBolos",function( data )
--     assert(type(data) == "table","Wrong format expected table get %"):format(type(data))

--     SendNUIMessage({
--         action="addVehicleBolo",
--         data={
--             vehicleBolos=data
--         }
--     })
--     -- body
-- end)