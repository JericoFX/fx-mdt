-- local QBCore = exports['qb-core']:GetCoreObject()
-- local insidePinkCage = false
-- CreateThread(function()
--     local BloodTest = BoxZone:Create(vector3(319.87, -596.03, 43.29), 1, 1,
--                                      {name = "BloodTest", debugPoly = true})

--     BloodTest:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside,
--                                                                 point)
--         insidePinkCage = isPointInside
--     end)

-- end)

-- RegisterCommand('OpenMenu',
--                 function() if insidePinkCage then AnalizeBlood() end end, false)

-- RegisterKeyMapping('OpenMenu', 'Open Blood Menu', 'keyboard', 'e')

-- function AnalizeBlood()
--     local MenuData = {
--         {header = "Blood Sample", isMenuHeader = true}, {
--             header = "Start test",
--             txt = "click?",
--             params = {isServer = true, event = "fx-mdt:server:GetBlood"}
--         }
--     }

--     exports["qb-menu"]:openMenu(MenuData)

-- end
-- 1) FROM THE MDT, SELECT THE BLOOD SAMPLE TO SEND TO THE LABORATORY
-- 2) NO NEED FOR A UI, JUST A COOLDOWN EVENT MAYBE CRON TO "PROCESS THE BLOOD"
-- 3) WHEN THAT COOLDOWN IS 0, SEND AN EMAIL TO THE PLAYER THAT THE BLOOD IS READY WITH THE INFO
-- 4) FROM THE MDT IN ANOTHER PLACE YOU CAN SEE THE DETAILS.