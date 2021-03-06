local QBCore = exports['qb-core']:GetCoreObject()
local WebHook = ""
local MDT = {}
function MDT.Init()
    local self = {}
    setmetatable(self, MDT)
    return self
end

local Reports = {}
local Bolos = {}
QBCore.Functions.CreateCallback("fx-mdt:GetPlayerClosestInfo",
                                function(source, cb, id)
    local Player = QBCore.Functions.GetPlayer(id)
    local Name = Player.PlayerData.charinfo.firstname
    local LastName = Player.PlayerData.charinfo.lastname
    local Cid = Player.PlayerData.citizenid
    local Job = Player.PlayerData.job.name
    local Rank = Player.PlayerData.job.grade.name
    local result1 = GetVehicleModsInfo(Player.PlayerData.citizenid)
    cb({
        name = Name,
        lastname = LastName,
        citizenid = Cid,
        Job = Job,
        Rank = Rank,
        Vehicles = result1
    })
end)

RegisterNetEvent("fx-mdt:server:GetPolicesOnDuty", function(source)
    local PolicesOnDuty, count = QBCore.Functions.GetPlayersOnDuty("police")
    local Players = {}
    local players = GetPolicesOnD()
    for src, Player in pairs(QBCore.Functions.GetQBPlayers()) do
        if Player.PlayerData.job.name == "police" then
            if Player then
                Players[#Players + 1] = {
                    Name = Player.PlayerData.charinfo.firstname,
                    LastName = Player.PlayerData.charinfo.lastname,
                    Citizenid = Player.PlayerData.citizenid,
                    Rank = Player.PlayerData.job.grade.name,
                    OnDuty = Player.PlayerData.job.onduty,
                    isOnline = true
                }
            else
                for k, v in pairs(players) do
                    local element = players[k]
                    Players[#Players + 1] = {
                        Name = element.Name,
                        LastName = element.LastName,
                        Citizenid = element.citizenid,
                        Rank = element.JobName,
                        OnDuty = element.OnDuty,
                        isOnline = false
                    }
                end

            end
        end
    end

    TriggerClientEvent("fx-mdt:client:GetPolicesOnDuty", -1, count, Players)
end)

function GetPolicesOnD()
    local p = promise.new()
    local players = MySQL.query.await(
                        "SELECT citizenid,JSON_EXTRACT(players.charinfo,'$.firstname') AS Name,JSON_EXTRACT(players.charinfo,'$.lastname') AS LastName, JSON_EXTRACT(players.job,'$.grade.name') AS Rank,JSON_EXTRACT(players.job,'$.name') AS JobName, JSON_EXTRACT(players.job,'$.onduty') AS OnDuty FROM `players` WHERE `job` LIKE '%police%'")
    p:resolve(players)
    return Citizen.Await(p)
end

function GetAllReports(id)
    local Data = {}
    local reports
    if id then
        reports = MySQL.query.await("SELECT * FROM fx_reports WHERE citizenid = ?",
                      {id})
        if reports then 
            return reports
        end

    else
        reports = MySQL.query.await("SELECT * FROM fx_reports")
        if reports then
            for k, v in ipairs(reports) do
                local element = reports[k]
                Data[#Data + 1] = {
                    name = element.name,
                    owner = element.citizenid,
                    lastname = element.lastname,
                    id = element.id,
                    location = element.location,
                    vehicleplate = element.vehicleplate,
                    information = element.information,
                    evidencia = json.decode(element.evidencia),
                    imagenes = json.decode(element.imagenes),
                    fine = json.decode(element.fine),
                    policesinvolved = json.decode(element.policesinvolved),
                    jailtime = element.jailtime,
                    amount = element.amount
                }
               
            end
        
        end

    end
    return Data
end

function IsPolice(src)
    local p = promise.new()
    local Player = QBCore.Functions.GetPlayer(src)
     p:resolve(Player.PlayerData.job.name)
    return Citizen.Await(p)
end
QBCore.Functions.CreateCallback("fx-mdt:server:GetReports",
                                function(source, cb, id)
    if not id then
        cb(GetAllReports())
    else
        cb(GetAllReports(id))
    end
end)

RegisterCommand("getpo",
                function(source, args) print(json.encode(GetAllReports())) end,
                false)

function GetVehicleModsInfo(id)
    local p = promise.new()
    local players = MySQL.query.await(
                        "SELECT plate,vehicle,garage,state, JSON_EXTRACT(mods, '$.engineHealth') AS engineHealth,JSON_EXTRACT(mods, '$.bodyHealth') AS bodyHealth,JSON_EXTRACT(mods, '$.fuelLevel') AS fuelLevel FROM player_vehicles WHERE citizenid = ?",
                        {id})
    p:resolve(players)
    return Citizen.Await(p)
end

