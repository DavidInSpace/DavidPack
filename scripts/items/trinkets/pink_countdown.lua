local mod = {}

local COUNT_DOWN_STATES = {
    "gfx/items/trinkets/PinkNeonCountdown0.png",
    "gfx/items/trinkets/PinkNeonCountdown1.png",
    "gfx/items/trinkets/PinkNeonCountdown2.png",
    "gfx/items/trinkets/PinkNeonCountdown3.png",
}


---@param entity Entity
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, damage, damageFlag, source, damageCountdown)
    local player = entity:ToPlayer()
    --print("holds?", player:HasTrinket(mod.Trinket.PINK_COUNTDOWN))
    if player == nil or not player:HasTrinket(mod.Trinket.PINK_COUNTDOWN) or damageFlag == DamageFlag.DAMAGE_FAKE then return end
    local runSave = mod.SaveManager.GetRunSave()
    runSave.pink_countdown_number = runSave.pink_countdown_number or 3
    runSave.pink_countdown_number = runSave.pink_countdown_number - 1

    if runSave.pink_countdown_number == 3 then
        print("3 sprite")
        Isaac.GetItemConfig():GetTrinket(mod.Trinket.PINK_COUNTDOWN).GfxFileName = COUNT_DOWN_STATES[4]
    elseif runSave.pink_countdown_number == 2 then
        print("2 sprite")
        Isaac.GetItemConfig():GetTrinket(mod.Trinket.PINK_COUNTDOWN).GfxFileName = COUNT_DOWN_STATES[3]
    elseif runSave.pink_countdown_number == 1 then
        print("1 sprite")
        Isaac.GetItemConfig():GetTrinket(mod.Trinket.PINK_COUNTDOWN).GfxFileName = COUNT_DOWN_STATES[2]
    elseif runSave.pink_countdown_number == 0 then
        print("0 sprite")
        Isaac.GetItemConfig():GetTrinket(mod.Trinket.PINK_COUNTDOWN).GfxFileName = COUNT_DOWN_STATES[1]
    elseif runSave.pink_countdown_number < 0 then
        Isaac.GetItemConfig():GetTrinket(mod.Trinket.PINK_COUNTDOWN).GfxFileName = COUNT_DOWN_STATES[4]
        runSave.pink_countdown_number = 3
    end
    print("damaged", runSave.pink_countdown_number)
end, EntityType.ENTITY_PLAYER)

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, function(_, player, trinketType, firstTime)
    mod.SaveManager.GetRunSave().pink_countdown_number = 3
    Isaac.GetItemConfig():GetTrinket(mod.Trinket.PINK_COUNTDOWN).GfxFileName = COUNT_DOWN_STATES[4]
end, mod.Trinket.PINK_COUNTDOWN)

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_TRINKET, function(_, _, _, player, _, _, droppedTrinket)
    print(mod.SaveManager.GetRunSave().pink_countdown_number)
    if mod.SaveManager.GetRunSave().pink_countdown_number ~= nil and mod.SaveManager.GetRunSave().pink_countdown_number < 3 then
        droppedTrinket:Remove()
        player:AddTrinket(mod.Trinket.PINK_COUNTDOWN)
    end
end, mod.Trinket.PINK_COUNTDOWN)
