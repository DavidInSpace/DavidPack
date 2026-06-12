function david_pack:onExpiredLotteryTicketUse()
    local player = Isaac.GetPlayer()
    local playerEffects = player:GetEffects()
    playerEffects:AddNullEffect(david_pack.NullItem.GAMBLING_ADDICT_TRANSFORMATION_COUNTER)
    SFXManager():Play(SoundEffect.SOUND_PENNYPICKUP, 1)
    SFXManager():Play(SoundEffect.SOUND_NICKELPICKUP, 1)
    SFXManager():Play(SoundEffect.SOUND_DIMEPICKUP, 1)
    if playerEffects:GetNullEffectNum(david_pack.NullItem.GAMBLING_ADDICT_TRANSFORMATION_COUNTER) >= 3 then
        if playerEffects:HasNullEffect(david_pack.NullItem.GAMBLING_ADDICT_TRANSFORMATION) == false then
            Game():GetHUD():ShowItemText("Gambling Addict!", "", false)
            Isaac.Spawn(1000, 15, 0, player.Position, Vector.Zero, player)
            SFXManager():Play(SoundEffect.SOUND_ULTRA_GREED_COINS_FALLING, 1)
            local roomConfigStage = RoomConfig.GetStage(StbType.SPECIAL_ROOMS)
            for i = 0, roomConfigStage:GetRoomSet(0).Size do
                local room = roomConfigStage:GetRoomSet(0):Get(i)
                if room == nil then return end
                if room.Name == "[DP] Gambling Room" then
                    Isaac.ExecuteCommand("goto s.arcade." .. room.Variant)
                    break
                end
            end
            playerEffects:AddNullEffect(david_pack.NullItem.GAMBLING_ADDICT_TRANSFORMATION)
        end
    end
end

david_pack:AddCallback(ModCallbacks.MC_USE_CARD, david_pack.onExpiredLotteryTicketUse,
    david_pack.Card.EXPIRED_LOTTERY_TICKET)
