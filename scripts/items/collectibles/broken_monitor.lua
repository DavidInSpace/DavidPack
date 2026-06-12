local sfx = SFXManager()

local brokenMonitorSequence = false
local brokenMonitorSequencePickedUpItems = 0

---@param player EntityPlayer
function david_pack:onBrokenMonitorUse(_, _, player)
    sfx:Play(SoundEffect.SOUND_GLASS_BREAK, 1, 2, false, 0.9)
    sfx:Play(SoundEffect.SOUND_GLASS_BREAK, 1, 2, false, 1.1)
    Options.WindowWidth = 1250
    Options.WindowHeight = 830
    player:AddCollectible(david_pack.Collectible.BROKEN_MONITOR_PASSIVE)
    local roomConfigStage = RoomConfig.GetStage(StbType.SPECIAL_ROOMS)
    for i = 0, roomConfigStage:GetRoomSet(0).Size do
        local room = roomConfigStage:GetRoomSet(0):Get(i)
        if room == nil then return end
        if room.Name == "[DP] Broken Monitor Room" then
            Isaac.ExecuteCommand("goto s.default." .. room.Variant)
            Options.Fullscreen = false
            brokenMonitorSequence = true
            david_pack.actionsPermission.canExitRoom = { false, 1 }
            break
        end
    end

    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true,
    }
end

local function isWindowResized()
    if Options.WindowWidth > 1245 and Options.WindowWidth < 1255 and Options.WindowHeight > 825 and Options.WindowHeight < 835 then return true else return false end
end

---@param player EntityPlayer
david_pack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
    if not player:HasCollectible(david_pack.Collectible.BROKEN_MONITOR_PASSIVE) or Options.Fullscreen == false or not isWindowResized then return end


    local runSaveData = david_pack.SaveManager.GetRunSave()
    if runSaveData then
        player:RemoveCollectible(david_pack.Collectible.BROKEN_MONITOR_PASSIVE)
        --print(runSaveData.broken_monitor[1], runSaveData.broken_monitor[2])
        player:RemoveCollectible(runSaveData.broken_monitor[1])
        player:RemoveCollectible(runSaveData.broken_monitor[2])
        player:RemoveCollectible(runSaveData.broken_monitor[3])
        runSaveData.broken_monitor[1] = runSaveData.broken_monitor[1] or 1
        runSaveData.broken_monitor[2] = runSaveData.broken_monitor[2] or 1
        runSaveData.broken_monitor[3] = runSaveData.broken_monitor[3] or 1
        sfx:Play(SoundEffect.SOUND_STATIC, 5, 2, false, 1.2)
        sfx:Play(SoundEffect.SOUND_STATIC, 5, 2, false, 0.8)
        sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 5, 2, false, 1.2)
        if david_pack.SaveManager.GetSettingsSave().shake == 1 then
            Game():ShakeScreen(30)
        end
    end
end)

function david_pack:onBrokenMonitorPickup()
    sfx:Play(SoundEffect.SOUND_STATIC, 5, 2, false, 1.2)
end

---@param pickedUpCollectible CollectibleType
function david_pack:brokenMonitorSequenceCollectiblePickup(pickedUpCollectible)
    if not brokenMonitorSequence then return end
    brokenMonitorSequencePickedUpItems = brokenMonitorSequencePickedUpItems + 1

    local runSaveData = david_pack.SaveManager.GetRunSave()
    runSaveData.broken_monitor = runSaveData.broken_monitor or { 1, 1, 1 }
    if brokenMonitorSequencePickedUpItems == 1 then
        if runSaveData then
            runSaveData.broken_monitor[1] = runSaveData.broken_monitor[1] and pickedUpCollectible or pickedUpCollectible
        end
    elseif brokenMonitorSequencePickedUpItems == 2 then
        if runSaveData then
            runSaveData.broken_monitor[2] = runSaveData.broken_monitor[2] and pickedUpCollectible or pickedUpCollectible
        end
        local roomCollectibles = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)

        for _, collectible in pairs(roomCollectibles) do
            local collectible = collectible:ToPickup()
            if collectible == nil then return end
            collectible.OptionsPickupIndex = 10
        end
    elseif brokenMonitorSequencePickedUpItems > 2 then
        brokenMonitorSequence = false
        brokenMonitorSequencePickedUpItems = 0
        david_pack.actionsPermission.canExitRoom[1] = true
        if runSaveData then
            runSaveData.broken_monitor[3] = runSaveData.broken_monitor[3] and pickedUpCollectible or pickedUpCollectible
        end
    end
    --print(runSaveData.broken_monitor[1], runSaveData.broken_monitor[2], runSaveData.broken_monitor[3])
