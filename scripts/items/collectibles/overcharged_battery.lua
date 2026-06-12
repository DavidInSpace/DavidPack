local player = Isaac.GetPlayer()
local playerEffects
local overcharges
local enemiesKilled = 0

local font = Font()
font:Load("font/pftempestasevencondensed.fnt")


function david_pack:renderOverchargesNumber()
    player = Isaac.GetPlayer()
    if player:HasCollectible(david_pack.Collectible.OVERCHARGED_BATTERY) then
        playerEffects = player:GetEffects()
        overcharges = playerEffects:GetNullEffectNum(david_pack.NullItem.OVERCHARGED_BATTERY_CHARGE)
        font:DrawStringScaled(tostring(overcharges) .. "x", 50, 35, 1, 1, KColor(1, 1, 1, 1), 0, true)
    end
end

function david_pack:useItemWithOverchargedBattery(collectibleID, rngObj, playerWhoUsedItem, useFlags, activeSlot, varData)
    local chargeType = Isaac.GetItemConfig():GetCollectible(collectibleID).ChargeType
    player = Isaac.GetPlayer()
    if player:HasCollectible(david_pack.Collectible.OVERCHARGED_BATTERY) and chargeType ~= "special" then
        playerEffects = player:GetEffects()
        overcharges = playerEffects:GetNullEffectNum(david_pack.NullItem.OVERCHARGED_BATTERY_CHARGE)
        if overcharges > 0 then
            playerEffects:RemoveNullEffect(david_pack.NullItem.OVERCHARGED_BATTERY_CHARGE, 1)
            return { Discharge = false }
        end
    end
end

function david_pack:OverchargedBatteryOnRoomClear()
    player = Isaac.GetPlayer()
    if player:HasCollectible(david_pack.Collectible.OVERCHARGED_BATTERY) then
        local room = Game():GetRoom()
        local roomShape = room:GetRoomShape()
        playerEffects = player:GetEffects()
        overcharges = playerEffects:GetNullEffectNum(david_pack.NullItem.OVERCHARGED_BATTERY_CHARGE)
        if overcharges >= 3 then return end
        if roomShape == 13 then return end
        for slot = 0, 1 do
            local totalActiveCharge = player:GetTotalActiveCharge(slot)
            local ActiveItem = player:GetActiveItem(slot)
            local ActiveItemConfig = Isaac.GetItemConfig():GetCollectible(ActiveItem)
            if ActiveItem == nil or totalActiveCharge == nil or ActiveItemConfig == nil then return end
            if room:GetRoomShape() >= 8 and totalActiveCharge >= ActiveItemConfig.MaxCharges then
                player:AddActiveCharge(2, slot, true, true, true)
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and totalActiveCharge >= ActiveItemConfig.MaxCharges then
                    player:AddActiveCharge(-2, slot, true, true, true)
                end
            elseif totalActiveCharge >= ActiveItemConfig.MaxCharges then
                player:AddActiveCharge(1, slot, true, true, true)
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and totalActiveCharge >= ActiveItemConfig.MaxCharges then
                    player:AddActiveCharge(-1, slot, true, true, true)
                end
            end
            if totalActiveCharge == ActiveItemConfig.MaxCharges * 2 then
                player:AddActiveCharge(-ActiveItemConfig.MaxCharges, slot, true, true, true)
                player:AddNullItemEffect(david_pack.NullItem.OVERCHARGED_BATTERY_CHARGE)
            end
        end
    end
end

david_pack:AddCallback(ModCallbacks.MC_HUD_RENDER, david_pack.renderOverchargesNumber)
david_pack:AddCallback(ModCallbacks.MC_USE_ITEM, david_pack.useItemWithOverchargedBattery)
david_pack:AddCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, david_pack.OverchargedBatteryOnRoomClear)
--[[
local function turnBatteriesToPoop(entityType, variant)
    player = Isaac.GetPlayer()
    if not player:HasCollectible(david_pack.Collectible.OVERCHARGED_BATTERY) then return end
    if entityType ~= nil and variant ~= nil then
        if entityType == EntityType.ENTITY_PICKUP and variant == PickupVariant.PICKUP_LIL_BATTERY then
            local random = math.random(0, 2)

            if random == 0 then
                return { EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, PoopPickupSubType.POOP_BIG }
            else
                return { EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, PoopPickupSubType.POOP_SMALL }
            end
        end
    end

    for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_LIL_BATTERY then
            local random = math.random(0, 2)

            if random == 0 then
                entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, PoopPickupSubType
                    .POOP_SMALL)
            else
                entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, PoopPickupSubType
                    .POOP_SMALL)
            end
        end
    end
end

function david_pack:stopBatterySpawn(entityType, variant)
    --return turnBatteriesToPoop(entityType, variant)
end

function david_pack:postNewRoom()
    --turnBatteriesToPoop()
end

function david_pack:overchargedBatteryJumperCables(entity, entityRef)
    print("Entity Kill: ", entity, entityRef.Type)
    player = Isaac.GetPlayer()
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_JUMPER_CABLES) then return end
    if entityRef.Type == EntityType.ENTITY_PLAYER or entityRef.Type == EntityType.ENTITY_TEAR then return end
    enemiesKilled = enemiesKilled + 1
    print("Player Killed enemy")
    if enemiesKilled >= 15 then
        enemiesKilled = 0
        if player:HasCollectible(david_pack.Collectible.OVERCHARGED_BATTERY) then
            playerEffects = player:GetEffects()
            overcharges = playerEffects:GetNullEffectNum(david_pack.NullItem.OVERCHARGED_BATTERY_CHARGE)
            if overcharges >= 3 then return end

            for slot = 0, 1 do
                local totalActiveCharge = player:GetTotalActiveCharge(slot)
                local ActiveItem = player:GetActiveItem(slot)
                local ActiveItemConfig = Isaac.GetItemConfig():GetCollectible(ActiveItem)
                if ActiveItem == nil or totalActiveCharge == nil or ActiveItemConfig == nil then return end
                player:AddActiveCharge(1, slot, true, true, true)



                print("ActiveItem Properties: ", slot, ActiveItem, totalActiveCharge, ActiveItemConfig,
                    totalActiveCharge,
                    ActiveItemConfig.MaxCharges)
                if totalActiveCharge == ActiveItemConfig.MaxCharges * 2 then
                    player:AddActiveCharge(-ActiveItemConfig.MaxCharges, slot, true, true, true)
                    player:AddNullItemEffect(david_pack.NullItem.OVERCHARGED_BATTERY_CHARGE)
                end
            end
        end
    end
end]]

--david_pack:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, david_pack.overchargedBatteryJumperCables)

--david_pack:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, david_pack.stopBatterySpawn)
--david_pack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, david_pack.postNewRoom)
