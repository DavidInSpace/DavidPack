local mod = david_pack
local sfx = SFXManager()


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, function(_, slot, position, scale, player, cropOffset)
    if player:HasTrinket(mod.Trinket.ORANGE_COUNTDOWN) then
        local runSave = mod.SaveManager.GetRunSave()
        if runSave.orange_countdown_number == 0 then
            return { CropOffset = Vector(96, 0) }
        elseif runSave.orange_countdown_number == 1 then
            return { CropOffset = Vector(64, 0) }
        elseif runSave.orange_countdown_number == 2 then
            return { CropOffset = Vector(32, 0) }
        elseif runSave.orange_countdown_number == 3 then
            return { CropOffset = Vector(0, 0) }
        end
    elseif not player:HasTrinket(TrinketType.TRINKET_MONKEY_PAW) and not player:HasTrinket(mod.Trinket.PINK_COUNTDOWN) and not player:HasTrinket(mod.Trinket.ORANGE_COUNTDOWN) and not player:HasTrinket(mod.Trinket.RGB_COUNTDOWN) then
        return { CropOffset = Vector(0, 0) }
    end
end)

function mod.orangeCountdown()
        local player = Isaac.GetPlayer()
    local room = Game():GetRoom()
    --print("holds?", player:HasTrinket(mod.Trinket.ORANGE_COUNTDOWN))
    if player == nil or not player:HasTrinket(mod.Trinket.ORANGE_COUNTDOWN) then return end
    local runSave = mod.SaveManager.GetRunSave()
    sfx:Play(SoundEffect.SOUND_NICKELPICKUP, 1, 2, false, 1.5)
    sfx:Play(SoundEffect.SOUND_DIMEPICKUP, 1, 2, false, 0.5)

    if runSave.rgb_countdown_number < 1 then
        local count = Isaac.GetFrameCount()
    end

    print("damaged", runSave.orange_countdown_number)
end


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, function(_, player, trinketType, firstTime)
    print(mod.SaveManager.GetRunSave().orange_countdown_number)
    mod.SaveManager.GetRunSave().orange_countdown_number = 3
            local count = Isaac.GetFrameCount()
        mod.wait.new(count, math.random(500, 15000), mod.orangeCountdown)
end, mod.Trinket.ORANGE_COUNTDOWN)


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_TRINKET, function(_, _, _, player, _, _, droppedTrinket)
    print(mod.SaveManager.GetRunSave().orange_countdown_number)
    if mod.SaveManager.GetRunSave().orange_countdown_number ~= nil and mod.SaveManager.GetRunSave().orange_countdown_number < 3 then
        droppedTrinket:Remove()
        player:AddTrinket(mod.Trinket.ORANGE_COUNTDOWN)
    end
end, mod.Trinket.ORANGE_COUNTDOWN)
