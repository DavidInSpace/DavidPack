local mod = david_pack

---@param player EntityPlayer
function david_pack:activeWormPickup(player)

end

function david_pack:activeWormDrop(_, _, player)

end

---@param player EntityPlayer
function mod:evaluateActiveWormCache(player, cacheFlags)
    if player:HasTrinket(mod.Trinket.ACTIVE_WORM) then
        if cacheFlags & CacheFlag.CACHE_SHOTSPEED == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + 0.5
        end

        if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage - 0.5
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.evaluateActiveWormCache)
mod:AddCallback(ModCallbacks.MC_PRE_ADD_TRINKET, mod.activeWormPickup, mod.Trinket.ACTIVE_WORM)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_TRINKET, mod.activeWormDrop,
    mod.Trinket.ACTIVE_WORM)
