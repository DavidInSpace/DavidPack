

local coinflipItems = {
    david_pack.Collectible.POWERFUL_COINFLIP,
    david_pack.Collectible.MISERABLE_COINFLIP,
    david_pack.Collectible.BLESSED_COINFLIP,
    david_pack.Collectible.SWIFT_COINFLIP
}

function david_pack:setCoinflipMinUsableCharge()
    --print("Right One")
    return 0
end

function david_pack:slotUpdate(entitySlot)
--print("Slot Data:", entitySlot:GetPrizeType(), entitySlot:GetState())

if entitySlot:GetState() == SlotState.DESTROYED then return end
    if entitySlot:GetPrizeType() >= 10 and entitySlot:GetPrizeType() <= 13 and (entitySlot:GetState() == SlotState.REWARD or entitySlot:GetState() == SlotState.PAYOUT) then
        local random = math.random(1, 100)  
        if random <= 5 then
            for _, entity in pairs(Isaac.GetRoomEntities()) do
                -- TODO: make so the game searches for the nearest coin to the slot machine to convert it
                if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COIN and entity.SubType == CoinSubType.COIN_PENNY then
                    entity.Position = Game():GetRoom():FindFreeTilePosition(Game():GetRoom():GetCenterPos(), 3)
                    entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, coinflipItems[math.random(1, 3)], false, false, false)
                    break
                end
            end
        end
    end
end
--or david_pack.Collectible.MISERABLE_COINFLIP or david_pack.Collectible.BLESSED_COINFLIP or david_pack.Collectible.SWIFT_COINFLIP


david_pack:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, david_pack.setCoinflipMinUsableCharge, david_pack.Collectible.POWERFUL_COINFLIP)
david_pack:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, david_pack.setCoinflipMinUsableCharge, david_pack.Collectible.MISERABLE_COINFLIP)
david_pack:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, david_pack.setCoinflipMinUsableCharge, david_pack.Collectible.BLESSED_COINFLIP)
david_pack:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, david_pack.setCoinflipMinUsableCharge, david_pack.Collectible.SWIFT_COINFLIP)
david_pack:AddCallback(ModCallbacks.MC_PRE_SLOT_UPDATE, david_pack.slotUpdate, SlotVariant.SLOT_MACHINE)