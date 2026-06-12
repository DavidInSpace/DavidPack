local mod = david_pack
local game = Game()
local sfx = SFXManager()

local PICKUP_SPAWN_TIME_FRAME = 1800

local nextPickupSpawnTime = 1800 -- 1800 frames = 30 seconds

local timeTillPickupSpawn = 0


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlags)
    if not player:HasCollectible(mod.Collectible.OVERCHARGED_BABY) then return end
    local effects = player:GetEffects()
    local count = effects:GetCollectibleEffectNum(mod.Collectible.OVERCHARGED_BABY) +
        player:GetCollectibleNum(mod.Collectible.OVERCHARGED_BABY)
    if count < 1 then return end

    player:CheckFamiliar(mod.Familiar.OVERCHARGED_BABY, count, RNG(),
        Isaac.GetItemConfig():GetCollectible(mod.Collectible.OVERCHARGED_BABY))
end, CacheFlag.CACHE_FAMILIARS)


---@param familiar EntityFamiliar
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    familiar:AddToFollowers()
end, mod.Familiar.OVERCHARGED_BABY)


---@param familiar EntityFamiliar
local function spawnPickup(familiar)
    local chance = math.random(0, 1)
    if chance == 0 then return end
    local actionType = math.random(1, 3)
    if actionType == 1 then
        for _, enemy in pairs(mod:getRoomEnemies(false)) do
            enemy:AddConfusion(EntityRef(familiar), 8)
        end
    elseif actionType == 2 then
        local player = Isaac.GetPlayer()
        for slot = 0, 1 do
            local activeItem = player:GetActiveItem(slot)
            if activeItem == nil then return end
            local activeItemConfig = Isaac.GetItemConfig():GetCollectible(activeItem)
            if activeItemConfig ~= nil and activeItemConfig.ChargeType ~= ChargeType.SPECIAL then
                player:AddActiveCharge(math.floor(activeItemConfig.MaxCharges / 2), slot)
            end
        end
    elseif actionType == 3 then
        local batteryType = math.random(1, 3)
        if batteryType > 1 then
            Isaac.Spawn(5, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL, familiar.Position,
                Vector.Zero, familiar)
        else
            Isaac.Spawn(5, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_MEGA, familiar.Position, Vector.Zero,
                familiar)
        end
    end
end


---@param familiar EntityFamiliar
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
    ---@type Sprite
    local sprite = familiar:GetSprite()

    if not Game():GetLevel():GetCurrentRoomDesc().Clear then
        timeTillPickupSpawn = timeTillPickupSpawn + 4
        --print("Pickup Spawn Times: ", timeTillPickupSpawn, nextPickupSpawnTime, PICKUP_SPAWN_TIME_FRAME)
        if timeTillPickupSpawn >= nextPickupSpawnTime and nextPickupSpawnTime < (PICKUP_SPAWN_TIME_FRAME * 4) + 10 then
            nextPickupSpawnTime = nextPickupSpawnTime + PICKUP_SPAWN_TIME_FRAME
            sprite:Play("SpawnPickup")
            if sprite:WasEventTriggered("Spawn") then
                spawnPickup(familiar)
            end
           

        end
    end


    if not sprite:IsPlaying("Walk") and not sprite:IsPlaying("SpawnPickup") and not sprite:IsFinished("Appear") then
        sprite:Play("Walk")
    end

    familiar:FollowParent()
end, mod.Familiar.OVERCHARGED_BABY)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(mod.Collectible.OVERCHARGED_BABY) then
        nextPickupSpawnTime = PICKUP_SPAWN_TIME_FRAME
        timeTillPickupSpawn = 0
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
            PICKUP_SPAWN_TIME_FRAME = PICKUP_SPAWN_TIME_FRAME / 2
        else
            PICKUP_SPAWN_TIME_FRAME = 1800
        end
    end
end)
