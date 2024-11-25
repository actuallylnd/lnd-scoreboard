local isIdDisplaying = false
local ActiveKey = 20
local aboveHead = 1.0

local visibleDistance = 25.0
local extendedDistance = 45.0

local playerGroup = nil

local allowedGroups = {
    admin = true,
    best = true,
}

TextConfig = {
    scale = {0.5, 0.5},
    font = 4,
    color = {255, 255, 255, 255},
    outline = true,
}

local InCarColor = {255, 160, 0, 255}
local ActiveColor = {84, 5, 163, 255}
local checkingPlayers = {}


function CheckState(state)
    TriggerServerEvent("lnd-scoreboard:checkState", state)
end

RegisterNetEvent("lnd-scoreboard:updateCheckers")
AddEventHandler("lnd-scoreboard:updateCheckers", function(updatedCheckers, group)
    checkingPlayers = updatedCheckers
    playerGroup = group
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlPressed(0, ActiveKey) then
            if not isIdDisplaying then
                isIdDisplaying = true
                CheckState(true)
            end
        else
            if isIdDisplaying then
                isIdDisplaying = false
                CheckState(false)
            end
        end

        for id, _ in pairs(checkingPlayers) do
            for _, player in ipairs(GetActivePlayers()) do
                if GetPlayerServerId(player) == id then
                    local ped = GetPlayerPed(player)
                    if not allowedGroups[playerGroup] then
                        DrawPlayerId(ped, id, ActiveColor)
                    end
                end
            end
        end

        if isIdDisplaying then 
            local playerPed = cache.ped
            local color = ActiveColor

            local vehicle = cache.vehicle or 0
            if vehicle ~= 0 and cache.seat == -1 then
                color = InCarColor
            end

            if playerGroup and allowedGroups[playerGroup] then
                visibleDistance = extendedDistance
            end
            
            DrawPlayerId(playerPed, cache.serverId, color)

            for _, player in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                if targetPed ~= playerPed then
                    local targetCoords = GetEntityCoords(targetPed)
                    local distance = #(GetEntityCoords(playerPed) - targetCoords)
    
                    if distance < visibleDistance then
                        local color = TextConfig.color
    
                        local vehicle = cache.vehicle or 0
                        if vehicle ~= 0 and cache.seat == -1 then
                            color = InCarColor
                        end
                        
                        -- if checkingPlayers[GetPlayerServerId(player)] then
                        --     color = ActiveColor
                        -- end
                        
                        if HasEntityClearLosToEntity(playerPed, targetPed, 17) then
                            DrawPlayerId(targetPed, GetPlayerServerId(player), color)
                        end
                    end
                end
            end
        end

    end
end)

function DrawPlayerId(ped, id, color)
    local headBone = 128
    local headCoords = GetPedBoneCoords(ped, headBone, 0.0, 0.0, aboveHead)

    SetDrawOrigin(headCoords.x, headCoords.y, headCoords.z, 0)
    SetTextScale(TextConfig.scale[1], TextConfig.scale[2])
    SetTextFont(TextConfig.font)
    SetTextColour(color[1], color[2], color[3], color[4])
    SetTextEntry('STRING')

    if TextConfig.outline then
        SetTextOutline()
    end

    AddTextComponentString(tostring(id))
    DrawText(0.0, 0.0)

    ClearDrawOrigin()
end
