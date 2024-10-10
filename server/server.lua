RegisterServerEvent('ultrax:npc:robbed', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemTable = Ultrax.Robbing.Rewards.Items
    local randomItem = itemTable[math.random(#itemTable)] 
    local Chance = math.random(1,3)



    print(Chance)
    if Chance == 1 then
        xPlayer.addMoney(Ultrax.Robbing.Rewards.Cash.amount)
    elseif Chance == 2 then
        xPlayer.addInventoryItem(randomItem.name, randomItem.count)
    else
        xPlayer.addInventoryItem(randomItem.name, randomItem.count)
        xPlayer.addMoney(Ultrax.Robbing.Rewards.Cash.amount)
    end
end)