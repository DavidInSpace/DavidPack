local mod = david_pack
local otherside_mod = RegisterMod("TBOI Otherside", 1)
local WEIRD_MIRROR = Isaac.GetItemIdByName("Weird Mirror")


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlags)
    if not player:HasCollectible(mod.Collectible.KAYOS_NOX) then return end
    local effects = player:GetEffects()
    local count = effects:GetCollectibleEffectNum(mod.Collectible.KAYOS_NOX) +
        player:GetCollectibleNum(mod.Collectible.KAYOS_NOX)
    if count < 1 then return end


    player:CheckFamiliar(mod.Familiar.KAYOS_NOX, count, RNG(),
        Isaac.GetItemConfig():GetCollectible(mod.Collectible.KAYOS_NOX))
end, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    familiar:AddToFollowers()
end, mod.Familiar.KAYOS_NOX)


local fireCoolDown = 10

---@param familiar EntityFamiliar
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
    ---@type Sprite
    local sprite = familiar:GetSprite()

    if not sprite:IsPlaying("Walk") and not sprite:IsPlaying("Attack") and not sprite:IsFinished("Appear") then
        sprite:Play("Walk")
    end

    local nearestEnemy = nil
    for _, enemy in pairs(mod:getRoomEnemies(true)) do
        if nearestEnemy ~= nil then
            familiar.Position:Distance(enemy)
        end
    end

    fireCoolDown = fireCoolDown - 1
    if fireCoolDown <= 0 then
        fireCoolDown = 15 -
            ((familiar.Player:GetNumCoins() + familiar.Player:GetNumBombs() + familiar.Player:GetNumKeys()) / 22)
        local nearestEnemy = mod:getNearestRoomEnemy(familiar.Position)
        if nearestEnemy ~= nil then
            local shotDirection = nearestEnemy.Position - familiar.Position

            --print(shotDirection.X, shotDirection.Y)
            --print("Clamped: ", shotDirection:Clamped(-100, -100, 100, 100))

            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position,
                shotDirection / (nearestEnemy.Position:Distance(familiar.Position) / 10), familiar):ToTear()

            tear.CollisionDamage = 2.5
            if tear ~= nil then
                tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
            end
            --print("SHOOT!")
        end
    end

    familiar:FollowParent()
end, mod.Familiar.KAYOS_NOX)


local kayosNoxedEntityIndex = 0

---@param entity Entity
---@param source EntityRef
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source)
    if entity:IsActiveEnemy(false) and source.SpawnerVariant == mod.Familiar.KAYOS_NOX and entity.HitPoints <= 5 then
        kayosNoxedEntityIndex = entity.Index
        --print("matches", kayosNoxedEntityIndex, entity.Index)
    elseif entity:IsActiveEnemy(false) then
        kayosNoxedEntityIndex = 0
    end
end)

local function spawnPill(npc)
    local pillChance = math.random(1, 20)
    if pillChance < 15 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, math.random(1, 13), npc.Position,
            Vector(0, 0), npc)
    elseif pillChance >= 15 and pillChance < 20 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, math.random(1, 13) + 2048, npc.Position,
            Vector(0, 0), npc)
    elseif pillChance == 20 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 14, npc.Position, Vector(0, 0), npc)
    end
end

---@param npc EntityNPC
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if npc.Index == kayosNoxedEntityIndex then
        kayosNoxedEntityIndex = 0
        local randomCollectible = mod:getCollectibleFromRandomPool(false)
        local chance = math.random(0, 100)
        if chance == 100 then
            Isaac.Spawn(5, 100, randomCollectible, npc.Position, Vector.Zero, npc)
        elseif chance >= 75 and chance < 100 then
            Isaac.GetPlayer():AddMinisaac(npc.Position, true)
        elseif chance >= 60 and chance < 75 then
            spawnPill(npc)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
    local roomCollectibles = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
    for _, collectible in pairs(roomCollectibles) do
        if collectible.SubType == mod.Collectible.KAYOS_NOX then
            for i = 0, 10 do
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, collectible.Position - mod:getRandomVector(-100, 100, -100, 100), Vector.Zero, nil)
            end
            collectible:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.Collectible.CREEPER)
            break
        end
    end
end, WEIRD_MIRROR)
