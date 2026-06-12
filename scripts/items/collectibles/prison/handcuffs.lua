local handcuffsLocked = false
local sfx = SFXManager()

local handcuffsIndicatorSprite = Sprite()
handcuffsIndicatorSprite:Load("gfx/handcuffs_indicator.anm2", true)
handcuffsIndicatorSprite:Play("Unlocked", true)

---@Type Entity
local keyedRoomEntities = {}

local function changeHandcuffsState(state, override)
    handcuffsLocked = state
    local player = Isaac.GetPlayer()
    if not player:HasCollectible(david_pack.Collectible.HANDCUFFS) then return end
    local playerEffects = player:GetEffects()
    if handcuffsLocked then
        if player:GetEffects():GetNullEffectNum(david_pack.NullItem.HANDCUFFED) < 1 or override then
            sfx:Play(SoundEffect.SOUND_UNLOCK00, 2, 2, false, 0.8)
            handcuffsIndicatorSprite:Play("Locked", true)
            playerEffects:AddNullEffect(david_pack.NullItem.HANDCUFFED)
            david_pack.actionsPermission.canUseActiveItem = false
            david_pack.actionsPermission.canUseCard = false
            david_pack.actionsPermission.canUsePill = false
            david_pack.actionsPermission.canPlaceBomb = false
            david_pack.actionsPermission.canPickupCollectible = { false, true }
            -- Preventing picking up pickups is handled seperatly in this script since you need to account for the handcuffs key
        end
    else
        if player:GetEffects():GetNullEffectNum(david_pack.NullItem.HANDCUFFED) > 0 or override then
            handcuffsIndicatorSprite:Play("Unlocked", true)
            sfx:Play(SoundEffect.SOUND_METAL_BLOCKBREAK, 1.5, 2, false, 1.2)
            playerEffects:RemoveNullEffect(david_pack.NullItem.HANDCUFFED)
            david_pack.actionsPermission.canUseActiveItem = true
            david_pack.actionsPermission.canUseCard = true
            david_pack.actionsPermission.canUsePill = true
            david_pack.actionsPermission.canPlaceBomb = true
            david_pack.actionsPermission.canPickupCollectible = { true, true }
            -- Preventing picking up pickups is handled seperatly in this script since you need to account for the handcuffs key
        end
    end
end

david_pack:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function()
    sfx:Play(SoundEffect.SOUND_KEY_DROP0, 1, 2, false, 0.45)
    changeHandcuffsState(false)
end, david_pack.Collectible.HANDCUFFS)

david_pack:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, function()
    changeHandcuffsState(false)
end, david_pack.Collectible.HANDCUFFS)

---@param entity Entity
---@param collider Entity
function david_pack:lockHandcuffs(entity, collider)
    --print("Lock Handcuffs: ", entity.Type, source.Entity:GetData().keyedEffect)
    if entity ~= nil and entity.Type == EntityType.ENTITY_PLAYER and collider:GetData().keyedEffect == true and entity:ToPlayer():HasCollectible(david_pack.Collectible.HANDCUFFS) then
        changeHandcuffsState(true)
    end
end

---@param npc EntityNPC
function david_pack:dropHandcuffsKey(npc)
    local player = Isaac.GetPlayer()
    if not player:HasCollectible(david_pack.Collectible.HANDCUFFS) or not player:GetEffects():HasNullEffect(david_pack.NullItem.HANDCUFFED) then return end

    local tableIndex = 0
    for _, keyedEntity in pairs(keyedRoomEntities) do
        local tableIndex = tableIndex + 1
        if npc.Type == keyedEntity.Type and npc.Variant == keyedEntity.Variant and npc.Index == keyedEntity.Index then
            local chance = math.random(1, 10)
            if chance <= 1 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, 30, david_pack.Pickup.HANDCUFFS_KEY, npc.Position, Vector(0, 0),
                    npc)
                table.remove(keyedRoomEntities, tableIndex)
            end
            break
        end
    end
