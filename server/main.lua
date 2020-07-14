ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('drugbuying:buyDrugs', function(source, cb, drug)
     local total = 0;
     local _source = source
     local xPlayer = ESX.GetPlayerFromId(_source)
     local money = xPlayer.getInventoryItem('black_money');
     local drugsBought = false;
     for key, value in ipairs(drug) do
        local total = (value.BuyQty * value.Price)
        if(money.count >= total)
        then
            TriggerClientEvent('esx:showNotification', _source, "Drugs bought")
            drugsBought = true;
            xPlayer.addInventoryItem(value.DatabaseName,value.BuyQty) 
            xPlayer.removeInventoryItem('black_money', total)
        else
            TriggerClientEvent('esx:showNotification', _source, "Not enough to buy drugs")
        end
        cb({
            event = drugsBought
        })
     end
     Citizen.Trace("total ammount " .. total)
end)

ESX.RegisterServerCallback('drugbuying:check', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    for key, value in ipairs(Config.DrugStore.Drugs) do
        local ammount = xPlayer.getInventoryItem(value.DatabaseName);
        if(ammount.count > 0)
        then
            cb({
                hasDrugs = true
            })
        else
            cb({
                hasDrugs = false
            })
        end
    end
end)


ESX.RegisterServerCallback('drugbuying:drugsDelivered', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local drugsSold = false
    local drugSold = nil
    for key, value in ipairs(Config.DrugStore.Drugs) do
        local qty = xPlayer.getInventoryItem(value.DatabaseName);
        if(qty.count > 0)
        then
            drugSold = value
            xPlayer.removeInventoryItem(value.DatabaseName, 1)
            xPlayer.addInventoryItem('black_money',value.SellPrice) 
            drugsSold = true
            break
        end
    end
    if(drugSold ~= nil)
    then
        cb({
            DrugsSold = drugsSold,
            Amount = drugSold.SellPrice,
            Name = drugSold.Name
        })
    else
        cb({
            DrugsSold = drugsSold
        })
    end
    
end)

