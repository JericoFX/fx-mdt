local QBCore = exports['qb-core']:GetCoreObject()
local WebHook =""
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
    local players = exports.oxmysql:fetchSync(
                        "SELECT citizenid,JSON_EXTRACT(players.charinfo,'$.firstname') AS Name,JSON_EXTRACT(players.charinfo,'$.lastname') AS LastName, JSON_EXTRACT(players.job,'$.grade.name') AS Rank,JSON_EXTRACT(players.job,'$.name') AS JobName, JSON_EXTRACT(players.job,'$.onduty') AS OnDuty FROM `players` WHERE `job` LIKE '%police%'")
    p:resolve(players)
    return Citizen.Await(p)
end

function GetAllReports(id)

    local Data = {}
    local reports
    if id then
        reports = exports.oxmysql:fetchSync(
                      "SELECT id,citizenid,name,lastname,location,vehicleplate,information,evidencia, imagenes FROM fx_reports WHERE id = ?",
                      {id})

    else
        reports = exports.oxmysql:fetchSync(
                      "SELECT id,citizenid,name,lastname,location,vehicleplate,information,evidencia, imagenes  FROM fx_reports")
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

    return Data
end

function IsPolice(src)

    local p = promise.new()
    local Player = QBCore.Functions.GetPlayer(src)
    p:resolve(Player.PlayerData.job.name)
    return Citizen.Await(p)
end
QBCore.Functions.CreateCallback("fx-mdt:server:GetReports", function(source, cb, id)
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
    local players = exports.oxmysql:fetchSync(
                        "SELECT plate,vehicle,garage,state, JSON_EXTRACT(mods, '$.engineHealth') AS engineHealth,JSON_EXTRACT(mods, '$.bodyHealth') AS bodyHealth,JSON_EXTRACT(mods, '$.fuelLevel') AS fuelLevel FROM player_vehicles WHERE citizenid = ?",
                        {id})
    p:resolve(players)
    return Citizen.Await(p)
end

RegisterCommand("getsql", function(source, args)
    local players = exports.oxmysql:fetchSync(
                        "UPDATE player_vehicles SET mods = JSON_REPLACE(mods,'$.engineHealth',?,'$.bodyHealth',?,'$.fuelLevel',?) WHERE plate = ?",
                        {100.1, 100.1, 100.1, "25HMB316"})

    -- SELECT JSON_REPLACE(mods, '$.engineHealth', 9) AS 'Result' FROM player_vehicles WHERE plate = "25HMB316"
end)
QBCore.Functions.CreateCallback("fx-mdt:GetPlayerInfo", function(source, cb, id)
    local Data = {}
    exports.oxmysql:fetch(
        "SELECT citizenid,JSON_EXTRACT(players.charinfo,'$.firstname') AS firstname,JSON_EXTRACT(players.charinfo,'$.lastname') AS lastname, JSON_EXTRACT(players.job,'$.grade.name') AS rank ,JSON_EXTRACT(players.job,'$.name') AS jobname, JSON_EXTRACT(players.charinfo,'$.phone') AS phone, JSON_EXTRACT(players.job,'$.payment') AS payment FROM `players` WHERE `charinfo` LIKE ? ",
        {string.lower('%' .. id .. '%')}, function(result)

            for k, v in pairs(result) do
                local PlayerOnline = QBCore.Functions.GetPlayer(result[k]
                                                                    .citizenid)
                local result1 = GetVehicleModsInfo(result[k].citizenid)
                if PlayerOnline then
                    Data[#Data + 1] = {
                        Name = PlayerOnline.PlayerData.charinfo.firstname,
                        LastName = PlayerOnline.PlayerData.charinfo.lastname,
                        CitizenID = PlayerOnline.PlayerData.citizenid,
                        Rank = PlayerOnline.PlayerData.job.grade.name,
                        JobName = PlayerOnline.PlayerData.job.name,
                        Payment = PlayerOnline.PlayerData.job.payment,
                        Phone = PlayerOnline.PlayerData.charinfo.phone,
                        Vehicles = result1
                    }
                else
                    Data[#Data + 1] = {
                        Name = result[k].firstname,
                        LastName = result[k].lastname,
                        CitizenID = result[k].citizenid,
                        Rank = result[k].rank,
                        JobName = result[k].jobname,
                        Payment = result[k].payment,
                        Phone = result[k].phone,
                        Vehicles = result1
                    }
                end
            end
            cb(Data)
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

    exports.oxmysql:execute(
        "INSERT INTO fx_reports (id,citizenid,name,lastname,location,vehicleplate,information,evidencia,imagenes) VALUES (?,?,?,?,?,?,?,?,?)",
        {
            data.ID, data.citizenID, data.name, data.lastName, data.location,
            data.vehiclePlate, data.information, json.encode(data.evidencia),
            json.encode(data.imagen)
        })

end)
RegisterCommand("sqlputo", function(source, args)

    exports.oxmysql:execute('INSERT INTO fx_reports VALUES (?,?,?,?,?,?,?,?,?)',
                            {1, 1, 1, 2, 3, 4, 5, 6, 7}, function(putos) end)

end, false)

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
    SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(Blood), -1)
    cb(Blood)
end)

function string.fromhex(str)
    return
        (str:gsub('..', function(cc) return string.char(tonumber(cc, 16)) end))
end
