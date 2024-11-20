local playersCheckingID = {}

RegisterNetEvent("lnd-scoreboard:checkID")
AddEventHandler("lnd-scoreboard:checkID", function(isChecking)
    local src = source
    if isChecking then
        playersCheckingID[src] = true
    else
        playersCheckingID[src] = nil
    end

    TriggerClientEvent("lnd-scoreboard:updateCheckers", -1, playersCheckingID)
end)