end

david_pack:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, entityType, variant, subType)
    local player = Isaac.GetPlayer()
    if entityType == 1000 or entityType == 999 or entityType == 17 or entityType < 10 or not player:HasCollectible(david_pack.Collectible.HANDCUFFS) then return end
    local entityList = Isaac.FindByType(entityType, variant, subType, false, true)

    local entity = entityList[#entityList]

    if entity ~= nil then
        if entity:IsActiveEnemy(false) and entity.CollisionDamage > 0 then
            local chance = math.random(1, 10)
            if chance <= 5 then
                table.insert(keyedRoomEntities, entity)
                entity.CollisionDamage = 0.25
                entity.Mass = entity.Mass * 3
                entity.MaxHitPoints = entity.MaxHitPoints * 1.4
                entity.HitPoints = entity.MaxHitPoints
                entity:SetSize(entity.Size, Vector(1.3, 1.3), 15)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                entity:GetData().keyedEffect = true
            end
        end
    end
end)

local npcSprite = Sprite()
npcSprite:Load("gfx/icon_key_effect.anm2", true)
npcSprite:Play("Idle", true)

---@param npc EntityNPC
function david_pack:onNPCRender(npc)
    if npc:GetData().keyedEffect == true then
        npc:GetColor():SetTint(0.6, 0.6, 0.6, 1)
        local position = Isaac.WorldToScreen(npc.Position)
        npcSprite:Render(position + Vector(0, -40), Vector(0, 0), Vector(0, 0))
    end
end

david_pack:AddCallback(ModCallbacks.MC_HUD_RENDER, function()
    local player = Isaac.GetPlayer()
    if not player:HasCollectible(david_pack.Collectible.HANDCUFFS) then return end
    handcuffsIndicatorSprite:Render(Vector(140, 20))
end)

---@param pickup EntityPickup
david_pack:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    local player = Isaac.GetPlayer()
    if player:GetEffects():GetNullEffectNum(david_pack.NullItem.HANDCUFFED) < 1 then return end

    if pickup.Variant == 30 and pickup.SubType == david_pack.Pickup.HANDCUFFS_KEY then
        changeHandcuffsState(false)
        return nil
    end

    if pickup.Variant ~= 100 and pickup.Variant ~= 10 then
        return false
    end
end)

---@param projectile EntityProjectile
david_pack:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, function(_, projectile)
    local player = Isaac.GetPlayer()
    if not player:HasCollectible(david_pack.Collectible.HANDCUFFS) then return end
    --print("Projectile target: ", projectile.Target)
    local spawnerType = projectile.SpawnerType
    local spawnerVariant = projectile.SpawnerVariant
    local spawnerSubType = projectile.SubType
    local entityList = Isaac.FindByType(spawnerType, spawnerVariant, spawnerSubType, false, true)
    for _, entity in pairs(entityList) do
        if entity:GetData().keyedEffect then
            projectile:GetData().keyedEffect = true
        end
    end
end)

david_pack:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continued)
    if not continued then
        changeHandcuffsState(false, true)
        handcuffsLocked = false
        david_pack.actionsPermission.canUseActiveItem = true
        david_pack.actionsPermission.canUseCard = true
        david_pack.actionsPermission.canUsePill = true
        david_pack.actionsPermission.canPlaceBomb = true
        david_pack.actionsPermission.canPickupCollectible = { true, true }
        david_pack.actionsPermission.canPickupPickup = { true, true, true, true }
    end
end)

david_pack:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, function()
    if Isaac.GetPlayer():HasCollectible(david_pack.Collectible.HANDCUFFS) then
        keyedRoomEntities = {}
    end
end, david_pack.resetKeyedRoomEntitiesTable)

david_pack:AddCallback(ModCallbacks.MC_POST_PLAYER_COLLISION, david_pack.lockHandcuffs)
david_pack:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, david_pack.dropHandcuffsKey)
david_pack:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, david_pack.onNPCRender)
