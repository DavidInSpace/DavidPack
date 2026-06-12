local sfx = SFXManager()
---@param entity Entity
function david_pack:triggerAnimation(entity, data, animationlength)
    --print("change entity data")
    entity:GetData().animation = data
    entity:GetData().animationFrames = animationlength
end

---@param entity EntityPickup
function david_pack:brokenMonitorTransformAnimation(entity)
    if entity:GetData().animation == "broken_monitor_transform_animation" and entity ~= nil then
        david_pack.actionsPermission.canTakeDamage = false
        entity:GetData().animationFrames = entity:GetData().animationFrames - 1
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CHAIN_LIGHTNING, 0, entity.Position, Vector(0, 0), nil)
            :ToEffect():SetDamageSource(EntityType.ENTITY_NULL)
        entity:GetColor():SetTint(entity:GetColor():GetTint().R - 0.015, entity:GetColor():GetTint().G - 0.015,
            entity:GetColor():GetTint().B - 0.015, 1)

        if entity:GetData().animationFrames < 10 and entity:GetData().animationFrames > 0 then
            sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1.5, 2, false, 0.8)
            if david_pack.SaveManager.GetSettingsSave().shake == 1 then
                if david_pack.SaveManager.GetSettingsSave().shake == 1 then
                    Game():ShakeScreen(30)
                end
            end

            entity:GetColor():SetTint(entity:GetColor():GetTint().R, entity:GetColor():GetTint().G,
                entity:GetColor():GetTint().B, entity:GetColor():GetTint().A - 0.1)
        end

        if entity:GetData().animationFrames == 0 then
            sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1.5, 2, false, 0.8)
            sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1.5, 2, false, 0.9)
            if david_pack.SaveManager.GetSettingsSave().shake == 1 then
                Game():ShakeScreen(35)
            end
            entity:GetData().animation = nil
            entity:GetData().animationFrames = 0
            entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                david_pack.Collectible.BROKEN_MONITOR, false, false, true)
            entity.Wait = 0
            Game():MakeShockwave(entity.Position, 0.2, 0.04, 15)
            entity:GetColor():Reset()
            david_pack.actionsPermission.canTakeDamage = true
        end
    end
end

david_pack:AddCallback(ModCallbacks.MC_PRE_PICKUP_UPDATE, david_pack.brokenMonitorTransformAnimation,
    PickupVariant.PICKUP_COLLECTIBLE)






---@param entity EntityPickup
function david_pack:spoonBenderTransformAnimation(entity)
    if entity:GetData().animation == "spoon_bender_transform_animation" and entity ~= nil then
        david_pack.actionsPermission.canTakeDamage = false
        entity:GetData().animationFrames = entity:GetData().animationFrames - 1
        local fireJetEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 0, entity.Position -  Vector(math.random(-200, 200), math.random(-200, 200)),
            Vector.Zero, nil):ToEffect():GetColor():SetColorize(1, 0, 1, 1)
        --fireJetEffect:GetColor():SetColorize(1, 0, 1, 1)
        entity:GetColor():SetTint(entity:GetColor():GetTint().R + 0.04, entity:GetColor():GetTint().G + 0.04,
            entity:GetColor():GetTint().B + 0.04, 1)

        if entity:GetData().animationFrames < 10 and entity:GetData().animationFrames > 0 then
            --sfx:Play(SoundEffect.SOUND_SHOVEL_DROP, 1.5, 2, false, 1)
            if david_pack.SaveManager.GetSettingsSave().shake == 1 then
                if david_pack.SaveManager.GetSettingsSave().shake == 1 then
                    Game():ShakeScreen(10)
                end
            end

            entity:GetColor():SetTint(entity:GetColor():GetTint().R, entity:GetColor():GetTint().G,
                entity:GetColor():GetTint().B, entity:GetColor():GetTint().A - 0.1)
        end

        if entity:GetData().animationFrames == 0 then
            sfx:Play(SoundEffect.SOUND_SHOVEL_DROP, 1.5, 2, false, 0.8)
            if david_pack.SaveManager.GetSettingsSave().shake == 1 then
                Game():ShakeScreen(15)
            end
            entity:GetData().animation = nil
            entity:GetData().animationFrames = 0
            entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                CollectibleType.COLLECTIBLE_SPOON_BENDER, false, false, true)
            entity.Wait = 0
            Game():MakeShockwave(entity.Position, 0.02, 0.01, 5)
            entity:GetColor():Reset()
            david_pack.actionsPermission.canTakeDamage = true
        end
    end
end

david_pack:AddCallback(ModCallbacks.MC_PRE_PICKUP_UPDATE, david_pack.spoonBenderTransformAnimation,
    PickupVariant.PICKUP_COLLECTIBLE)
