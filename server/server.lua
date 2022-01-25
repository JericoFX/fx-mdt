local QBCore = exports['qb-core']:GetCoreObject()
local GetPlayer = QBCore.Functions.GetPlayer
QBCore.Functions.CreateCallback("fx-mdt:GetPlayerClosestInfo",
                                function(source, cb, id)
    local Player = QBCore.Functions.GetPlayer(id)
    local Name = Player.PlayerData.charinfo.firstname
    local LastName = Player.PlayerData.charinfo.lastname
    local Cid = Player.PlayerData.citizenid
    local Job = Player.PlayerData.job.name
    local Rank = Player.PlayerData.job.grade.name
    local result1 = GetVehicleModsInfo(Player.PlayerData.citizenid)
    cb({name = Name, lastname = LastName, citizenid = Cid,Job = Job,Rank = Rank,Vehicles = result1})
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
  local players = exports.oxmysql:fetchSync("SELECT citizenid,JSON_EXTRACT(players.charinfo,'$.firstname') AS Name,JSON_EXTRACT(players.charinfo,'$.lastname') AS LastName, JSON_EXTRACT(players.job,'$.grade.name') AS Rank,JSON_EXTRACT(players.job,'$.name') AS JobName, JSON_EXTRACT(players.job,'$.onduty') AS OnDuty FROM `players` WHERE `job` LIKE '%police%'")
  p:resolve(players)
  return Citizen.Await(p)
end



function IsPolice(src)
  local p = promise.new()
  local Player = QBCore.Functions.GetPlayer(src)
  p:resolve(Player.PlayerData.job.name)
  return Citizen.Await(p)
end

RegisterCommand("getpo", function(source, args)
  local src = source
  local result = IsPolice(src)
print(result)


end, false)

function GetVehicleModsInfo(id)
local p = promise.new()
local players = exports.oxmysql:fetchSync("SELECT plate,vehicle,garage,state, JSON_EXTRACT(mods, '$.engineHealth') AS engineHealth,JSON_EXTRACT(mods, '$.bodyHealth') AS bodyHealth,JSON_EXTRACT(mods, '$.fuelLevel') AS fuelLevel FROM player_vehicles WHERE citizenid = ?",{id})
p:resolve(players)
return Citizen.Await(p)
end

RegisterCommand("getsql",function(source,args) 
  local players = exports.oxmysql:fetchSync("UPDATE player_vehicles SET mods = JSON_REPLACE(mods,'$.engineHealth',?,'$.bodyHealth',?,'$.fuelLevel',?) WHERE plate = ?",{100.1,100.1,100.1,"25HMB316"})
QBCore.Debug(players)

 --SELECT JSON_REPLACE(mods, '$.engineHealth', 9) AS 'Result' FROM player_vehicles WHERE plate = "25HMB316"
end)
QBCore.Functions.CreateCallback("fx-mdt:GetPlayerInfo",function(source,cb,id)
  local Data = {}
  exports.oxmysql:fetch( "SELECT citizenid,JSON_EXTRACT(players.charinfo,'$.firstname') AS firstname,JSON_EXTRACT(players.charinfo,'$.lastname') AS lastname, JSON_EXTRACT(players.job,'$.grade.name') AS rank ,JSON_EXTRACT(players.job,'$.name') AS jobname, JSON_EXTRACT(players.charinfo,'$.phone') AS phone, JSON_EXTRACT(players.job,'$.payment') AS payment FROM `players` WHERE `charinfo` LIKE ? ", {string.lower('%'..id..'%')}, function(result)
  
  

    for k,v in pairs(result) do
      local PlayerOnline = QBCore.Functions.GetPlayer(result[k].citizenid)
      local result1 = GetVehicleModsInfo(result[k].citizenid)
      if PlayerOnline then
        Data[#Data+1] = {Name = PlayerOnline.PlayerData.charinfo.firstname,
                        LastName = PlayerOnline.PlayerData.charinfo.lastname,
                        CitizenID = PlayerOnline.PlayerData.citizenid,
                        Rank = PlayerOnline.PlayerData.job.grade.name,
                        JobName = PlayerOnline.PlayerData.job.name,
                        Payment = PlayerOnline.PlayerData.job.payment,
                        Phone = PlayerOnline.PlayerData.charinfo.phone,
                        Vehicles = result1
                      }
      else
        Data[#Data+1] = {Name = result[k].firstname,
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
