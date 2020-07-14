
ESX = nil
blip = nil
isInDrugBuyLocation = false
hasDrugsToSell = false
deliveryMarker = nil
drugDeliveryPed = nil
drugDealerPed = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)


Citizen.CreateThread(function()
    while true do
        --DrawMarker(20, Config.DrugLocation, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, true, false, false, false)
        createDrugDealerPed()
        Wait(10);
    end
end)


Citizen.CreateThread(function()
    while true do
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        if(GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, Config.X, Config.Y, Config.Z, 1) < 2)
        then
            if(isInDrugBuyLocation == false)
            then
                ESX.ShowNotification("Press 'E' to buy drugs")
            end
            isInDrugBuyLocation = true
        else
            isInDrugBuyLocation = false
        end
        Wait(10);
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(10);
        if(isInDrugBuyLocation)
        then
            if(IsControlJustPressed(1, 38) )
            then
                Citizen.Trace("Opening UI")
                SetNuiFocus(true, true);
                SendNUIMessage({
                    type = 'open'
                })
                SetNuiFocus(true, true);
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
    Wait(100)
    ESX.TriggerServerCallback('drugbuying:check', function(postback)
        hasDrugsToSell = postback.hasDrugs
    end)
    end
end)




-- this thread is to always keep a delivery marker active until they have no drugs
Citizen.CreateThread(function()
    while true do
        Wait(0);
        if(hasDrugsToSell)
        then
                if(deliveryMarker == nil) --If marker is null then create a new marker
                then
                    local markerCount = tablelength(Config.DeliveryMarkers)
                    local randomPointIndex =  math.random (0, markerCount-1) 
                    deliveryMarker = Config.DeliveryMarkers[randomPointIndex]
                end
                drawBlipMarker(deliveryMarker)
        else
                cleanup()-- if player has no drugs, gave them away/dropped/died reset the marker
        end    
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(0);
        if(deliveryMarker ~= nil)
        then
            if(drugDeliveryPed == nil)
            then
                drawDeliveryPed()
            end
        end    
    end
end)

-- monitor player at drug delivery
Citizen.CreateThread(function()
    while true do
        Wait(10)
        if(deliveryMarker ~= null)
        then
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        if(GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, deliveryMarker.x, deliveryMarker.y, deliveryMarker.z, 1) < 2)
        then
            ESX.ShowNotification("Press 'E' to sell drugs")
            if(IsControlJustPressed(1, 38) )
            then
                exports['progressBars']:startUI(Config.SellingTime, "Selling...")
                FreezeEntityPosition(playerPed, true)
                Wait(Config.SellingTime)
                FreezeEntityPosition(playerPed, false)
                ESX.TriggerServerCallback('drugbuying:drugsDelivered', function(postback)
                    if(postback.DrugsSold)
                    then
                        ESX.ShowNotification("Sold " .. postback.Name .. " for $" .. postback.Amount)
                        
                    else
                        ESX.ShowNotification("Failed to sale drugs")
                    end
                    cleanup();
                end)
            end
        end
        end
    end
end)



function cleanup()
    if(DoesBlipExist(blip))
    then
        RemoveBlip(blip)
    end
    deliveryMarker = nil
    if(drugDeliveryPed ~= nil)
    then
        SetEntityAsNoLongerNeeded(drugDeliveryPed)
        drugDeliveryPed = nil
    end
end

function drawDeliveryPed()
    if(drugDeliveryPed == nil)
    then
        RequestModel(Config.DealerModel)
        while not HasModelLoaded(Config.DealerModel) do
        Wait(1)
        end
        drugDeliveryPed = CreatePed(4, Config.DealerModel, deliveryMarker.x, deliveryMarker.y, deliveryMarker.z, 0, false, true)
        SetBlockingOfNonTemporaryEvents(drugDeliveryPed, true)
        SetPedDiesWhenInjured(drugDeliveryPed, false)
        SetPedCanPlayAmbientAnims(drugDeliveryPed, true)
        SetPedCanRagdollFromPlayerImpact(drugDeliveryPed, false)
        SetEntityInvincible(drugDeliveryPed, true)
        SetEntityAsMissionEntity(drugDeliveryPed,true,true)
        Wait(2000) -- wait for ped to hit floor
        FreezeEntityPosition(drugDeliveryPed, true)
    end
end


function drawBlipMarker(deliveryMarker)
    if(deliveryMarker ~= nil)
    then
    if(DoesBlipExist(blip) == false)
    then
        blip = AddBlipForCoord(deliveryMarker.x,deliveryMarker.y,deliveryMarker.z)
        SetBlipSprite(blip, 496)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Deliver drugs")
        EndTextCommandSetBlipName(blip)
        SetBlipRoute(blip,1)
    end
end
end


function createDrugDealerPed()
    if(drugDealerPed == nil)
    then
    RequestModel(Config.DealerModel)
    while not HasModelLoaded(Config.DealerModel) do
    Wait(1)
    end
     drugDealerPed = CreatePed(4, Config.DealerModel, Config.DrugLocation.x, Config.DrugLocation.y, Config.DrugLocation.z, 0, false, true)
    SetBlockingOfNonTemporaryEvents(drugDealerPed, true)
    SetPedDiesWhenInjured(drugDealerPed, false)
    SetPedCanPlayAmbientAnims(drugDealerPed, true)
    SetPedCanRagdollFromPlayerImpact(drugDealerPed, false)
    SetEntityInvincible(drugDealerPed, true)
    SetEntityAsMissionEntity(drugDealerPed,true,true)
    Wait(2000) -- wait for ped to hit floor
    FreezeEntityPosition(drugDealerPed, true)
    end
end


function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


RegisterNUICallback('closeMenu', function()
    SendNUIMessage({
        type = 'close'
    })
    SetNuiFocus(false, false);
end)

RegisterNUICallback('buyDrugs', function(data,cb)
    Citizen.Trace("Server drug handler hit")
    Citizen.Trace("Buying drugs")
    ESX.TriggerServerCallback('drugbuying:buyDrugs', function(postback)
        cb(postback)
    end, data)
end)


RegisterNUICallback('getDrugs', function(data,cb)
    Citizen.Trace("Getting UI data")
    -- POST data gets parsed as JSON automatically
    -- and so does callback response data
    cb(Config.DrugStore)
end)