function GetVehicleBolos()
    local p = promise.new()
    local vehicles = MySQL.query.await("SELECT * FROM fx_vehiclereports")
    p:resolve(vehicles)
    return Citizen.Await(p)
end

RegisterCommand("getsql", function(source, args)
    local Data = GetVehicleBolos()
    QBCore.Debug(Data)
end)
QBCore.Functions.CreateCallback("fx-mdt:GetPlayerInfo", function(source, cb, id)
    local Data = {}

   MySQL.query(
        "SELECT citizenid,JSON_EXTRACT(players.charinfo,'$.firstname') AS firstname, JSON_EXTRACT(players.charinfo,'$.lastname') AS lastname,JSON_EXTRACT(players.job,'$.grade.name') AS rank ,JSON_EXTRACT(players.job,'$.name') AS jobname, JSON_EXTRACT(players.charinfo,'$.phone') AS phone,  JSON_EXTRACT(players.job,'$.payment') AS payment FROM players  WHERE players.charinfo LIKE ? ",
        {string.lower('%' .. id .. '%')}, function(result)
            if result then
                for k, v in ipairs(result) do
                    local result1 = GetVehicleModsInfo(result[k].citizenid)
                    local Cases = GetAllReports(result[k].citizenid)
                    local Houses = MySQL.query.await(
                                       "SELECT house FROM player_houses WHERE citizenid = ?",
                                       {result[k].citizenid})
                    Data[#Data + 1] = {
                        Name = result[k].firstname,
                        LastName = deletecuotes(result[k].lastname),
                        CitizenID = result[k].citizenid,
                        Rank = deletecuotes(result[k].rank),
                        JobName = deletecuotes(result[k].jobname),
                        Payment = deletecuotes(result[k].payment),
                        Phone = deletecuotes(result[k].phone),
                        Vehicles = result1,
                        Houses = Houses,
                        Casos = Cases
                    }

                end

                cb(Data)
            end

        end)

end)

QBCore.Functions.CreateCallback("fx-mdt:server:GetWebhook", function(source, cb)
    if WebHook ~= "" then
        cb(WebHook)
    else
        print(
            'Set your webhook to ensure that your camera will work!!!!!! Set this on line 10 of the server sided script!!!!!')
        cb(nil)
    end
end)

RegisterNetEvent("fx-mdt:server:InsertReport", function(data)
    local src = source
    local PolicesOnDuty, count = QBCore.Functions.GetPlayersOnDuty("police") -- lets send the information to the on line officers 
    if IsPolice(src) then
        MySQL.insert("INSERT INTO fx_reports (id,citizenid,name,lastname,location,vehicleplate,information,evidencia,imagenes,fine,policesinvolved,jailtime,amount) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",
            {
                data.ID, data.citizenID, data.name, data.lastName,
                data.location, data.vehiclePlate, data.information,
                json.encode(data.evidencia), json.encode(data.imagen),
                json.encode(data.fines), json.encode(data.polices),
                data.jailTime, data.amount
            })
    Reports = data
    TriggerClientEvent("fx-mdt:client:onCreatedReport",-1,Reports)
    end
end)

RegisterNetEvent("fx-mdt:server:GetReports",function()
    TriggerClientEvent("fx-mdt:client:onCreatedReport",-1,Reports) --DONT SEND TO EVERYONE!
end)


QBCore.Functions.CreateCallback("fx-mdt:server:GetEvidence",function(source, cb)
    local src = source
    if IsPolice(src) then
        local Blood = {}
        local Bullets = {}
        local Player = QBCore.Functions.GetPlayer(src)
        local Item = Player.Functions.GetItemsByName("filled_evidence_bag")
        if Item then
            for k, v in ipairs(Item) do
                local element = Item[k]
                if element.info.type == "blood" then
                    local spl = string.fromhex(element.info.dnalabel)
                    Blood[#Blood + 1] = {
                        type = element.info.type,
                        street = element.info.street,
                        bloodtype = element.info.bloodtype,
                        dnalabel = element.info.dnalabel
                    }
                else
                    if element.info.type == "casing" then
                        Blood[#Blood + 1] = {
                            type = element.info.type,
                            street = element.info.street,
                            ammotype = element.info.ammotype,
                            ammolabel = element.info.ammolabel
                        }
                    end
                end
            end
        end
        cb(Blood)
    end
 
end)

function string.fromhex(str)
    return
        (str:gsub('..', function(cc) return string.char(tonumber(cc, 16)) end))
end

function deletecuotes(string) return (string:gsub('"(%d+)"', "%1")) end

