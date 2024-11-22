local playersCheckingID = {}

RegisterNetEvent("lnd-scoreboard:checkID")
AddEventHandler("lnd-scoreboard:checkID", function(isChecking)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local group = xPlayer.getGroup()

    if isChecking then
        playersCheckingID[src] = true
    else
        playersCheckingID[src] = nil
    end

    TriggerClientEvent("lnd-scoreboard:updateCheckers", -1, playersCheckingID)
    TriggerClientEvent("lnd-scoreboard:updateGroup", src, group)
end)
