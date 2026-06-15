local blindfolded = false
local canDoubleFamiliars = true


---@param player EntityPlayer
function david_pack:blindfoldIsaac(player)
    blindfolded = true
    player:SetCanShoot(false)
end

function david_pack:unblindfoldIsaac(_, _, player)
    if Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_DARKNESS == LevelCurse.CURSE_OF_DARKNESS then
        for _, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TRINKET and entity.SubType == david_pack.Trinket.BLINDFOLD then
                entity:Remove()
                player:AddTrinket(david_pack.Trinket.BLINDFOLD)
            end
        end
    else
        blindfolded = false
        player:SetCanShoot(true)
    end
end

david_pack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function ()
    local player = Isaac.GetPlayer()
    if blindfolded and player:HasTrinket(david_pack.Trinket.BLINDFOLD) then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS, UseFlag.USE_NOANIM)
    end
end)


david_pack:AddCallback(ModCallbacks.MC_PRE_ADD_TRINKET, david_pack.blindfoldIsaac, david_pack.Trinket.BLINDFOLD)
david_pack:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_TRINKET, david_pack.unblindfoldIsaac,
    david_pack.Trinket.BLINDFOLD)
