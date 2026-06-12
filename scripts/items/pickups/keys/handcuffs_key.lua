---@param entityPickup EntityPickup
---@param collider Entity
function david_pack:handcuffsKeyCollision(entityPickup, collider)
    if entityPickup.Variant == 30 and entityPickup.SubType == david_pack.Pickup.HANDCUFFS_KEY and collider.Type == EntityType.ENTITY_PLAYER then
        local handcuffsKeySprite = entityPickup:GetSprite()
        --print("animation: ", handcuffsKeySprite:GetAnimationData("Collect"):GetLength())
        if handcuffsKeySprite:IsPlaying("Idle") then
            --print("Pickup handcuffs key")
            handcuffsKeySprite:Play("Collect")
        end

    end
end

---@param entityPickup EntityPickup
function david_pack:updateHandcuffsKey(entityPickup)
     if entityPickup.Variant == 30 and entityPickup.SubType == david_pack.Pickup.HANDCUFFS_KEY then
        local handcuffsKeySprite = entityPickup:GetSprite()
        if handcuffsKeySprite:IsFinished("Collect") then
            entityPickup:Remove()
        end
    end
end

david_pack:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, david_pack.handcuffsKeyCollision)
david_pack:AddCallback(ModCallbacks.MC_PRE_PICKUP_UPDATE, david_pack.updateHandcuffsKey)
