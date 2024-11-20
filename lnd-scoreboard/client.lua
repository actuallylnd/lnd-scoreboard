local isIdDisplaying = false
local ActiveKey = 20
local playersCheckingID = {}
local visibleDistance = 25.0
local aboveHead = 1.2

TextConfig = {
    scale = {0.5, 0.5},
    font = 4,
    color = {255, 255, 255, 255},
    outline = true,
}

local InCarColor = {255, 160, 0, 255}
local ActiveColor = {84, 5, 163, 255}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if IsControlPressed(0, ActiveKey) then
            if not isIdDisplaying then
                isIdDisplaying = true
                TriggerServerEvent("lnd-scoreboard:checkID", true)
            end
        else
            if isIdDisplaying then
                isIdDisplaying = false
                TriggerServerEvent("lnd-scoreboard:checkID", false)
            end
        end

        if isIdDisplaying then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            local color = TextConfig.color

            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                color = InCarColor
            end

            DrawPlayerId(playerCoords.x, playerCoords.y, playerCoords.z + aboveHead, GetPlayerServerId(PlayerId()), color)

            for _, player in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                local targetCoords = GetEntityCoords(targetPed)
                local distance = #(playerCoords - targetCoords)
            
                if distance < visibleDistance and playerPed ~= targetPed then
                    if HasEntityClearLosToEntity(playerPed, targetPed, 17) then
                        local color = TextConfig.color
            
                        local vehicle = GetVehiclePedIsIn(targetPed, false)
                        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == targetPed then
                            color = InCarColor
                        end
            
                        DrawPlayerId(targetCoords.x, targetCoords.y, targetCoords.z + aboveHead, GetPlayerServerId(player), color)
                    end
                end
            end
            
        end

        for serverId, _ in pairs(playersCheckingID) do

            -- if serverId ~= GetPlayerServerId(PlayerId()) then
            --     local targetPed = GetPlayerPed(GetPlayerFromServerId(serverId))
            --     local targetCoords = GetEntityCoords(targetPed)
            --     local playerCoords = GetEntityCoords(PlayerPedId())
            --     local distance = #(playerCoords - targetCoords)
    
            --     color =  {84, 5, 163, 255}
            --     if distance < visibleDistance then
            --         DrawPlayerId(targetCoords.x, targetCoords.y, targetCoords.z + aboveHead, serverId, ActiveColor)
            --     end
            -- end


            local targetPed = GetPlayerPed(GetPlayerFromServerId(serverId))
            local targetCoords = GetEntityCoords(targetPed)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - targetCoords)
            
            if distance < visibleDistance then
                if HasEntityClearLosToEntity(PlayerPedId(), targetPed, 17) then
                    DrawPlayerId(targetCoords.x, targetCoords.y, targetCoords.z + aboveHead, serverId, ActiveColor)
                end
            end
        end
    end
end)

function DrawPlayerId(x, y, z, id, color)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(TextConfig.scale[1], TextConfig.scale[2])
        SetTextFont(TextConfig.font)
        SetTextColour(color[1], color[2], color[3], color[4])
        SetTextEntry('STRING')

        if TextConfig.outline then
            SetTextOutline()
        end

        AddTextComponentString(tostring(id))
        DrawText(_x, _y)
    end
end

RegisterNetEvent("lnd-scoreboard:updateCheckers")
AddEventHandler("lnd-scoreboard:updateCheckers", function(checkingPlayers)
    playersCheckingID = checkingPlayers
end)
