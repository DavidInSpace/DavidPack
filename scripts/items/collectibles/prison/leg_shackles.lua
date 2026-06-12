local mod = david_pack
local sfx = SFXManager()

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlags)
    if player:HasCollectible(david_pack.Collectible.LEG_SHACKLES) then
        local copyCount = player:GetCollectibleNum(david_pack.Collectible.LEG_SHACKLES)
        if cacheFlags & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
            if player.MoveSpeed > 0.8 then
                local removeSpeed = player.MoveSpeed - 0.8 / copyCount
                player.MoveSpeed = player.MoveSpeed - removeSpeed
            else
                player.MoveSpeed = player.MoveSpeed
            end
        end
    end
end)


local function tripOverIsaac()

end

local function isaacTripOverChance(probability)
    local chance = math.random(1, 100)
    if chance <= probability then
        return true
    else
        return false
    end
end

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_UPDATE, function(_, player)
    if not player:HasCollectible(mod.Collectible.LEG_SHACKLES) then return end
    Game():GetRoom():GetGridEntityFromPos(player.Position)
    sfx:Play(SoundEffect.SOUND_SHOVEL_DROP, 1.5, 2, false, 0.9)
end, mod.Collectible.LEG_SHACKLES)

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, function(_, player)
    if not player:HasCollectible(mod.Collectible.LEG_SHACKLES) then return end
    sfx:Play(SoundEffect.SOUND_SHOVEL_DROP, 1.5, 2, false, 0.9)
end, mod.Collectible.LEG_SHACKLES)
