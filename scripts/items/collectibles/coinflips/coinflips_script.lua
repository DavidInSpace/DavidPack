local COINFLIP_ITEMS = {
    david_pack.Collectible.POWERFUL_COINFLIP,
    david_pack.Collectible.MISERABLE_COINFLIP,
    david_pack.Collectible.BLESSED_COINFLIP,
    david_pack.Collectible.SWIFT_COINFLIP
}

function david_pack:setCoinflipMinUsableCharge()
    return 0
end

---@param entitySlot EntitySlot
david_pack:AddCallback(ModCallbacks.MC_PRE_SLOT_UPDATE, function(_, entitySlot)
    if entitySlot:GetState() == SlotState.DESTROYED then return end
    if entitySlot:GetPrizeType() >= 10 and entitySlot:GetPrizeType() <= 13 and (entitySlot:GetState() == SlotState.PAYOUT or entitySlot:GetState() == SlotState.REWARD) then
        local random = math.random(1, 100)
        if random <= 1 then
            local spawn_position = entitySlot.Position + david_pack:getRandomVector(-80, 80, 20, 100)
            print(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, COINFLIP_ITEMS[math.random(1, 4)],
                spawn_position, Vector.Zero, nil)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                COINFLIP_ITEMS[math.random(1, 4)], spawn_position, Vector.Zero, nil)
        end
    end
end, SlotVariant.SLOT_MACHINE)

--or david_pack.Collectible.MISERABLE_COINFLIP or david_pack.Collectible.BLESSED_COINFLIP or david_pack.Collectible.SWIFT_COINFLIP


david_pack:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, david_pack.setCoinflipMinUsableCharge,
    david_pack.Collectible.POWERFUL_COINFLIP)
david_pack:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, david_pack.setCoinflipMinUsableCharge,
    david_pack.Collectible.MISERABLE_COINFLIP)
david_pack:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, david_pack.setCoinflipMinUsableCharge,
    david_pack.Collectible.BLESSED_COINFLIP)
david_pack:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, david_pack.setCoinflipMinUsableCharge,
    david_pack.Collectible.SWIFT_COINFLIP)