end

function david_pack:onBrokenMonitorRemove()
end

function david_pack:convertItemsToQ4()
    local roomDescriptor = Game():GetLevel():GetCurrentRoomDesc()
    if not brokenMonitorSequence or not roomDescriptor.Data.Name == "[DP] Broken Monitor Room" then return end
    local roomCollectibles = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
    david_pack.actionsPermission.canReroll = true
    for _, collectible in pairs(roomCollectibles) do
        local pool = math.random(0, 30)
        local randomCollectible = Game():GetItemPool():GetCollectible(pool, false, Random(),
            CollectibleType.COLLECTIBLE_BREAKFAST)
        local randomCollectibleItemConfig = Isaac.GetItemConfig():GetCollectible(randomCollectible)
        while true do
            if tonumber(randomCollectibleItemConfig.Quality) >= 3
                and not randomCollectibleItemConfig:HasTags(ItemConfig.TAG_QUEST) then
                collectible:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                    randomCollectible)
                break
            else
                pool = math.random(0, 30)
                randomCollectible = Game():GetItemPool():GetCollectible(pool, false, Random(),
                    CollectibleType.COLLECTIBLE_BREAKFAST)
                randomCollectibleItemConfig = Isaac.GetItemConfig():GetCollectible(randomCollectible)
            end
        end
    end
    david_pack.actionsPermission.canReroll = false
end

function david_pack:resetBrokenMonitorOnGameStart(continued)
    if not continued then
        brokenMonitorSequence = false
        brokenMonitorSequencePickedUpItems = 0
    end
end


david_pack:AddCallback(ModCallbacks.MC_USE_CARD, function (_, card, player)
    local roomCollectibles = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
    for _, collectible in pairs(roomCollectibles) do
        if collectible.SubType == CollectibleType.COLLECTIBLE_BROKEN_MODEM then
            --print("Collectible Found")
            david_pack:triggerAnimation(collectible, "broken_monitor_transform_animation", 150)
            break
        end
    end
end, Card.CARD_TOWER)

if EID then
    local function brokenModemModifierCondition(descObj)
        if descObj.ObjType == 5 and descObj.ObjVariant == 100 and descObj.ObjSubType == 514 then return true end
    end
    local function brokenModemModifierCallback(descObj)
        EID:appendToDescription(descObj, "#{{ModIcon}} Can be transformed using {{Card17}} The Tower")
        return descObj
    end

    EID:addDescriptionModifier("brokenModem_brokenMonitor", brokenModemModifierCondition, brokenModemModifierCallback)
end


david_pack:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, david_pack.onBrokenMonitorPickup,
    david_pack.Collectible.BROKEN_MONITOR)
david_pack:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, david_pack.brokenMonitorSequenceCollectiblePickup)
david_pack:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, david_pack.onBrokenMonitorRemove,
    david_pack.Collectible.BROKEN_MONITOR)
david_pack:AddCallback(ModCallbacks.MC_USE_ITEM, david_pack.onBrokenMonitorUse, david_pack.Collectible.BROKEN_MONITOR)
david_pack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, david_pack.convertItemsToQ4)
david_pack:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, david_pack.resetBrokenMonitorOnGameStart)

