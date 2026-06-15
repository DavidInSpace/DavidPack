

david_pack:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function (_, item, _, firsttime, _, _, player)
    --if not firsttime then return end

    if
        item == david_pack.Collectible.RISK_OF_GAMBLING or
        item == david_pack.Collectible.POWERFUL_COINFLIP or
        item == david_pack.Collectible.MISERABLE_COINFLIP or
        item == david_pack.Collectible.BLESSED_COINFLIP or
        item == david_pack.Collectible.SWIFT_COINFLIP or
        item == CollectibleType.COLLECTIBLE_PORTABLE_SLOT
    then
        local playerEffects = player:GetEffects()
        playerEffects:AddNullEffect(david_pack.NullItem.GAMBLING_ADDICT_TRANSFORMATION_COUNTER)
        if playerEffects:GetNullEffectNum(david_pack.NullItem.GAMBLING_ADDICT_TRANSFORMATION_COUNTER) >= 3 and playerEffects:HasNullEffect(david_pack.NullItem.GAMBLING_ADDICT_TRANSFORMATION) == false then
            Game():GetHUD():ShowItemText("Gambling Addict!", "", false)
            Isaac.Spawn(1000, 15, 0, player.Position, Vector.Zero, player)
            SFXManager():Play(SoundEffect.SOUND_ULTRA_GREED_COINS_FALLING, 1.5)
            SFXManager():Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY, 1)
            playerEffects:AddNullEffect(david_pack.NullItem.GAMBLING_ADDICT_TRANSFORMATION)
        end
    end
end)

david_pack:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, function (_, _, _, isPostLevelInitFinished)
    local player = Isaac.GetPlayer()
    if isPostLevelInitFinished == false then return end
    if Game():GetLevel():GetDimension() ~= Dimension.NORMAL then return end
    local playerEffects = player:GetEffects()
    if playerEffects:HasNullEffect(david_pack.NullItem.GAMBLING_ADDICT_TRANSFORMATION) then
        local roomConfigStage = RoomConfig.GetStage(StbType.SPECIAL_ROOMS)
        for i = 0, roomConfigStage:GetRoomSet(0).Size do
            local room = roomConfigStage:GetRoomSet(0):Get(i)
            if room == nil then return end
            if room.Name == "[DP] Gambling Room" then
                Isaac.ExecuteCommand("goto s.arcade." .. room.Variant)
                break
            end
        end
    end
end, david_pack.teleportToGamblingRoom)
