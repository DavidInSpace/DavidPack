local mod = david_pack
local game = Game()
local sfx = SFXManager()
local otherside_mod = RegisterMod("TBOI Otherside", 1)
local WEIRD_MIRROR = Isaac.GetItemIdByName("Weird Mirror")


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlags)
    if not player:HasCollectible(mod.Collectible.CREEPER) then return end
    local effects = player:GetEffects()
    local count = effects:GetCollectibleEffectNum(mod.Collectible.CREEPER) +
        player:GetCollectibleNum(mod.Collectible.CREEPER)
    if count < 1 then return end


    player:CheckFamiliar(mod.Familiar.CREEPER, count, RNG(),
        Isaac.GetItemConfig():GetCollectible(mod.Collectible.CREEPER))
end, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    familiar:AddToFollowers()
end, mod.Familiar.CREEPER)


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
        fireCoolDown = 60 -
            ((familiar.Player:GetNumCoins() + familiar.Player:GetNumBombs() + familiar.Player:GetNumKeys()) / 10)
        local nearestEnemy = mod:getNearestRoomEnemy(familiar.Position)


        if nearestEnemy ~= nil then
            local inSight = Game():GetRoom():CheckLine(familiar.Position, nearestEnemy.Position, LineCheckMode.PROJECTILE)
            --print("Is In Sight: ", inSight)
            if inSight then
                local shotDirection = nearestEnemy.Position - familiar.Position
                sfx:Play(mod.Sound.CREEPER_HISS, 1, 2, false, math.random(85, 115) / 100)

                --print(shotDirection.X, shotDirection.Y)
                --print("Clamped: ", shotDirection:Clamped(-100, -100, 100, 100))

                local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position,
                    shotDirection / (nearestEnemy.Position:Distance(familiar.Position) / 10), familiar):ToTear()
                if tear == nil then return end
                tear.CollisionDamage = 15
                tear.Size = 5
                
                tear:GetColor():SetTint(0, 1, 0, 0.5)
            
                if tear ~= nil then
                    tear:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)
                end
                --print("SHOOT!")
            end
        end
    end

    familiar:FollowParent()
end, mod.Familiar.CREEPER)

local CreeperedEntityIndex = 0

---@param entity Entity
---@param source EntityRef
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source)
    if entity:IsActiveEnemy(false) and source.SpawnerVariant == mod.Familiar.CREEPER and entity.HitPoints <= 10 then
        CreeperedEntityIndex = entity.Index
    elseif entity:IsActiveEnemy(false) then
        CreeperedEntityIndex = 0
    end
end)


---@param npc EntityNPC
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if npc.Index == CreeperedEntityIndex then
        CreeperedEntityIndex = 0
        local chance = math.random(0, 100)
        if  chance <= 15 then
            Isaac.Spawn(5, 40, 0, npc.Position, Vector.Zero, npc)
        end
    end
end)

