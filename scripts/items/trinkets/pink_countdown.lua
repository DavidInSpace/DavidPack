local mod = david_pack
local sfx = SFXManager()


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, function(_, slot, position, scale, player, cropOffset)
    if player:HasTrinket(mod.Trinket.PINK_COUNTDOWN) then
        local runSave = mod.SaveManager.GetRunSave()
        if runSave.pink_countdown_number == 0 then
            return { CropOffset = Vector(96, 0) }
        elseif runSave.pink_countdown_number == 1 then
            return { CropOffset = Vector(64, 0) }
        elseif runSave.pink_countdown_number == 2 then
            return { CropOffset = Vector(32, 0) }
        elseif runSave.pink_countdown_number == 3 then
            return { CropOffset = Vector(0, 0) }
        end
    elseif not player:HasTrinket(TrinketType.TRINKET_MONKEY_PAW) and not player:HasTrinket(mod.Trinket.PINK_COUNTDOWN) and not player:HasTrinket(mod.Trinket.ORANGE_COUNTDOWN) and not player:HasTrinket(mod.Trinket.RGB_COUNTDOWN) then
        return { CropOffset = Vector(0, 0) }
    end
end)


---@param entity Entity
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, damage, damageFlag, source, damageCountdown)
    local player = entity:ToPlayer()
    --print("holds?", player:HasTrinket(mod.Trinket.PINK_COUNTDOWN))
    if player == nil or not player:HasTrinket(mod.Trinket.PINK_COUNTDOWN) or damageFlag == DamageFlag.DAMAGE_FAKE then return end
    local runSave = mod.SaveManager.GetRunSave()
    runSave.pink_countdown_number = runSave.pink_countdown_number or 3
    runSave.pink_countdown_number = runSave.pink_countdown_number - 1

    if runSave.pink_countdown_number < 0 then
        runSave.pink_countdown_number = 3
    end

    print("damaged", runSave.pink_countdown_number)
end, EntityType.ENTITY_PLAYER)

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, function(_, player, trinketType, firstTime)
    print(mod.SaveManager.GetRunSave().pink_countdown_number)
    mod.SaveManager.GetRunSave().pink_countdown_number = 3
end, mod.Trinket.PINK_COUNTDOWN)

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_TRINKET, function(_, _, _, player, _, _, droppedTrinket)
    print(mod.SaveManager.GetRunSave().pink_countdown_number)
    if mod.SaveManager.GetRunSave().pink_countdown_number ~= nil and mod.SaveManager.GetRunSave().pink_countdown_number < 3 then
        droppedTrinket:Remove()
        player:AddTrinket(mod.Trinket.PINK_COUNTDOWN)
    end
end, mod.Trinket.PINK_COUNTDOWN)