QBCore.Functions.CreateCallback("fx-mdt:server:GetVehicleData",
                                function(source, cb, plate)
    local src = source
    local Placa = plate
    local Data = {}
    MySQL.query("SELECT citizenid, JSON_EXTRACT(mods,'$.color1') AS color,vehicle FROM player_vehicles WHERE plate = ?",
        {Placa}, function(result)
            if not result[1] then
                TriggerClientEvent("QBCore:Notify", source, "No Vehicle Found")
                cb({})
                return
            end
            local Veh = deletecuotes(result[1].vehicle)
            Data = {
                Citizenid = result[1].citizenid,
                Color = result[1].color,
                VehicleName = Veh,
                Category = QBCore.Shared.Vehicles[Veh].category,
                Brand = QBCore.Shared.Vehicles[Veh].brand
            }
            cb(Data)
        end)

end)

QBCore.Functions.CreateCallback("fx-mdt:server:GetPolices", function(source, cb)
    local src = source
    local Polices = GetPolicesOnD()
    cb(Polices)
end)

-- QBCore.Functions.CreateCallback("fx-mdt:server:SaveVehicleBolo",
--                                 function(source, cb, data)
--     local src = source
--     MySQL.Sync.insert("INSERT INTO fx_vehiclereports (id,plate,citizenid,color,vehicle,brand,category,information) VALUES (?,?,?,?,?,?,?,?)",
--         {
--             data.ID, data.Plate, data.Owner, data.Color, data.VehicleName,
--             data.Brand, data.Category, data.Information
--         })
-- end)

QBCore.Functions.CreateCallback("fx-mdt:server:GetVehicleBolos",
                                function(source, cb)
    local VehiclesBolos = GetVehicleBolos()
    cb(VehiclesBolos)
end)

RegisterNetEvent("fx-mdt:server:BloodMenu", function()
    local src = source
    if src > 0 then
        if IsPolice(src) then
            local Player = QBCore.Functions.GetPlayer(source)
            local Item = Player.Functions.GetItemsByName("filled_evidence_bag")
            if Player then
                if Item then
                    for k, v in ipairs(Item) do
                        local element = Item[k]
                        if element.info.type == "blood" then
                            local spl = string.fromhex(element.info.dnalabel)
                            local result = MySQL.query.await(
                                               "SELECT citizenid, JSON_EXTRACT(charinfo,'$.firstname') AS firstname, JSON_EXTRACT(charinfo,'$.lastname') AS lastname FROM players WHERE citizenid = ?",
                                               {spl})
                            local MailData = {
                                sender = "Hospital",
                                subject = "Blood Test",
                                message = "The result of the blood exam is " ..
                                    spl .. " The name is " ..
                                    deletecuotes(result[1].firstname) .. " " ..
                                    deletecuotes(result[1].lastname)
                            }
                            TriggerEvent("qb-phone:server:sendNewMailToOffline",
                                         Player.PlayerData.citizenid, MailData)
                        end
                    end
                end
            end
        end
    end
end)

function GetPolicesToSend()
    local Polices = QBCore.Functions.GetQBPlayers()
    for k,v in ipairs(Polices) do
        local element = Polices[k]
        if element.PlayerData.job.name == "police" then
            return element.PlayerData.source
        end
    end
    -- body
end

RegisterNetEvent("fx-mdt:server:SaveVehicleBolo",function ( data )
      local src = source
      local Polices = GetPolicesToSend()
      Bolos[#Bolos+1] = data
                MySQL.insert("INSERT INTO fx_vehiclereports (id,plate,citizenid,color,vehicle,brand,category,information) VALUES (?,?,?,?,?,?,?,?)",
        {
            data.id, data.plate, data.citizenid, data.color, data.vehicle,
            data.brand, data.category, data.information
        })
  
             TriggerClientEvent("fx-mdt:client:SaveVehicleBolo",-1,Bolos)

end)



CreateThread(function() 
Wait(200)
  TriggerEvent("fx-mdt:server:sendBolosToPlayers")
end)

RegisterNetEvent("fx-mdt:server:sendBolosToPlayers",function() 

local bolos = GetVehicleBolos()
Bolos = bolos
TriggerClientEvent("fx-mdt:client:SaveVehicleBolo",-1,Bolos)

end)
-- RegisterNetEvent("fx-mdt:server:GetBlood", function()
--     local dato = {}
--     if IsPolice(source) then
--         local Player = QBCore.Functions.GetPlayer(source)
--         local Item = Player.Functions.GetItemsByName("filled_evidence_bag")
--         if Player then
--             if Item then
--                 local ar = {1, 3, 4, 5, 6, 7, 8, 9, 0}
--                 for k, v in ipairs(ar) do
--                     --  local element = Item[k]
--                     -- if element.info.type == "blood" then
--                     -- local spl = string.fromhex(element.info.dnalabel)
--                     dato = {
--                         header = "Test",
--                         submitText = "Bill",
--                         inputs = {
--                             {
--                                 text = "no",
--                                 name = "No",
--                                 type = "select",
--                                 options = {{value = k, text = k .. " label"}}

--                             }
--                         }
--                     }

--                     TriggerClientEvent('qb-input:client:showInput', -1, dato)

--                     -- end
--                 end
--             end
--         end
--     end
-- end)

