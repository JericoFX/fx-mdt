local QBCore = exports['qb-core']:GetCoreObject()
local WebHook = ""
local MDT = {}
function MDT:Init()
    local self = self
    setmetatable(self, MDT)
    return self
end


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

function GetAllReports(tipo, id)
    local Data = {}
    local reports
    print(tipo, id)
    if id then
        reports = MySQL.scalar.await(
                      "SELECT id,citizenid,name,lastname,location,vehicleplate,information,evidencia, imagenes FROM fx_reports WHERE citizenid = ?",
                      {id})
        if reports then return reports end

    else
        reports = MySQL.query.await("SELECT * FROM fx_reports")
        if reports then
            for k, v in ipairs(reports) do
                local element = reports[k]
                Data[#Data + 1] = {
                    name = element.name,
                    lastname = element.lastname,
                    id = element.id,
                    location = element.location,
                    vehicleplate = element.vehicleplate,
                    information = element.information,
                    evidencia = json.decode(element.evidencia),
                    imagenes = json.decode(element.imagenes)
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
    print(source)
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
    -- local players = MySQL.Sync.fetchSingle(
    --     "UPDATE player_vehicles SET mods = JSON_REPLACE(mods,'$.engineHealth',?,'$.bodyHealth',?,'$.fuelLevel',?) WHERE plate = ?",
    --     {100.1, 100.1, 100.1, "25HMB316"}) -- Replace Data without taking the time to decode and encode again

    -- SELECT JSON_REPLACE(mods, '$.engineHealth', 9) AS 'Result' FROM player_vehicles WHERE plate = "25HMB316"
end)
QBCore.Functions.CreateCallback("fx-mdt:GetPlayerInfo", function(source, cb, id)
    local Data = {}

    MySQL.query(
        "SELECT citizenid,JSON_EXTRACT(players.charinfo,'$.firstname') AS firstname, JSON_EXTRACT(players.charinfo,'$.lastname') AS lastname,JSON_EXTRACT(players.job,'$.grade.name') AS rank ,JSON_EXTRACT(players.job,'$.name') AS jobname, JSON_EXTRACT(players.charinfo,'$.phone') AS phone,  JSON_EXTRACT(players.job,'$.payment') AS payment FROM players  WHERE players.charinfo LIKE ? ",
        {string.lower('%' .. id .. '%')}, function(result)
            QBCore.Debug(result)
            if result then
                for k, v in ipairs(result) do
                    print(json.encode(k))
                    local result1 = GetVehicleModsInfo(result[k].citizenid)
                    local Cases = GetAllReports(result[k].citizenid)
                    local Houses = MySQL.query.await("SELECT house FROM player_houses WHERE citizenid = ?",{result[k].citizenid})
                    Data[#Data + 1] = {
                        Name = result[k].firstname,
                        LastName = escape_str(result[k].lastname),
                        CitizenID = result[k].citizenid,
                        Rank = escape_str(result[k].rank),
                        JobName = escape_str(result[k].jobname),
                        Payment = escape_str(result[k].payment),
                        Phone = escape_str(result[k].phone),
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
    QBCore.Debug(data)
    local src = source

    MySQL.Sync.insert(
        "INSERT INTO fx_reports (id,citizenid,name,lastname,location,vehicleplate,information,evidencia,imagenes,fine,policesinvolved,jailtime,amount) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",
        {
            data.ID, data.citizenID, data.name, data.lastName, data.location,
            data.vehiclePlate, data.information, json.encode(data.evidencia),
            json.encode(data.imagen), json.encode(data.fines),
            json.encode(data.polices), data.jailTime, data.amount
        })

end)


QBCore.Functions.CreateCallback("fx-mdt:server:GetEvidence",
                                function(source, cb)
    local src = source
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
end)

function string.fromhex(str)
    return
        (str:gsub('..', function(cc) return string.char(tonumber(cc, 16)) end))
end

function deletecuotes (string)
    return (string:gsub('"(%d+)"', "%1"))
end

QBCore.Functions.CreateCallback("fx-mdt:server:GetVehicleData",
                                function(source, cb, plate)
    local src = source
    local Placa = plate
    local Data = {}
    MySQL.query("SELECT citizenid AS owner, JSON_EXTRACT(mods,'$.color1') AS color,vehicle FROM player_vehicles WHERE plate = ?",
        {Placa}, function(result)
            if not result[1]  then
                TriggerClientEvent("QBCore:Notify", source, "No Vehicle Found")
                cb({})
                return
            end
            local Veh = deletecuotes(result[1].vehicle)
            Data = {
                Owner = result[1].owner,
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

QBCore.Functions.CreateCallback("fx-mdt:server:SaveVehicleBolo",function(source,cb,data)
local src = source
    QBCore.Debug(data)
    MySQL.Sync.insert("INSERT INTO fx_vehiclereports (id,plate,citizenid,color,vehicle,brand,category,information) VALUES (?,?,?,?,?,?,?,?)",
    {
        data.ID,data.Plate,data.Owner,data.Color,data.VehicleName,data.Brand,data.Category,data.Information
    })
end)
TriggerLatent
QBCore.Functions.CreateCallback("fx-mdt:server:GetVehicleBolos",function(source,cb)
local VehiclesBolos = GetVehicleBolos()
QBCore.Debug(VehiclesBolos)
cb(VehiclesBolos)
end)
