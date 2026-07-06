local mod = david_pack

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, _, _, _, _, _, player)
    player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, true)
    player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_CONTINUUM, false)
    mod.actionsPermission.canShoot = { false, true, false, true }
end, mod.Collectible.OVERBENT_SPOON)


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, function(_, player, collectibleID)
    mod.actionsPermission.canShoot = { true, true, true, true }
end, mod.Collectible.OVERBENT_SPOON)


mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, _, player)
    local overbentSpoon = mod:findEntity(5, 100, CollectibleType.COLLECTIBLE_SPOON_BENDER):ToPickup()
    if overbentSpoon == nil then return end
    mod:triggerAnimation(overbentSpoon, "spoon_bender_transform_animation", 50)
end, Card.CARD_TOWER)


mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, _, player)
    local overbentSpoon = mod:findEntity(5, 100, mod.Collectible.OVERBENT_SPOON):ToPickup()
    if overbentSpoon == nil then return end
    mod:triggerAnimation(overbentSpoon, "spoon_bender_transform_animation", 50)
end, Card.CARD_REVERSE_TOWER)


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(mod.Collectible.OVERBENT_SPOON) then
        player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPOON_BENDER, true)
        player:AddCollectibleEffect(CollectibleType.COLLECTIBLE_CONTINUUM, false)
        mod.actionsPermission.canShoot = { false, true, false, true }
    end
end)


---@param tear EntityTear
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local player = Isaac.GetPlayer()
    if player:HasCollectible(mod.Collectible.OVERBENT_SPOON) then
        tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        tear:AddTearFlags(TearFlags.TEAR_CONTINUUM)
    end
end)
