local sfx = SFXManager()

david_pack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer()
    if not player:HasCollectible(david_pack.Collectible.A_BIT_OF_CHAOS) then return end
    local runSaveData = david_pack.SaveManager.GetRunSave()
    runSaveData.ABitOfChaos = runSaveData.ABitOfChaos or { 0, 0 }
    local currentRoomStageID = Game():GetLevel():GetCurrentRoomDesc().Data.StageID
    local currentRoomVariant = Game():GetLevel():GetCurrentRoomDesc().Data.Variant
    local currentRoomShape = Game():GetLevel():GetCurrentRoomDesc().Data.Shape
    local currentRoomGridIndex = Game():GetLevel():GetCurrentRoomDesc().GridIndex
    local runSeed = Game():GetSeeds():GetStartSeed()
    for i = 1, 2 do
        local roomInt = currentRoomVariant + currentRoomShape + currentRoomStageID + currentRoomGridIndex
        local pool = RNG(runSeed + roomInt + i):RandomInt(1, 30)
        local randomCollectible
        randomCollectible = Game():GetItemPool():GetCollectible(pool, false, runSeed + roomInt + i,
            CollectibleType.COLLECTIBLE_NULL, GetCollectibleFlag.BAN_ACTIVES)
        if runSaveData.ABitOfChaos[i] ~= nil and runSaveData.ABitOfChaos[i] ~= 0 then
            player:RemoveCollectible(runSaveData.ABitOfChaos[i], true)
            player:TryRemoveCollectibleCostume(runSaveData.ABitOfChaos[i], false)
        end
        player:AddCollectible(randomCollectible, 0, false, 0)
        runSaveData.ABitOfChaos[i] = runSaveData.ABitOfChaos[i] and randomCollectible or randomCollectible
    end
end)

david_pack:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function()
    for i = 0, 15 do
        sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 0.8 - (i / 15), 2, false, math.random(85, 120) / 100)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, 0, Isaac.GetPlayer().Position, Vector(0, 0),
            nil)
    end
    david_pack:changeABitOfChaosItems()
end, david_pack.Collectible.A_BIT_OF_CHAOS)
