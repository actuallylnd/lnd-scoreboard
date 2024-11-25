local checkingPlayers = {}

RegisterServerEvent("coco-scoreboard:checkState")
AddEventHandler("coco-scoreboard:checkState", function(state)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local group = xPlayer.getGroup()

    if state then
        checkingPlayers[src] = true
    else
        checkingPlayers[src] = nil
    end

    TriggerClientEvent("coco-scoreboard:updateCheckers", -1, checkingPlayers, group)
end)
